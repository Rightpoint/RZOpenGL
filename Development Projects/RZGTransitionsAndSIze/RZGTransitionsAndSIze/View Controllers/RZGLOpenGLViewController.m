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
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.glViewSize PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    self.view.opaque = NO;

    self.glmgr.projectionMatrix = GLKMatrix4Translate(self.glmgr.projectionMatrix, -0.5f, 0.0f, 0.0);
    
    CGFloat mainZ = -10.0f;
    
    CGFloat xPos = 0.0f;
    CGFloat xAdj = 0.1f;
    CGFloat yPos = 0.0f;
    
    int nObjects = 1;
    
    for (int i = 0; i < nObjects; ++i ){
        RZGModel *cube = [[RZGModel alloc] initWithModelFileName:@"cube" UseDefaultSettingsInManager:self.glmgr];
      //  cube.projection = GLKMatrix4Translate(self.glmgr.projectionMatrix, xPos, yPos, 0.0);
        cube.texture0Id = [RZGAssetManager loadTexture:@"purple" ofType:@"png" shouldLoadWithMipMapping:NO];
        cube.prs.pz = mainZ;
        cube.prs.px = xPos;
        cube.prs.py = yPos;
        xPos += xAdj;
        
  //      [cube.prs setRotationConstantToVector:GLKVector3Make(0.0f, 1.0f, 0.0f)];
        
        [self.modelController addModel:cube];
    }
    

}

@end
