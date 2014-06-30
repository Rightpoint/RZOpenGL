//
//  RZGDEVViewController.m
//  RZGDEVScreenOrientation
//
//  Created by John Stricker on 5/6/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVViewController.h"

@interface RZGDEVViewController ()
@property (strong, nonatomic) RZGModel *model;
@property (assign, nonatomic) BOOL modelTouched;
@end

@implementation RZGDEVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:[self sizeForMainWindowOnLoad] PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1 FarZ:100.0f];
    self.model = [[RZGModel alloc] initWithModelFileName:@"cube" UseDefaultSettingsInManager:self.glmgr];
    self.model.prs.pz = -5.0f;
    self.model.prs.px = -1.0f;
    [self.model setTexture0Id:[RZGAssetManager loadTexture:@"gridTexture" ofType:@"png" shouldLoadWithMipMapping:YES]];
    self.model.dimensions2d = CGPointMake(2.0f, 2.0f);
    
    [self.modelController addModel:self.model];
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
   CGPoint location = [gesture locationInView:self.view];
    if([self.glmgr.zConverter screenPoint:location intersectsModel:self.model]) {
        CGPoint translatedPoint = [gesture translationInView:gesture.view];
        NSLog(@"Translated point: %@",NSStringFromCGPoint(translatedPoint));
        GLKVector2 moveVector = [self.glmgr.zConverter convertScreenCoordsX:translatedPoint.x Y:translatedPoint.y ProjectedZ:self.model.prs.pz];
        self.model.prs.px += moveVector.x;
        self.model.prs.py += moveVector.y;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    NSLog(@"touch at: %@",NSStringFromCGPoint(location));
    if([self.glmgr.zConverter screenPoint:[touch locationInView:self.view] intersectsModel:self.model]) {
        
    }
}



@end
