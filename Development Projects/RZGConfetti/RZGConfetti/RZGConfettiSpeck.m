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

static GLfloat const kXVelocityDelta = 120.0f;
static GLfloat const kYVelocityDelta = 20.0f;
static GLfloat const kYTerminalVelocity = -5.0f;
static GLfloat const kYSpinDeltaOnFall = M_PI * 8.0;

@implementation RZGConfettiSpeck

- (instancetype)initWithModel:(RZGModel *)model xSpeed:(GLfloat)xSpeed ySpeed:(GLfloat)ySpeed fireDelay:(GLfloat)fireDelay FiredFromRight:(BOOL)firedFromRight
{
    self = [super init];
    if ( self ) {
        _xSpeed = xSpeed;
        _ySpeed = ySpeed;
        _firedFromRight = firedFromRight;
        _speckModel = model;
        _fireDelay = fireDelay;
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(double)time
{
    if ( self.fireDelay > 0.0 ) {
        self.fireDelay -= time;
    }
    else {
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
            
            self.speckModel.prs.rx += time * self.xSpeed;
        }
        
        if ( self.ySpeed > kYTerminalVelocity ) {
            self.ySpeed -= time * kYVelocityDelta;
            
            if (self.ySpeed < kYTerminalVelocity ) {
                self.ySpeed = kYTerminalVelocity;
            }
        }
        
        self.speckModel.prs.py += time * self.ySpeed;
        
        if ( self.ySpeed < 0) {
            self.speckModel.prs.ry += kYSpinDeltaOnFall * time;
        }
    }
}

@end
