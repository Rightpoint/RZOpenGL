//
//  RZGConfettiSpeck.m
//  RZGConfetti
//
//  Created by John Stricker on 11/3/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGConfettiSpeck.h"
#import "RZGModel.h"
#import "RZGPrs.h"

static GLfloat const kXVelocityDelta = 0.2f;
static GLfloat const kYVelocityDelta = 0.5f;
static GLfloat const kYTerminalVelocity = -0.5f;

@interface  RZGConfettiSpeck()

@property (assign, nonatomic) BOOL firedFromRight;

@end

@implementation RZGConfettiSpeck

- (instancetype)initWithModel:(RZGModel *)model xSpeed:(GLfloat)xSpeed ySpeed:(GLfloat)ySpeed FiredFromRight:(BOOL)firedFromRight
{
    self = [super init];
    if ( self ) {
        _xSpeed = xSpeed;
        _ySpeed = ySpeed;
        _firedFromRight = firedFromRight;
        _speckModel = model;
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(double)time
{
    if ( self.xSpeed != 0.0f ) {
        self.xSpeed -= kXVelocityDelta * time;
        if ( self.xSpeed < 0.0f ) {
            self.xSpeed = 0.0f;
        }
        
        if ( self.firedFromRight ) {
            self.speckModel.prs.px -= time * self.xSpeed;
        }
        else {
            self.speckModel.prs.px += time * self.xSpeed;
        }
    }
    
    if ( self.ySpeed > kYTerminalVelocity ) {
        self.ySpeed -= time * kYVelocityDelta;
        
        if (self.ySpeed < kYTerminalVelocity ) {
            self.ySpeed = kYTerminalVelocity;
        }
    }
    
    self.speckModel.prs.py += time * self.ySpeed;
}

@end
