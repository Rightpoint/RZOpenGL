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
    
    self.view.userInteractionEnabled = NO;
    
    self.framesPerSecond = 30.0f;
        
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:[UIScreen mainScreen].bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f)];
    
    NSInteger nSpecks = 1000;
    
    GLfloat xStart = -2.0f;
    GLfloat yStart = 2.0f;
    
    GLfloat xIncrement = 0.05f;
    GLfloat mainZ = -5.0f;
    
    NSInteger nPerRow = 60;
    
    GLfloat yIncrement = -0.1f;
    NSInteger columnCount = 0;
    NSInteger rowCount = 0;
    
    GLfloat xRot = 1.0f;
    
    NSMutableArray *mutableSpeckArray = [[NSMutableArray alloc]initWithCapacity:nSpecks];
    for ( NSInteger i = 0; i < nSpecks; ++i) {
        RZGModel *speck = [[RZGModel alloc] initWithModelFileName:@"confettiModel" UseDefaultSettingsInManager:self.glmgr];
        [speck setTexture0Id:[RZGAssetManager loadTexture:@"confettiTexture" ofType:@"png" shouldLoadWithMipMapping:YES]];
        speck.prs.position = GLKVector3Make(xStart + columnCount * xIncrement, yStart + rowCount * yIncrement, mainZ);
        speck.prs.scale = GLKVector3Make(0.05f, 0.01f , 0.05f);
        speck.shadowMax = 0.1f;
        speck.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        [speck.prs setRotationConstantToVector:GLKVector3Make(xRot, 2.0f, 0.0f)];
        
        xRot = -xRot;
        
        [mutableSpeckArray addObject:speck];
        [self.modelController addModel:speck];
        
        ++columnCount;
        if ( columnCount > nPerRow ) {
            columnCount = 0;
            ++rowCount;
        }
    }
    
    self.specks = [NSArray arrayWithArray:mutableSpeckArray];
}


@end
