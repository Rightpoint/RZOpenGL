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

typedef NS_ENUM(NSInteger, RZGCommandEnum)
{
    kRZGCommand_alpha,
    kRZGCommand_visible,
    kRZGCommand_rotateTo,
    kRZGCommand_rotateAlongPath,
    kRZGCommand_scaleTo,
    kRZGCommand_scaleAlongPath,
    kRZGCommand_setConstantRotation,
    kRZGCommand_moveTo,
    kRZGCommand_moveAlongPath,
    kRZGCommand_font_alternatingSplit
};

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

@interface RZGCommand : NSObject

@property (nonatomic, assign) RZGCommandEnum commandEnum;
@property (nonatomic, assign) GLKVector4 target;
@property (nonatomic, assign) GLKVector4 step;
@property (nonatomic, assign) GLfloat duration;
@property (nonatomic, assign) GLfloat delay;
@property (nonatomic, assign) BOOL isAbsolute;
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong) RZGCommandPath *path;

+ (instancetype)commandWithEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
+ (instancetype)commandWithEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;

+ (NSArray *)arrayFromX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z W:(GLfloat)w;
+ (GLKVector4)vectorFromArray:(NSArray*)arr;
@end
