//
//  RZGLOpenGLViewController.m
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGLOpenGLViewController.h"

@interface RZGLOpenGLViewController ()

@end

@implementation RZGLOpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.glViewSize PerspectiveInRadians:GLKMathDegreesToRadians(10.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    self.view.opaque = NO;

    CGFloat mainZ = -50.0f;
    
    CGFloat xPos = 0.0f;
    CGFloat xAdj = 0.1f;
    
    int nObjects = 50;
    
    for (int i = 0; i < nObjects; ++i ){
        RZGModel *cube = [[RZGModel alloc] initWithModelFileName:@"disk" UseDefaultSettingsInManager:self.glmgr];
        cube.texture0Id = [RZGAssetManager loadTexture:@"purple" ofType:@"png" shouldLoadWithMipMapping:NO];
        cube.prs.pz = mainZ;
        cube.prs.px = xPos;
        xPos += xAdj;
        
        [cube.prs setRotationConstantToVector:GLKVector3Make(0.0f, 1.0f, 0.0f)];
        
        [self.modelController addModel:cube];
    }
    

}

@end
