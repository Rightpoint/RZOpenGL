//
//  RZGDefaultModelShaderInfo.m
//  RZGOGL
//
//  Created by John Stricker on 11/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZGDefaultShaderSettings.h"
#import "RZGShaderManager.h"

@interface RZGDefaultShaderSettings()

@property (nonatomic,readonly) GLuint normalMatrixIndex,mvpIndex,alphaIndex,diffuseColorIndex,shadowMaxIndex;
@property (nonatomic) GLfloat alpha;
@property (nonatomic) GLKVector4 diffuseColor;
@property (nonatomic) GLfloat shadowMax;
@property (nonatomic) GLKMatrix3 normalMatrix;
@property (nonatomic) GLKMatrix4 mvp;
@end

@implementation RZGDefaultShaderSettings
- (id)initWithProgramId:(GLuint)programId
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    _programId = programId;
   
    [RZGShaderManager useProgram:_programId];
    
    //get indexes for uniforms
    _alphaIndex = glGetUniformLocation(_programId, "u_alpha");
    _mvpIndex = glGetUniformLocation(_programId, "u_modelViewProjectionMatrix");
    _normalMatrixIndex = glGetUniformLocation(_programId, "u_normalMatrix");
    _diffuseColorIndex = glGetUniformLocation(_programId, "u_diffuseColor");
    _shadowMaxIndex = glGetUniformLocation(_programId, "u_shadowMax");
  
    return self;
}

- (void)setAlpha:(GLfloat)alpha
{
    if(alpha == _alpha)
    {
        return;
    }
    [RZGShaderManager useProgram:_programId];
    glUniform1f(_alphaIndex, alpha);
    _alpha = alpha;
}

- (void)setDiffuseColor:(GLKVector4)diffuseColor
{
    if(GLKVector4AllEqualToVector4(diffuseColor, _diffuseColor))
    {
        return;
    }
    [RZGShaderManager useProgram:_programId];
    glUniform4fv(_diffuseColorIndex, 1, diffuseColor.v);
    _diffuseColor = GLKVector4MakeWithArray(diffuseColor.v);
}

-(void) setShadoMax:(GLfloat)shadowMax
{
    if(shadowMax == _shadowMax)
    {
        return;
    }
    
    [RZGShaderManager useProgram:_programId];
    glUniform1f(_shadowMaxIndex,shadowMax);
    _shadowMax = shadowMax;
}

-(void)setNormalMatrix:(GLKMatrix3)normalMatrix
{
    [RZGShaderManager useProgram:_programId];
    glUniformMatrix3fv(_normalMatrixIndex, 1, GL_FALSE ,normalMatrix.m);
    _normalMatrix = GLKMatrix3MakeWithArray(normalMatrix.m);
}

-(void)setModelViewProjectionMatrix:(GLKMatrix4)mvp
{
    [RZGShaderManager useProgram:_programId];
    glUniformMatrix4fv(_mvpIndex, 1, GL_FALSE, mvp.m);
    _mvp = GLKMatrix4MakeWithArray(mvp.m);
}

@end
