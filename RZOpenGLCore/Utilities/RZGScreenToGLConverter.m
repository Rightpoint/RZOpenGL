//
//  RZGScreenToGLConverter.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGScreenToGLConverter.h"
#import "RZGModel.h"
#import "RZGPrs.h"
#import <GLKit/GLKMath.h>

@interface RZGScreenToGLConverter()

@property (assign, nonatomic) GLfloat aspectRatio;
@property (assign, nonatomic) GLfloat fov;
@property (assign, nonatomic) GLKVector2 halfScreenSize;
@property (assign, nonatomic) GLKVector2 screenToGLratio;

@end

@implementation RZGScreenToGLConverter

- (instancetype)initWithScreenHeight:(GLfloat)screenHeight ScreenWidth:(GLfloat)screenWidth Fov:(GLfloat)fov
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

- (GLKVector2)convertScreenCoordsX:(GLfloat)x Y:(GLfloat)y ProjectedZ:(GLfloat)pz
{
    GLfloat xEdge = pz * self.screenToGLratio.x;
    GLfloat yEdge = pz * self.screenToGLratio.y;
  
    GLfloat newX = xEdge - (xEdge/self.halfScreenSize.y)*x;
    GLfloat newY = yEdge - (yEdge/self.halfScreenSize.x)*y;

    return  GLKVector2Make(newX, newY);
}

- (GLKVector2)getScreenEdgesForZ:(GLfloat)z
{
    return GLKVector2Make(fabsf(z*self.screenToGLratio.x), fabsf(z*self.screenToGLratio.y));
}

- (BOOL)screenPoint:(CGPoint)point intersectsModel:(RZGModel *)model
{
    GLKVector2 transformedPoint = [self convertScreenCoordsX:point.x Y:point.y ProjectedZ:model.prs.pz];
    
    GLKVector3 scale = model.prs.scale;
    GLKVector3 position = model.prs.position;
    GLfloat dx = model.dimensions2d.x/2.0f*scale.x;
    GLfloat dy = model.dimensions2d.y/2.0f*scale.y;
    
    NSLog(@"transformed point (%f, %f)",transformedPoint.x, transformedPoint.y);
    
    if(transformedPoint.x <= position.x + dx &&
       transformedPoint.x >= position.x - dx &&
       transformedPoint.y <= position.y + dy &&
       transformedPoint.y >= position.y - dx)
    {
        return YES;
    }
    return NO;
    
}

@end
