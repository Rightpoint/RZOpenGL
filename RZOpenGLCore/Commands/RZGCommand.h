//
//  RZGCommand.h
//  RZGOGL
//
//  Created by John Stricker on 2/21/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGCommandPath;

typedef void (^RZGCommandCompletionBlockType)();
typedef GLfloat (*RZGEasingFunction)(GLfloat);

typedef enum : NSUInteger {
    kRZGCommand_alpha,
    kRZGCommand_visible,
    kRZGCommand_rotateTo,
    kRZGCommand_rotateAlongPath,
    kRZGCommand_scaleTo,
    kRZGCommand_scaleAlongPath,
    kRZGCommand_setConstantRotation,
    kRZGCommand_moveTo,
    kRZGCommand_moveAlongPath,
    kRZGCommand_font_alternatingSplit,
    kRZGCommand_shadowMax
} RZGCommandEnum;

static __inline__ GLKVector4 GLKVector4MakeWithBool(BOOL boolValue)
{
    GLfloat x = 0.0f;
    if(boolValue)
    {
        x = 1.0f;
    }
    GLKVector4 v = {x, 0.0f, 0.0f, 0.0f};
    return v;
}

static __inline__ GLKVector4 GLKVector4MakeWith1f(GLfloat x)
{
    GLKVector4 v = { x, 0.0f, 0.0f, 0.0f};
    return v;
}

static __inline__ GLKVector4 GLKVector4MakeWith2f(GLfloat x, GLfloat y)
{
    GLKVector4 v = { x, y, 0.0f, 0.0f};
    return v;
}


static __inline__ GLKVector4 GLKVector4MakeWith3f(GLfloat x, GLfloat y, GLfloat z)
{
    GLKVector4 v = {x, y, z, 0.0f};
    return v;
}

static __inline__ GLKVector4 GLKVector4MakeWithVec3(GLKVector3 vec3)
{
    GLKVector4 v = {vec3.x, vec3.y, vec3.z, 0.0f};
    return v;
}

static __inline__ GLfloat RZGLinearInterpolation(GLfloat p)
{
    return p;
}

static __inline__ GLfloat RZQuadraticEaseIn(GLfloat p)
{
    return p*p;
}

static __inline__ GLfloat RZQuadraticEaseOut(GLfloat p)
{
    return -(p * (p - 2));
}

static __inline__ GLfloat RZQuadraticEaseInOut(GLfloat p)
{
    if ( p < 0.5f ) {
        return 2 * p * p;
    }
    else {
        return ( -2.0f * p * p ) + ( 4.0f * p ) - 1;
    }
}


@interface RZGCommand : NSObject

@property (nonatomic, assign) RZGCommandEnum commandEnum;
@property (nonatomic, assign) GLKVector4 target;
@property (nonatomic, assign) GLKVector4 step;
@property (nonatomic, assign) GLfloat duration;
@property (nonatomic, assign) GLfloat elapsedTime;
@property (nonatomic, assign) GLfloat delay;
@property (nonatomic, assign) BOOL isAbsolute;
@property (nonatomic, assign) RZGEasingFunction easingFunction;
@property (nonatomic, assign) GLKVector4 startingValue;
@property (nonatomic, assign) GLKVector4 distance;
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong) RZGCommandPath *path;
@property (nonatomic, copy) RZGCommandCompletionBlockType completionBlock;

+ (instancetype)commandWithEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
+ (instancetype)commandWithEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
- (instancetype)dupilicate;

+ (NSArray *)arrayFromX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z W:(GLfloat)w;
+ (GLKVector4)vectorFromArray:(NSArray*)arr;
@end
