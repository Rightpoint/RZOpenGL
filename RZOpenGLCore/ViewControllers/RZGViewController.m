//
//  RZGViewController.m
//  RZGLCoreDevelopemnt
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGViewController.h"
#import <GLKit/GLKit.h>

@interface RZGViewController () <GLKViewDelegate>

@property (assign, nonatomic, readwrite) CFTimeInterval *timeSinceLastUpdate;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation RZGViewController

- (void)loadView
{
    GLKView *glkview = [[GLKView alloc] initWithFrame:self.view.frame];
    glkview.delegate = self;
    self.view  = glkview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
