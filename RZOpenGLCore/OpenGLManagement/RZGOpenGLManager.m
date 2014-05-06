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
//#import "RZGBitmapFontShaderSettings.h"
#import "RZGScreenToGLConverter.h"

static BOOL depthTestEnabled;
static GLKVector4 lastClearColor;

@interface RZGOpenGLManager()
@end

@implementation RZGOpenGLManager

-(instancetype)initWithView:(GLKView*)glkView ScreenSize:(CGSize)size PerspectiveInRadians:(GLfloat)perspective NearZ:(GLfloat)nearZ FarZ:(GLfloat)farZ;

{
    self = [super init];
    if(! self)
    {
        return nil;
    }
    
    glkView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
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
    
    GLfloat aspect = fabsf(size.width / size.height);

    _projectionMatrix = GLKMatrix4MakePerspective(perspective, aspect, nearZ, farZ);
    
    _zConverter = [[RZGScreenToGLConverter alloc] initWithScreenHeight:size.height ScreenWidth:size.width Fov:perspective];
    
    return self;
}

-(void)loadDefaultShaderAndSettings
{
    GLuint programId = [RZGShaderManager loadModelDefaultShader];
    self.defaultShaderSettings = [[RZGDefaultShaderSettings alloc] initWithProgramId:programId];
}

-(void)loadBitmapFontShaderAndSettings
{
 //   GLuint programId = [RZGShaderManager loadBitmapFontShader];
//    self.bitmapFontShaderSettings = [[RZGBitmapFontShaderSettings alloc] initWithProgramId:programId];
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
}
@end
