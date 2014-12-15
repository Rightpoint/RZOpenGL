//
//  RZGOpenGLManager.m
//  RZGOGL
//
//  Created by John Stricker on 12/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZGOpenGLManager.h"
#import "RZGShaderManager.h"
#import "RZGDefaultShaderSettings.h"
#import "RZGScreenToGLConverter.h"

static BOOL depthTestEnabled;
static GLKVector4 lastClearColor;

@interface RZGOpenGLManager()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) CGRect lastScreenRect;
@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat nearZ;
@property (nonatomic, assign) CGFloat farZ;

@end

@implementation RZGOpenGLManager

-(instancetype)initWithView:(GLKView*)glkView ScreenSize:(CGSize)size PerspectiveInRadians:(GLfloat)perspective NearZ:(GLfloat)nearZ FarZ:(GLfloat)farZ;

{
    self = [super init];
    if(! self)
    {
        return nil;
    }
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    glkView.context = self.context;
    if(!glkView.context)
    {
        NSLog(@"ERROR: Failed to create ES context");
        return nil;
    }
        
    [EAGLContext setCurrentContext:glkView.context];
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    depthTestEnabled = YES;
    
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    glkView.multipleTouchEnabled = NO;
    
    [self loadDefaultShaderAndSettings];
    
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        size = [UIScreen mainScreen].bounds.size;
    }
    
    self.perspective = perspective;
    self.farZ = farZ;
    self.nearZ = nearZ;
    self.lastScreenRect = CGRectMake(0, 0, size.width, size.height);
    
    CGSize screenSize = size;
    
    GLfloat aspect = fabsf(screenSize.width / screenSize.height);
    
    _projectionMatrix = GLKMatrix4MakePerspective(perspective, aspect, nearZ, farZ);
    
    _zConverter = [[RZGScreenToGLConverter alloc] initWithScreenHeight:screenSize.height ScreenWidth:screenSize.width Fov:perspective];
    
    return self;
}

- (void)updateScreenRect:(CGRect)newScreenRect
{
    if ( !CGRectEqualToRect(self.lastScreenRect, newScreenRect) ) {
        CGSize size = newScreenRect.size;
        if(CGSizeEqualToSize(CGSizeZero, size))
        {
            size = [UIScreen mainScreen].bounds.size;
        }
        
        CGSize screenSize = size;
        
        GLfloat aspect = fabsf(screenSize.width / screenSize.height);
        
        _projectionMatrix = GLKMatrix4MakePerspective(self.perspective, aspect, self.nearZ, self.farZ);
        
        _zConverter = [[RZGScreenToGLConverter alloc] initWithScreenHeight:screenSize.height ScreenWidth:screenSize.width Fov:self.perspective];

    }
}

-(void)loadDefaultShaderAndSettings
{
    GLuint programId = [RZGShaderManager loadModelDefaultShader];
    self.defaultShaderSettings = [[RZGDefaultShaderSettings alloc] initWithProgramId:programId];
}

-(void)loadBitmapFontShaderAndSettings
{
//    GLuint programId = [RZGShaderManager loadBitmapFontShader];
//    self.bitmapFontShaderSettings = [[RZGBitmapFontShaderSettings alloc] initWithProgramId:programId];
}

- (void)loadColoredPSShaderAndSettings {
//    GLuint programId = [RZGShaderManager loadColoredPointSpriteShader];
 //    self.coloredPSShaderSettings = [[RZGColoredPSShaderSettings alloc] initWithProgramId:programId];
}

//Assumes that depth testing is only changed via a manager class
-(void)enableDepthTest
{
    if(!depthTestEnabled)
    {
        glEnable(GL_DEPTH_TEST);
        depthTestEnabled = YES;
    }
}

//Assumes that depth testing is only changed via a manager class
-(void)disableDepthTest
{
    if(depthTestEnabled)
    {
        glDisable(GL_DEPTH_TEST);
        depthTestEnabled = NO;
    }
}

//Assumes that clear color is only changed via a manager class
-(void)setClearColor:(GLKVector4)clearColor
{
    if(!GLKVector4AllEqualToVector4(clearColor, lastClearColor))
    {
        glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
        lastClearColor = clearColor;
    }
}

-(void) unload
{
    if(_defaultShaderSettings)
    {
        glDeleteProgram(_defaultShaderSettings.programId);
    }
    _defaultShaderSettings = nil;
    
    if ( [EAGLContext currentContext] == self.context ) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
    
    [RZGShaderManager useProgram:0];
}
@end
