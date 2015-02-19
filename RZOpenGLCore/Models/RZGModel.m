//
//  RZGModel.m
//  RZGOGL
//
//  Created by John Stricker on 11/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZGModel.h"
#import "RZGPrs.h"
#import "RZGAssetManager.h"
#import "RZGVaoInfo.h"
#import "RZGShaderManager.h"
#import "RZGDefaultShaderSettings.h"
#import "RZGCommand.h"
#import "RZGCommandPath.h"
#import "RZGOpenGLManager.h"
#import "RZGScreenToGLConverter.h"
#import  <OpenGLES/ES2/glext.h>

@interface RZGModel()


@end

@implementation RZGModel

- (instancetype)initWithModelFileName:(NSString*)modelFileName
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    _prs = [RZGPrs new];
    _prs.pz = -50.0f;
    _alpha = 1.0f;
    _diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    _shadowMax = 0.5;
    _useDepthTest = YES;
    
    //for some subclasses a .model file will not be used on init
    if(modelFileName)
    {
        _vaoInfo = [RZGAssetManager loadVaoInfo:modelFileName];
    }
    _commands = [[NSMutableArray alloc] init];
    _finishedCommands = [[NSMutableArray alloc] init];
    
    return self;
}

- (instancetype) initWithModelFileName:(NSString*)modelFileName UseDefaultSettingsInManager:(RZGOpenGLManager*)manager
{
    self = [self initWithModelFileName:modelFileName];
    
    self.defaultShaderSettings = manager.defaultShaderSettings;
    self.projection = manager.projectionMatrix;
    self.glmgr = manager;
    
    return self;
}

- (void)setProjection:(GLKMatrix4)projection
{
    _projection = GLKMatrix4MakeWithArray(projection.m);
}

- (void)setTexture0Id:(GLuint)texture0Id
{
    _texture0Id = texture0Id;
}

- (void)setDefaultShaderSettings:(RZGDefaultShaderSettings *)defaultShaderSettings
{
    _defaultShaderSettings = defaultShaderSettings;
}

- (void)setDimensions2dX:(GLfloat)x andY:(GLfloat)y
{
    _dimensions2d = CGPointMake(x, y);
}

- (void)addCommand:(RZGCommand *)command
{
    [self.commands addObject:command];
}

- (void)clearAllCommands
{
    [self.commands removeAllObjects];
}

- (void)clearCommandsOfTypes:(NSArray *)commandTypes
{
    NSMutableArray *commandsToErase = [[NSMutableArray alloc] init];
    for(NSNumber *commandEnum in commandTypes)
    {
        for(RZGCommand *command in self.commands)
        {
            if(command.commandEnum == [commandEnum integerValue])
            {
                [commandsToErase addObject:command];
            }
        }
    }
    [self.commands removeObjectsInArray:commandsToErase];
}

- (void)clearCommandsOfType:(NSUInteger)commandType
{
    [self clearCommandsOfTypes:@[[NSNumber numberWithUnsignedInteger:commandType]]];
}

- (void)updateWithTime:(GLfloat)time
{
    [self.prs updateWithTime:time];
    [self updateCommandsWithTime:time];
    [self updateModelViewProjection];
}

- (void)updateCommandsWithTime:(GLfloat)time
{
    //account for delays and process command
    for(RZGCommand *command in self.commands)
    {
        command.delay -= time;
        if(command.delay <= 0.0f)
        {
            [self processCommand:command withTime:time];
        }
        if(command.isFinished)
        {
            [self.finishedCommands addObject:command];
        }
    }
    //clean up finished commands
    for(RZGCommand *command in self.finishedCommands)
    {
        if(command.isFinished)
        {
            [self.commands removeObject:command];
        }
    }
    [self.finishedCommands removeAllObjects];
}

