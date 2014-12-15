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
@property (assign, nonatomic) BOOL resetTimeStamp;
@property (assign, nonatomic) CGRect lastFrame;
@property (assign, nonatomic) BOOL pauseAfterDelay;
@property (assign, nonatomic) double pauseCountDown;

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
    self.lastTimeStamp = self.displayLink.timestamp;
    
    self.modelController = [[RZGModelController alloc] init];
    
    self.view = self.glkView;
    
    self.resetTimeStamp = YES;
}

- (void)viewWillLayoutSubviews {
    [self.glmgr updateScreenRect:self.view.frame];
}

- (CGSize)sizeForMainWindowOnLoad
{
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        windowSize = CGSizeMake(windowSize.height, windowSize.width);
    }
    
    return windowSize;
}

- (void)setFramesPerSecond:(NSInteger)framesPerSecond
{
    self.displayLink.frameInterval = 60 / framesPerSecond;
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    _isPaused = paused;
   
    if ( !paused ) {
        self.pauseAfterDelay = NO;
        self.pauseCountDown = 0.0;
    }
    
    self.displayLink.paused = paused;
}

- (void)resetTimeStamps
{
    self.resetTimeStamp = YES;
}

- (void)pauseAfterDelay:(double)delay
{
    self.pauseAfterDelay = YES;
    self.pauseCountDown = delay;
}

- (void)render:(CADisplayLink *)displayLink
{
    self.timeSinceLastUpdate = displayLink.timestamp - self.lastTimeStamp;
    
    if ( self.timeSinceLastUpdate > 0.2 ) {
        self.timeSinceLastUpdate = 0.166666f;
    }
    
    [self update];
    
    [self.glkView display];
    self.lastTimeStamp = displayLink.timestamp;
    
    if ( self.pauseAfterDelay ) {
        self.pauseCountDown -= self.timeSinceLastUpdate;
        if ( self.pauseCountDown <= 0.0f ) {
            self.pauseAfterDelay = NO;
            self.paused = YES;
        }
    }
}

- (void)update
{
    [self.modelController updateWithTime:self.timeSinceLastUpdate];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.modelController draw];
}

- (void)unload
{
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [RZGAssetManager unload];
    [self.glmgr unload];
    self.glkView.context = nil;
    self.glkView = nil;
}

@end
