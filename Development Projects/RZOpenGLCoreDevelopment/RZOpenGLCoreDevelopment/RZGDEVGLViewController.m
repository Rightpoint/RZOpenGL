//
//  RZGDEVGLViewController.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/18/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVGLViewController.h"
#import "RZGCoreHeaders.h"

@interface RZGDEVGLViewController ()

@property (strong, nonatomic) RZGModel *bigBall;
@property (strong, nonatomic) RZGModel *smallBall;

@end

@implementation RZGDEVGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    self.view.opaque = NO;
    
    GLfloat mainZ = -10.0f;
    
    self.bigBall = [[RZGModel alloc] initWithModelFileName:@"rzUni1" UseDefaultSettingsInManager:self.glmgr];
    [self.bigBall setTexture0Id:[RZGAssetManager loadTexture:@"rzUnicorn" ofType:@"png" shouldLoadWithMipMapping:YES]];
    self.bigBall.prs.pz = -5.0f;
    
    [self.bigBall.prs setRotationConstantToVector:GLKVector3Make(0.0f, 16.0f, 0.0f)];
    
    self.smallBall = [[RZGModel alloc] initWithModelFileName:@"rzUni2" UseDefaultSettingsInManager:self.glmgr];
    [self.smallBall setTexture0Id:self.bigBall.texture0Id];
    self.smallBall.prs.pz = mainZ;
 //   [self.smallBall.prs setRotationConstantToVector:GLKVector3Make(0.0f, 0.0f, 4.0f)];
    
    self.smallBall.alpha = 0.0f;
   [self.smallBall addCommand:[RZGCommand commandWithEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(1.0f) Duration:2.0f IsAbsolute:YES Delay:5.0f]];
    
    [self.modelController addModel:self.bigBall];
    [self.modelController addModel:self.smallBall];
}


@end
