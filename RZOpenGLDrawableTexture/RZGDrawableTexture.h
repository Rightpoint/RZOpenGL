//
//  RZGDrawableTexture.h
//  ClockInTheBox
//
//  Created by John Stricker on 9/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGColoredPSShaderSettings;

@interface RZGDrawableTexture : NSObject

@property (nonatomic, readonly) GLuint textureId;

- (instancetype)initWithWidth:(GLfloat)width Height:(GLfloat)height andColoredShaderSettings:(RZGColoredPSShaderSettings*)coloredShaderSettings;
- (void)setDrawingSize:(GLfloat)size;
- (void)setdrawingTexture:(GLuint)drawingTextureId;
- (void)setdrawingColor:(GLKVector4)drawingColor;
- (void)setClearColor:(GLKVector4)clearColor;
- (void)clear;
- (void)clearWithColor:(GLKVector4)clearColor;
- (void)drawPoint:(CGPoint)point;
- (void)drawLineFromPoint:(CGPoint)startPt toPoint:(CGPoint)endPt;
- (void)unload;

@end
