//
//  RZGScreenToGLConverter.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMathTypes.h>

@interface RZGScreenToGLConverter : NSObject

- (instancetype)initWithScreenHeight:(GLfloat)screenHeight ScreenWidth:(GLfloat)screenWidth Fov:(GLfloat) fov;
- (GLKVector2)convertScreenCoordsX:(GLfloat)x Y:(GLfloat)y ProjectedZ:(GLfloat)pz;
- (GLKVector2)getScreenEdgesForZ:(GLfloat)z;

@end