- (void)processCommand:(RZGCommand*)command withTime:(GLfloat)time
{
    
    switch (command.commandEnum)
    {
        // ALPHA //
        case kRZGCommand_alpha:
            if(command.duration == 0.0f)
            {
                self.alpha = command.target.x;
                command.isFinished = YES;
                return;
            }
            else
            {
                if(!command.isStarted)
                {
                    if(command.isAbsolute)
                    {
                        command.step = GLKVector4MakeWith1f((command.target.x - self.alpha)/command.duration);
                    }
                    else
                    {
                        command.step = GLKVector4MakeWith1f(command.target.x/command.duration);
                        command.target = GLKVector4MakeWith1f(command.target.x+self.alpha);
                    }
                    command.isStarted = YES;
                }
                
                command.duration -= time;
                self.alpha += command.step.x * time;
                if(command.duration <= 0.0f)
                {
                    self.alpha = command.target.x;
                    if ( command.completionBlock ) {
                        command.completionBlock();
                    }
                    command.isFinished = YES;
                }
            }
            break;
            // SHADOWMAX //
        case kRZGCommand_shadowMax:
            if(command.duration == 0.0f)
            {
                self.shadowMax = command.target.x;
                command.isFinished = YES;
                return;
            }
            else
            {
                if(!command.isStarted)
                {
                    if(command.isAbsolute)
                    {
                        command.step = GLKVector4MakeWith1f((command.target.x - self.shadowMax)/command.duration);
                    }
                    else
                    {
                        command.step = GLKVector4MakeWith1f(command.target.x/command.duration);
                        command.target = GLKVector4MakeWith1f(command.target.x+self.shadowMax);
                    }
                    command.isStarted = YES;
                }
                
                command.duration -= time;
                self.shadowMax += command.step.x * time;
                if(command.duration <= 0.0f)
                {
                    self.shadowMax = command.target.x;
                    if ( command.completionBlock ) {
                        command.completionBlock();
                    }
                    command.isFinished = YES;
                }
            }
            break;
        
        // VISIBILITY //
        case kRZGCommand_visible:
            if(command.target.x == 0.0f)
            {
                self.isHidden = YES;
            }
            else
            {
                self.isHidden = NO;
            }
            if ( command.completionBlock ) {
                command.completionBlock();
            }
            command.isFinished = YES;
            break;
            
        // CONSTANT ROTATION //
        case kRZGCommand_setConstantRotation:
            [self.prs setRotationConstantToVector:GLKVector3Make(command.target.x, command.target.y, command.target.z)];
            command.isFinished = YES;
            break;
            
        // MOVE TO //
        case kRZGCommand_moveTo:
            if(!command.isStarted)
            {
                command.isStarted = YES;
                
                if(!command.isAbsolute)
                {
                    command.step = GLKVector4Make(command.target.x / command.duration, command.target.y / command.duration, command.target.z / command.duration, 0.0f);
                    command.target = GLKVector4Make(command.target.x + self.prs.px, command.target.y + self.prs.py, command.target.z + self.prs.pz, 0.0f);
                }
                else
                {
                    command.startingValue = GLKVector4MakeWith3f(self.prs.position.x, self.prs.position.y, self.prs.position.z);
                    command.distance = GLKVector4Make((command.target.x - self.prs.px), (command.target.y - self.prs.py), (command.target.z - self.prs.pz), 0.0f);
                    
                }
            }

            command.elapsedTime += time;
            
            if(command.elapsedTime >= command.duration)
            {
                self.prs.position = GLKVector3Make(command.target.x, command.target.y, command.target.z);
                if ( command.completionBlock ) {
                    command.completionBlock();
                }
                command.isFinished = YES;
            }
            else
            {
                float p = command.elapsedTime / command.duration;
                self.prs.position = GLKVector3Make(command.startingValue.x + command.easingFunction(p) * command.distance.x,
                                                   command.startingValue.y + command.easingFunction(p) * command.distance.y,
                                                   command.startingValue.z + command.easingFunction(p) * command.distance.z);
            }
            break;
            
        // MOVE ALONG PATH //
        case kRZGCommand_moveAlongPath:
            if(!command.isStarted)
            {
                command.isStarted = YES;
                
                GLKVector4 target = [command.path getFirstVector];
                command.target = target;
                command.duration = target.w;
                
                if(!command.isAbsolute)
                {
                    command.step = GLKVector4Make(command.target.x / command.duration, command.target.y / command.duration, command.target.z / command.duration, 0.0f);
                    command.target = GLKVector4Make(command.target.x + self.prs.px, command.target.y + self.prs.py, command.target.z + self.prs.pz, 0.0f);
                }
                else
                {
                    command.step = GLKVector4Make((command.target.x - self.prs.px) / command.duration, (command.target.y - self.prs.py) / command.duration, (command.target.z - self.prs.pz) / command.duration, 0.0f);
                }
            }
            
            command.duration -= time;
            
            if(command.duration <= 0.0f)
            {
                self.prs.position = GLKVector3Make(command.target.x, command.target.y, command.target.z);
                if(command.path.currentIndex < command.path.nVectors || command.path.repeat)
                {
                    GLKVector4 target = [command.path getNextVector];
                    command.target = target;
                    command.duration = target.w;
                    
                    if(!command.isAbsolute)
                    {
                        command.step = GLKVector4Make(command.target.x / command.duration, command.target.y / command.duration, command.target.z / command.duration, 0.0f);
                        command.target = GLKVector4Make(command.target.x + self.prs.px, command.target.y + self.prs.py, command.target.z + self.prs.pz, 0.0f);
                    }
                    else
                    {
                        command.step = GLKVector4Make((command.target.x - self.prs.px) / command.duration, (command.target.y - self.prs.py) / command.duration, (command.target.z - self.prs.pz) / command.duration, 0.0f);
                    }
                }
                else
                {
                    if ( command.completionBlock ) {
                        command.completionBlock();
                    }
                    command.isFinished = YES;
                }
            }
            else
            {
                self.prs.position = GLKVector3Make(self.prs.px + command.step.x * time, self.prs.py + command.step.y * time, self.prs.pz + command.step.z * time);
            }
            
            break;
            
            // ROTATE //
        case kRZGCommand_rotateTo:
            if(!command.isStarted)
            {
                command.isStarted = YES;
                
                if(!command.isAbsolute)
                {
                    command.step = GLKVector4Make(command.target.x / command.duration, command.target.y / command.duration, command.target.z / command.duration, 0.0f);
                    command.target = GLKVector4Make(command.target.x + self.prs.rx, command.target.y + self.prs.ry, command.target.z + self.prs.rz, 0.0f);
                }
                else
                {
                    command.step = GLKVector4Make((command.target.x - self.prs.rx) / command.duration, (command.target.y - self.prs.ry) / command.duration, (command.target.z - self.prs.rz) / command.duration, 0.0f);
                }
            }
            
            command.duration -= time;
            
            if(command.duration <= 0.0f)
            {
                [self.prs addVectorToRotation:GLKVector3Make(command.target.x, command.target.y, command.target.z)];
                if ( command.completionBlock ) {
                    command.completionBlock();
                }
                command.isFinished = YES;
            }
            else
            {
                [self.prs addVectorToRotation: GLKVector3Make(self.prs.rx + command.step.x * time, self.prs.ry + command.step.y * time, self.prs.rz + command.step.z * time)];
            }
            break;
            
        // SCALE
        case kRZGCommand_scaleTo:
            if(!command.isStarted)
            {
                command.isStarted = YES;
                
                if(!command.isAbsolute)
                {
                    command.step = GLKVector4Make(command.target.x / command.duration, command.target.y / command.duration, command.target.z / command.duration, 0.0f);
                    command.target = GLKVector4Make(command.target.x + self.prs.scale.x, command.target.y + self.prs.scale.y, command.target.z + self.prs.scale.z, 0.0f);
                }
                else
                {
                    command.startingValue = GLKVector4MakeWith3f(self.prs.scale.x, self.prs.scale.y, self.prs.scale.z);
                    command.distance = GLKVector4Make((command.target.x - self.prs.scale.x), (command.target.y - self.prs.scale.y), (command.target.z - self.prs.scale.z), 0.0f);
                    
                }
            }
            
            command.elapsedTime += time;
            
            if(command.elapsedTime >= command.duration)
            {
                self.prs.scale = GLKVector3Make(command.target.x, command.target.y, command.target.z);
                if ( command.completionBlock ) {
                    command.completionBlock();
                }
                command.isFinished = YES;
            }
            else
            {
                float p = command.elapsedTime / command.duration;
                self.prs.scale = GLKVector3Make(command.startingValue.x + command.easingFunction(p) * command.distance.x,
                                                   command.startingValue.y + command.easingFunction(p) * command.distance.y,
                                                   command.startingValue.z + command.easingFunction(p) * command.distance.z);
            }
            break;
            
            
        default:
            break;
    }
}

