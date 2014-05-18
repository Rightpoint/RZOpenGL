//
//  RZGOpenGLManager.h
//  RZGOGL
//
//  Created by John Stricker on 12/9/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGDefaultShaderSettings;
@class RZGScreenToGLConverter;
@class RZGBitmapFontShaderSettings;

@interface RZGOpenGLManager : NSObject

@property (nonatomic, strong) RZGDefaultShaderSettings *defaultShaderSettings;
@property (nonatomic, strong) RZGBitmapFontShaderSettings *bitmapFontShaderSettings;
@property (nonatomic, strong) RZGScreenToGLConverter *zConverter;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;

- (instancetype)initWithView:(GLKView*)glkView ScreenSize:(CGSize)size PerspectiveInRadians:(GLfloat)perspective NearZ:(GLfloat)nearZ FarZ:(GLfloat)farZ;
- (void)loadDefaultShaderAndSettings;
- (void)loadBitmapFontShaderAndSettings;
- (void)enableDepthTest;
- (void)disableDepthTest;
- (void)setClearColor:(GLKVector4)clearColor;
- (void)unload;

@end
