//
//  RZGConfettiSpeck.h
//  RZGConfetti
//
//  Created by John Stricker on 11/3/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RZGModel;

@interface RZGConfettiSpeck : NSObject

@property (nonatomic, strong) RZGModel *speckModel;
@property (nonatomic, assign) GLfloat xSpeed;
@property (nonatomic, assign) GLfloat ySpeed;
@property (nonatomic, assign) GLfloat fireDelay;
@property (nonatomic, assign) BOOL firedFromRight;

- (instancetype)initWithModel:(RZGModel *)model xSpeed:(GLfloat)xSpeed ySpeed:(GLfloat)ySpeed fireDelay:(GLfloat)fireDelay FiredFromRight:(BOOL)firedFromRight;

- (void)updateWithTimeSinceLastUpdate:(double)time;

@end
