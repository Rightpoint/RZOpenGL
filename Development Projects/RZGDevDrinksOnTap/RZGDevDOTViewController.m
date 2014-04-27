//
//  RZGDevDOTViewController.m
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGDevDOTViewController.h"
#import "RZTwitterData.h"
#import "RZTweetData.h"

static const float kRZSecondsPerTweetRequest = 6.0f;
static const float kRZSecondsBetweenDisplayedTweets = 10.0f;
static const float kRZFadeDuration = 0.2f;

@interface RZGDevDOTViewController ()

@property (strong, nonatomic) RZTwitterData *twitterData;

@end

@implementation RZGDevDOTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f)];
    
}

- (void)update
{
    [super update];
}


@end
