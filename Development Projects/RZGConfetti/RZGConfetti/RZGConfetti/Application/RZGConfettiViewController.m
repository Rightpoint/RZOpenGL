//
//  RZGConfettiViewController.m
//  RZGConfetti
//
//  Created by John Stricker on 10/22/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGConfettiViewController.h"
#import "RZGconfettiSpeck.h"
#import "RZGMathUtils.h"

static int const kNSpecks = 350;


@interface RZGConfettiViewController ()

@property (strong, nonatomic) NSArray *specks;

@end

@implementation RZGConfettiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = NO;
    
    self.framesPerSecond = 60;
        
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:[UIScreen mainScreen].bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    
    GLKVector3 speckStart = GLKVector3Make(-2.25f, -1.5f, -5.0f);
    
    NSMutableArray *speckArray = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < kNSpecks; ++i ) {
        RZGModel *m = [[RZGModel alloc] initWithModelFileName:@"confettiModel" UseDefaultSettingsInManager:self.glmgr];
        [m setTexture0Id:[RZGAssetManager loadTexture:@"confettiTexture" ofType:@"png" shouldLoadWithMipMapping:NO]];
        m.prs.position = speckStart;
        m.prs.scale = GLKVector3Make(0.1f, 0.2f , 0.1f);
        m.shadowMax = 0.1f;
        m.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        
        RZGConfettiSpeck *speck = [[RZGConfettiSpeck alloc] initWithModel:m xSpeed:1.0f ySpeed:1.0f  fireDelay:0.0f FiredFromRight:NO];
        [speckArray addObject:speck];
    }
    
    self.specks = [NSArray arrayWithArray:speckArray];
    self.paused = YES;
}

- (void)resetConfetti
{
    GLfloat xSpeedMin = 20.0f;
    GLfloat xSpeedMax = 40.0f;
    
    GLfloat ySpeedMin = 12.0f;
    GLfloat ySpeedMax = 24.0f;
    
    GLfloat fireDelayMax = 0.5f;
    
    GLKVector3 speckStart = GLKVector3Make(-3.5f, -2.5f, -5.0f);
    
    GLfloat xScale = 0.05f;
    GLfloat yScale = 0.075f;
    
    BOOL odd = NO;
    
    for ( RZGConfettiSpeck *speck in self.specks ) {
        GLfloat xSpeed = [RZGMathUtils randomGLfloatBetweenMin:xSpeedMin Max:xSpeedMax];
        GLfloat ySpeed = [RZGMathUtils randomGLfloatBetweenMin:ySpeedMin Max:ySpeedMax];
        GLfloat fireDelay = [RZGMathUtils randomGLfloatBetweenMin:0.0 Max:fireDelayMax];
        speck.ySpeed = ySpeed;
        speck.xSpeed = xSpeed;
        speck.fireDelay = fireDelay;
        RZGModel *m = speck.speckModel;
        
    
        m.prs.scale = GLKVector3Make(xScale, yScale, xScale);
        
        m.prs.position = speckStart;
       
        if ( odd ) {
            m.prs.px = -m.prs.px;
            speck.firedFromRight = YES;
        }
        
        odd = !odd;
        
        m.prs.rx = [RZGMathUtils randomGLfloatBetweenMin:0 Max:2*M_PI];
        m.prs.ry = [RZGMathUtils randomGLfloatBetweenMin:0 Max:2*M_PI];
    }
}

- (void)fireConfetti
{
    [self.modelController removeAllModels];
    [self resetConfetti];
    
    for ( RZGConfettiSpeck *speck in self.specks ) {
        [self.modelController addModel:speck.speckModel];
    }
    
    self.paused = NO;
}

- (void)update
{
    for ( RZGConfettiSpeck *speck in self.specks ) {
        [speck updateWithTimeSinceLastUpdate:self.timeSinceLastUpdate];
    }
    
    [self.modelController updateWithTime:self.timeSinceLastUpdate];
}


@end
