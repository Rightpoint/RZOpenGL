//
//  RZGMathUtils.m
//  RZGOGL
//
//  Created by John Stricker on 4/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGMathUtils.h"
#import <GLKit/GLKMathTypes.h>

@implementation RZGMathUtils

static const GLfloat randPrecision = MAXFLOAT;

+ (GLfloat)clampf: (GLfloat)a WithInclusiveMin: (GLfloat)inclusiveMin InclusiveMax: (GLfloat)inclusiveMax
{
    if(a < inclusiveMin) return inclusiveMin;
    if(a > inclusiveMax) return inclusiveMax;
    return a;
}

+ (GLfloat)loopClampf: (GLfloat)a  WithInclusiveMin: (GLfloat)inclusiveMin InclusiveMax: (GLfloat)inclusiveMax
{
    if(a < inclusiveMin) return -fmodf(-a,inclusiveMin);
    if(a > inclusiveMax) return fmodf(a,inclusiveMax);
    return a;
}

+ (GLfloat)randomGLfloatBetweenMin:(GLfloat)min Max:(GLfloat)max
{
    return ((GLfloat)arc4random_uniform(((max-min)*randPrecision)))/randPrecision+min;
}

+ (GLint)randomGLIntBetweenInclusiveMin:(GLfloat)min InclusiveMax:(GLfloat)max
{
    return (GLint)arc4random_uniform(max+1);
}

@end
