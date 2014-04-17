//
//  RZGScreenToGLConverter.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGScreenToGLConverter.h"
#import <GLKit/GLKMath.h>

@interface RZGScreenToGLConverter()

@property (assign, nonatomic) GLfloat aspectRatio;
@property (assign, nonatomic) GLfloat fov;
@property (assign, nonatomic) GLKVector2 halfScreenSize;
@property (assign, nonatomic) GLKVector2 screenToGLratio;

@end

@implementation RZGScreenToGLConverter

-(instancetype)initWithScreenHeight:(GLfloat)screenHeight ScreenWidth:(GLfloat)screenWidth Fov:(GLfloat)fov
{
    self = [super init];
    if ( self ) {
        _aspectRatio = fabsf(screenWidth/screenHeight);
        _fov = fov;
        _halfScreenSize.x = screenHeight / 2.0f;
        _halfScreenSize.y = screenWidth / 2.0f;
        _screenToGLratio.y = fabsf(tanf(fov / 2.0f));
        _screenToGLratio.x = fabsf(_screenToGLratio.y * _aspectRatio);
    }
    return self;
}

-(GLKVector2)convertScreenCoordsX:(GLfloat)x Y:(GLfloat)y ProjectedZ:(GLfloat)pz
{
    GLfloat xEdge = pz * self.screenToGLratio.x;
    GLfloat yEdge = pz * self.screenToGLratio.y;
  
    GLfloat newX = xEdge - (xEdge/self.halfScreenSize.x)*x;
    GLfloat newY = yEdge - (yEdge/self.halfScreenSize.y)*y;

    return  GLKVector2Make(newX, -newY);
}

-(GLKVector2)getScreenEdgesForZ:(GLfloat)z
{
    return GLKVector2Make(fabsf(z*self.screenToGLratio.x), fabsf(z*self.screenToGLratio.y));
}

@end
