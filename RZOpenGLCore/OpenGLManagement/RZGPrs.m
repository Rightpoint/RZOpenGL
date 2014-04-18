//
//  RZGPrs.m
//  RZGOGL
//
//  Created by John Stricker on 1/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGPrs.h"
#import "RZGMathUtils.h"

@interface RZGPrs()

@property (nonatomic,readonly) GLKVector3 rotationConstantVector;
@property (nonatomic) BOOL rotationConstantExists;

-(void)updateConstantRotationWithTime:(GLfloat)time;

@end
@implementation RZGPrs

static const GLfloat TWO_PI = M_PI * 2.0f;

-(instancetype) init
{
    self = [super init];
    if(!self)return nil;
    
    _position = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _rotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _rotationQuaternion = GLKQuaternionMakeWithAngleAndAxis(0.0f, 0.0f, 0.0f, 1.0f);
    _scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
    _rotationConstantExists = NO;
    
    return self;
}

#pragma mark position methods
-(GLfloat)px {return _position.x;}
-(GLfloat)py {return _position.y;}
-(GLfloat)pz {return _position.z;}
-(void)setPx:(GLfloat)x {_position.x = x;}
-(void)setPy:(GLfloat)y; {_position.y = y;}
-(void)setPz:(GLfloat)z; {_position.z = z;}

#pragma mark rotation methods
-(GLfloat)rx {return _rotation.x;}
-(GLfloat)ry {return _rotation.y;}
-(GLfloat)rz {return _rotation.z;}
-(void)setRx:(GLfloat)x {
    _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(-_rotation.x, 1.0f, 0.0f, 0.0f));
    _rotation.x = [RZGMathUtils loopClampf:x WithInclusiveMin:-TWO_PI InclusiveMax:TWO_PI];
    _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(_rotation.x, 1.0f, 0.0f, 0.0f));}
-(void)setRy:(GLfloat)y {
      _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(-_rotation.y, 0.0f, 1.0f, 0.0f));
    _rotation.y = [RZGMathUtils loopClampf:y WithInclusiveMin:-TWO_PI InclusiveMax:TWO_PI];
    _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(_rotation.y, 0.0f, 1.0f, 0.0f));}
-(void)setRz:(GLfloat)z {
      _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(-_rotation.z, 0.0f, 0.0f, 1.0f));
    _rotation.z = [RZGMathUtils loopClampf:z WithInclusiveMin:-TWO_PI InclusiveMax:TWO_PI];
    _rotationQuaternion = GLKQuaternionMultiply(_rotationQuaternion, GLKQuaternionMakeWithAngleAndAxis(_rotation.z, 0.0f, 0.0f, 1.0f));}
-(void)addVectorToRotation:(GLKVector3)vector
{
    if(vector.z != 0.0f) self.rz = vector.z;
    if(vector.y != 0.0f) self.ry = vector.y;
    if(vector.x != 0.0f) self.rx = vector.x;
}
-(void)resetRotationWithVector:(GLKVector3)vector
{
    _rotationQuaternion = GLKQuaternionMakeWithAngleAndAxis(0.0f, 0.0f, 0.0f, 1.0f);
    [self addVectorToRotation:vector];
}
-(void)setRotationConstantToVector:(GLKVector3)vector
{
    self.rotationConstantExists = YES;
    _rotationConstantVector = vector;
}
-(void)removeRotationConstant
{
    self.rotationConstantExists = NO;
}
-(void)updateConstantRotationWithTime:(GLfloat)time
{
    if(_rotationConstantVector.z != 0.0f) _rotationQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(_rotationConstantVector.z*time, 0.0f, 0.0f, 1.0f),_rotationQuaternion);
    if(_rotationConstantVector.y != 0.0f) _rotationQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(_rotationConstantVector.y*time, 0.0f, 1.0f, 0.0f),_rotationQuaternion);
    if(_rotationConstantVector.x != 0.0f) _rotationQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(_rotationConstantVector.x*time, 1.0f, 0.0f, 0.0f),_rotationQuaternion);
}

#pragma mark scale methods
-(GLfloat)sx {return _scale.x;}
-(GLfloat)sy {return _scale.y;}
-(GLfloat)sz {return _scale.z;}
-(void)setSx:(GLfloat)x {_scale.x = x;}
-(void)setSy:(GLfloat)y {_scale.y = y;}
-(void)setSz:(GLfloat)z {_scale.z = z;}
-(void)setSxyz:(GLfloat)xyz {_scale = GLKVector3Make(xyz, xyz, xyz);}

#pragma mark update methods
- (void)updateWithTime:(GLfloat)time
{
    if(_rotationConstantExists){
        [self updateConstantRotationWithTime:time];
    }
}

@end
