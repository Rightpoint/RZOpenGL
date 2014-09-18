//
//  RZGCommand.m
//  RZGOGL
//
//  Created by John Stricker on 2/21/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGCommand.h"
#import <GLKit/GLKit.h>

@implementation RZGCommand

+ (instancetype)commandWithEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay
{
    return [[RZGCommand alloc] initWithCommandEnum:command Target:target Duration:duration IsAbsolute:isAbsolute Delay:delay];
}

- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Target:(GLKVector4)target Duration:(GLfloat)duration IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay
{
    self = [super init];
    if(self)
    {
        _commandEnum = command;
        _target = target;
        _duration = duration;
        _isAbsolute = isAbsolute;
        _delay = delay;
    }
    return self;
}

+ (instancetype)commandWithEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay
{
    return [[RZGCommand alloc] initWithCommandEnum:command Path:path IsAbsolute:isAbsolute Delay:delay];
}

- (instancetype)initWithCommandEnum:(RZGCommandEnum) command Path:(RZGCommandPath *)path IsAbsolute:(BOOL)isAbsolute Delay:(GLfloat)delay;
{
    self = [super init];
    if(self)
    {
        _commandEnum = command;
        _path = path;
        _isAbsolute = isAbsolute;
        _delay = delay;
    }
    return self;
}

+ (NSArray *)arrayFromX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z W:(GLfloat)w
{
    return @[[NSNumber numberWithFloat:x],[NSNumber numberWithFloat:y], [NSNumber numberWithFloat:z], [NSNumber numberWithFloat:w]];
}

+ (GLKVector4)vectorFromArray:(NSArray*)arr
{
     return GLKVector4Make([(NSNumber *)arr[0] floatValue], [(NSNumber *)arr[1] floatValue],[(NSNumber *)arr[2] floatValue], [(NSNumber *)arr[3] floatValue]);
}

@end