- (void)updateModelViewProjection
{
    GLKVector3 scale = _prs.scale;
    GLKMatrix4 transformationMatrix = GLKMatrix4Identity;
    GLKVector3 newPosition = _prs.position;
    if(self.worldPrs)
    {
        /*
        if(self.worldTransform.orientation)
        {
            transformationMatrix = GLKMatrix4Multiply(transformationMatrix, [self.worldTransform.orientation getRotationMatrix]);
        }
        */
        newPosition.x -= _worldPrs.px;
        newPosition.y -= _worldPrs.py;
        newPosition.z -= _worldPrs.pz;
    }
    
    transformationMatrix = GLKMatrix4Translate(transformationMatrix, newPosition.x, newPosition.y, newPosition.z);
    //GLKMatrix4 projection = GLKMatrix4Translate(_projection, newPosition.x, newPosition.y, 0.0f);
    /*
    if(_orientation)
    {
        transformationMatrix = GLKMatrix4Multiply(transformationMatrix, [self.orientation getRotationMatrix]);
    }
     */

    transformationMatrix = GLKMatrix4Multiply(transformationMatrix, GLKMatrix4MakeWithQuaternion(_prs.rotationQuaternion));
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(transformationMatrix, GLKMatrix4MakeScale(scale.x, scale.y ,scale.z));
    self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    self.modelViewProjection = GLKMatrix4Multiply(_projection, modelViewMatrix);
}


- (void)draw
{
    if(self.isHidden)
    {
        return;
    }
    
    if(self.glmgr){
        if(self.useDepthTest){
            [self.glmgr enableDepthTest];
        }
        else {
            [self.glmgr disableDepthTest];
        }
    }
    
    [RZGShaderManager useProgram:self.defaultShaderSettings.programId];
    
    //set shader uniforms
    [self.defaultShaderSettings setAlpha:self.alpha];
    [self.defaultShaderSettings setDiffuseColor:self.diffuseColor];
    [self.defaultShaderSettings setShadoMax:self.shadowMax];
    [self.defaultShaderSettings setNormalMatrix:self.normalMatrix];
    [self.defaultShaderSettings setModelViewProjectionMatrix:self.modelViewProjection];
    
    glBindVertexArrayOES(_vaoInfo.vaoIndex);
    glBindTexture(GL_TEXTURE_2D,_texture0Id);
    glDrawArrays(GL_TRIANGLES, 0, _vaoInfo.nVerts);
}

@end
