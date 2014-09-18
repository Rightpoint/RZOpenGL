//
//  RZGScreenToGLConverter.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGModel;

@interface RZGScreenToGLConverter : NSObject

- (instancetype)initWithScreenHeight:(GLfloat)screenHeight ScreenWidth:(GLfloat)screenWidth Fov:(GLfloat) fov;
- (CGPoint)convertScreenCoordsX:(GLfloat)x Y:(GLfloat)y ProjectedZ:(GLfloat)pz;
- (GLKVector2)getScreenEdgesForZ:(GLfloat)z;
- (BOOL)convertedPoint:(CGPoint)point intersectsModel:(RZGModel *)model;
- (BOOL)screenPoint:(CGPoint)point intersectsModel:(RZGModel *)model;
@end
