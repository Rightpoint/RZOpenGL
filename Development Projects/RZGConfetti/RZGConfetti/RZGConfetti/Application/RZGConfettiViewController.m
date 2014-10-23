//
//  RZGConfettiViewController.m
//  RZGConfetti
//
//  Created by John Stricker on 10/22/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGConfettiViewController.h"

@interface RZGConfettiViewController ()

@property (strong, nonatomic) NSArray *specks;

@end

@implementation RZGConfettiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:[UIScreen mainScreen].bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    
    NSInteger nSpecks = 10;
    
    GLfloat xStart = -1.0f;
    GLfloat xIncrement = 0.5f;
    GLfloat mainZ = -5.0f;
    
    NSMutableArray *mutableSpeckArray = [[NSMutableArray alloc]initWithCapacity:nSpecks];
    for ( NSInteger i = 0; i < nSpecks; ++i) {
        RZGModel *speck = [[RZGModel alloc] initWithModelFileName:@"confettiModel" UseDefaultSettingsInManager:self.glmgr];
        [speck setTexture0Id:[RZGAssetManager loadTexture:@"confettiTexture" ofType:@"png" shouldLoadWithMipMapping:YES]];
        speck.prs.position = GLKVector3Make(xStart, 0.5f, mainZ);
        speck.prs.scale = GLKVector3Make(0.075f, 0.05f , 0.075f);
        speck.shadowMax = 0.1f;
        speck.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        [speck.prs setRotationConstantToVector:GLKVector3Make(1.0f, 0.0f, 0.0f)];
        
        xStart += xIncrement;
        
        [mutableSpeckArray addObject:speck];
        [self.modelController addModel:speck];
    }
    
    self.specks = [NSArray arrayWithArray:mutableSpeckArray];
}


@end
