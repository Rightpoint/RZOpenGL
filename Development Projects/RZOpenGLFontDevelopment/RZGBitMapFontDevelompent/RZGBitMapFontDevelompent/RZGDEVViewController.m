//
//  RZGDEVViewController.m
//  RZGBitMapFontDevelompent
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVViewController.h"
#import "RZGCoreHeaders.h"
#import "RZGBMFontHeaders.h"

@interface RZGDEVViewController ()

@end

@implementation RZGDEVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f)];
    
    [self.glmgr loadBitmapFontShaderAndSettings];
    
    RZGBMFontModel *fontModel = [[RZGBMFontModel alloc] initWithName:@"fireText" BMfontData:[[RZGBMFontData alloc] initWithFontFile:@"fireText"] UseGLManager:self.glmgr];
    [fontModel setTexture0Id:[RZGAssetManager loadTexture:@"fireText" ofType:@"png" shouldLoadWithMipMapping:YES]];
    [fontModel setupWithCharMax:20];
    [fontModel updateWithText:@"HELLOW?"];
    [self.modelController addModel:fontModel];
    
}


@end
