//
//  RZGColoredPSShaderSettings.h
//  ClockInTheBox
//
//  Created by John Stricker on 9/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RZGColoredPSShaderSettings : NSObject

@property (nonatomic, assign, readonly) GLuint programId;

- (instancetype)initWithProgramId:(GLuint)programId;

- (void)setMvpForTextureCoordinates;
- (void)setColor:(GLKVector4)color;
- (void)setSize:(GLfloat)size;
- (void)setMvpMatrix:(GLKMatrix4)mvp;

@end
