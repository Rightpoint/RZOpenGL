//
//  RZGDEVViewControllerFight.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/18/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVViewControllerFight.h"
#import "RZGCoreHeaders.h"

static const double kSecondsPerFrame = 0.005f;
static const int kTotalImages = 15;
@interface RZGDEVViewControllerFight ()
{
    GLint textureIds[15];
    GLint currentTextureIndex;
    double intervalTime;
    BOOL backStep;
}
@property (strong, nonatomic) RZGModel *quad;
@end

@implementation RZGDEVViewControllerFight

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    self.view.opaque = NO;
    
    GLfloat mainZ = -2.25f;
    
    self.quad = [[RZGModel alloc] initWithModelFileName:@"quad" UseDefaultSettingsInManager:self.glmgr];
    self.quad.prs.pz = mainZ;
    
    for(int i = 0; i <  kTotalImages; i++){
       textureIds[i] = [RZGAssetManager loadTexture:[NSString stringWithFormat:@"gp%d",i+1] ofType:@"png" shouldLoadWithMipMapping:NO];
    }
    
    [self.quad setTexture0Id:textureIds[0]];
    
    [self.modelController addModel:self.quad];
    
    intervalTime = 0.0;
}

- (void)update
{
    [super update];
    
    intervalTime += self.timeSinceLastUpdate;
    if ( intervalTime >= kSecondsPerFrame ) {
        if(!backStep) {
            ++currentTextureIndex;
            if(currentTextureIndex > kTotalImages){
                backStep = YES;
            }
        }
        if(backStep) {
            --currentTextureIndex;
            if(currentTextureIndex < 0) {
                backStep = NO;
                ++currentTextureIndex;
            }
        }
        [self.quad setTexture0Id:textureIds[currentTextureIndex]];
    }
}



@end
