//
//  RZGBitmapFontShaderSettings.h
//  RZGOGL
//
//  Created by John Stricker on 3/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@class RZGBitmapFontShaderSettings;

@interface RZGBitmapFontShaderSettings : NSObject

@property (nonatomic, readonly, assign) GLuint programId;
@property (nonatomic, strong) RZGBitmapFontShaderSettings *shaderSettings;

- (instancetype)initWithProgramId:(GLuint)programId;
- (void)setAlpha:(GLfloat)alpha;
- (void)setModelViewProjectionMatrix:(GLKMatrix4)mvp;

@end
