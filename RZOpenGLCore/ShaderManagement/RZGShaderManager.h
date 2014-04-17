//
//  RZGShaderManager.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//
/*
 Contains methods for loading each specific type of shader, each method returns the shader's program ID. Shader loading/linking/compiling code largely taken from Apple's OpenGL Essentials project.
 
 [RZGShaderManger useProgram: ] should be called instead of glUseProgram() so that program use is tracked
 */

#import <Foundation/Foundation.h>
#import <GLKit/GLKMathTypes.h>

@interface RZGShaderManager : NSObject

+ (GLuint)loadModelDefaultShader;

+ (void)useProgram:(GLuint)programId;

@end
