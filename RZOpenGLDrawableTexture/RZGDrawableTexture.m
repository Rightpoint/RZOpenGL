//
//  RZGDrawableTexture.m
//  ClockInTheBox
//
//  Created by John Stricker on 9/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import "RZGDrawableTexture.h"
#import "RZGColoredPSShaderSettings.h"
#import "RZGShaderManager.h"
#import "RZGAssetManager.h"
#import <OpenGLES/ES2/glext.h>

@interface RZGDrawableTexture()

@property (nonatomic, assign) GLuint drawingTextureId, frameBufferId, drawingVBO, drawingVAO;
@property (nonatomic, assign) GLfloat width, height, drawingSize;
@property (nonatomic, assign) GLKVector4 clearColor,drawColor;
@property (nonatomic, strong) RZGColoredPSShaderSettings *coloredShaderSettings;

@end

@implementation RZGDrawableTexture

- (instancetype)initWithWidth:(GLfloat)width Height:(GLfloat)height andColoredShaderSettings:(RZGColoredPSShaderSettings *)coloredShaderSettings
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    _width = width;
    _height = height;
    _coloredShaderSettings = coloredShaderSettings;
    _clearColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    glGenFramebuffers(1, &_frameBufferId);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    glGenTextures(1, &_textureId);
    glBindTexture(GL_TEXTURE_2D, _textureId);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height,
                 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, _textureId, 0);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    glGenVertexArraysOES(1, &_drawingVAO);
    glBindVertexArrayOES(_drawingVAO);
    
    glGenBuffers(1, &_drawingVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _drawingVBO);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, 0);
    glBindVertexArrayOES(0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    return self;
}

- (void)setDrawingSize:(GLfloat)size
{
    _drawingSize = size;
    [self.coloredShaderSettings setSize:size];
}

- (void)setdrawingTexture:(GLuint)drawingTextureId
{
    _drawingTextureId = drawingTextureId;
}

- (void)setdrawingColor:(GLKVector4)drawingColor
{
    _drawColor = GLKVector4MakeWithArray(drawingColor.v);
    [self.coloredShaderSettings setColor:drawingColor];
}

- (void)setClearColor:(GLKVector4)clearColor
{
    _clearColor = GLKVector4MakeWithArray(clearColor.v);
}

- (void)clear
{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    glClearColor(_clearColor.r,_clearColor.g,_clearColor.b,_clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)clearWithColor:(GLKVector4)clearColor
{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)drawPoint:(CGPoint)point
{
    GLfloat data[2] = {point.x,point.y};
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    
    glViewport(0, 0, _width, _height);
    
    [RZGShaderManager useProgram:_coloredShaderSettings.programId];
    
    [self.coloredShaderSettings setColor:_drawColor];
    [self.coloredShaderSettings setSize:_drawingSize];
    
    glBindTexture(GL_TEXTURE_2D, _drawingTextureId);
    
    glBindBuffer(GL_ARRAY_BUFFER, _drawingVBO);
    glBufferData(GL_ARRAY_BUFFER, 2*sizeof(GLfloat), data, GL_DYNAMIC_DRAW);
    
    glBindVertexArrayOES(_drawingVAO);
    
    glDrawArrays(GL_POINTS, 0, 1);
    
}

-(void)drawLineFromPoint:(CGPoint)startPt toPoint:(CGPoint)endPt
{
    // Line drawing mostly from Apple's GLColor sample, will look into a smother slerp or lerp version
    static GLfloat*	vertexBuffer = NULL;
    static GLuint vertexMax = 64;
    GLuint vertexCount = 0, count,i;
    static float kBrushPixelStep = 0.003f;
    
    // Allocate vertex array buffer
    if(vertexBuffer == NULL)
        vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
    
    // Add points to the buffer so there are drawing points every X pixels
    count = MAX(ceilf(sqrtf((endPt.x - startPt.x) * (endPt.x - startPt.x) + (endPt.y - startPt.y) * (endPt.y - startPt.y)) / kBrushPixelStep), 1);
    for(i = 0; i < count; ++i) {
        if(vertexCount == vertexMax) {
            vertexMax = 2 * vertexMax;
            vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
        }
        
        vertexBuffer[2 * vertexCount + 0] = startPt.x + (endPt.x - startPt.x) * ((GLfloat)i / (GLfloat)count);
        vertexBuffer[2 * vertexCount + 1] = startPt.y + (endPt.y - startPt.y) * ((GLfloat)i / (GLfloat)count);
        vertexCount += 1;
    }
    glDisable(GL_DEPTH_TEST);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    
    glViewport(0, 0, _width, _height);
    
    [RZGShaderManager useProgram:_coloredShaderSettings.programId];
    glBindBuffer(GL_ARRAY_BUFFER, _drawingVBO);
    glBufferData(GL_ARRAY_BUFFER, vertexCount*2*sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    
    glBindVertexArrayOES(_drawingVAO);
    
    glBindTexture(GL_TEXTURE_2D, _drawingTextureId);
    glDrawArrays(GL_POINTS, 0, vertexCount);
}

-(void)unload
{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferId);
    glDeleteTextures(1, &_textureId);
    [RZGAssetManager destroyVAO:_drawingVAO];
    glDeleteFramebuffers(1, &_frameBufferId);
}



@end
