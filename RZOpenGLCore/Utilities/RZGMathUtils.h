//
//  RZGMathUtils.h
//  RZGOGL
//
//  Created by John Stricker on 4/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMathTypes.h>

@interface RZGMathUtils : NSObject

+ (GLfloat)clampf: (GLfloat)a WithInclusiveMin: (GLfloat)inclusiveMin InclusiveMax: (GLfloat)inclusiveMax;
+ (GLfloat)loopClampf: (GLfloat)a  WithInclusiveMin: (GLfloat)inclusiveMin InclusiveMax: (GLfloat)inclusiveMax;
+ (GLfloat)randomGLfloatBetweenMin: (GLfloat)min Max: (GLfloat)max;
+ (GLint)randomGLIntBetweenInclusiveMin: (GLfloat)min InclusiveMax: (GLfloat)max;

@end
