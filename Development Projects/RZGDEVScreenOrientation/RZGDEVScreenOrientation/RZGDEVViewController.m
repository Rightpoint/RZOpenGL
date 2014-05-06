//
//  RZGDEVViewController.m
//  RZGDEVScreenOrientation
//
//  Created by John Stricker on 5/6/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVViewController.h"

@interface RZGDEVViewController ()

@end

@implementation RZGDEVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:[self sizeForMainWindowOnLoad] PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1 FarZ:100.0f];
    RZGModel *model = [[RZGModel alloc] initWithModelFileName:@"cube" UseDefaultSettingsInManager:self.glmgr];
    model.prs.pz = -5.0f;
    [model setTexture0Id:[RZGAssetManager loadTexture:@"gridTexture" ofType:@"png" shouldLoadWithMipMapping:YES]];

    [self.modelController addModel:model];
    
}


@end
