//
//  RZGPrs.h
//  RZGOGL
//
//  Created by John Stricker on 1/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RZGPrs : NSObject
@property (nonatomic) GLKVector3 position;
@property (nonatomic,readonly) GLKVector3 rotation;
@property (nonatomic,readonly) GLKQuaternion rotationQuaternion;
@property (nonatomic) GLKVector3 scale;
@property (nonatomic, readonly) BOOL rotationConstantExists;

- (void)updateConstantRotationWithTime:(GLfloat)time;

- (GLfloat)px;
- (GLfloat)py;
- (GLfloat)pz;
- (void)setPx:(GLfloat)x;
- (void)setPy:(GLfloat)y;
- (void)setPz:(GLfloat)z;

- (GLfloat)rx;
- (GLfloat)ry;
- (GLfloat)rz;
- (void)setRx:(GLfloat)x;
- (void)setRy:(GLfloat)y;
- (void)setRz:(GLfloat)z;
- (void)addVectorToRotation:(GLKVector3)vector;
- (void)resetRotationWithVector:(GLKVector3)vector;
- (void)setRotationConstantToVector:(GLKVector3)vector;
- (void)removeRotationConstant;

- (GLfloat)sx;
- (GLfloat)sy;
- (GLfloat)sz;
- (void)setSx:(GLfloat)x;
- (void)setSy:(GLfloat)y;
- (void)setSz:(GLfloat)z;
- (void)setSxyz:(GLfloat)xyz;

- (void)updateWithTime:(GLfloat)time;

 @end
