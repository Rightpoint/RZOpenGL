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

@property (assign, nonatomic, readwrite) CFTimeInterval timeSinceLastUpdate;
@property (nonatomic, assign) CFTimeInterval lastTimeStamp;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation RZGViewController

- (void)loadView
{
    self.glkView = [[GLKView alloc] init];
    self.glkView.delegate = self;
    self.glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    self.glkView.enableSetNeedsDisplay = NO;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.timeSinceLastUpdate = 0.0;
    
    self.modelController = [[RZGModelController alloc] init];
    
    self.view = self.glkView;
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    _isPaused = paused;
    
    self.displayLink.paused = paused;
}

- (void)render:(CADisplayLink *)displayLink
{
    [self update];
    self.timeSinceLastUpdate = displayLink.timestamp - self.lastTimeStamp;
    [self.glkView display];
    self.lastTimeStamp = displayLink.timestamp;
}

- (void)update
{
    [self.modelController updateWithTime:self.timeSinceLastUpdate];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.modelController draw];
}

@end
