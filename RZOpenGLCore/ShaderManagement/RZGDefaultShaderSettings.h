//
//  RZGDefaultModelShaderInfo.h
//  RZGOGL
//
//  Created by John Stricker on 11/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RZGDefaultShaderSettings : NSObject

@property (nonatomic,readonly) GLuint programId;

- (instancetype)initWithProgramId:(GLuint)programId;
- (void)setAlpha:(GLfloat)alpha;
- (void)setDiffuseColor:(GLKVector4)diffuseColor;
- (void)setShadoMax:(GLfloat)shadowMax;
- (void)setNormalMatrix:(GLKMatrix3)normalMatrix;
- (void)setModelViewProjectionMatrix:(GLKMatrix4)mvp;
@end
