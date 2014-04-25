//
//  RZGDEVBMFontViewController.m
//  RZGDevBMFont
//
//  Created by John Stricker on 4/25/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVBMFontViewController.h"
#import "RZGCoreHeaders.h"
#import "RZGBMFontHeaders.h"

@interface RZGDEVBMFontViewController ()

@property (strong, nonatomic) RZGBMFontModel *testFont;

@end

@implementation RZGDEVBMFontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    
    [self.glmgr loadBitmapFontShaderAndSettings];
    
    self.testFont = [[RZGBMFontModel alloc] initWithName:@"fireText" BMfontData:[[RZGBMFontData alloc] initWithFontFile:@"fireText" ] UseGLManager:self.glmgr];
    [self.testFont setTexture0Id:[RZGAssetManager loadTexture:@"fireText" ofType:@"png" shouldLoadWithMipMapping:YES]];
    [self.testFont setupWithCharMax:50.0f];
    [self.testFont updateWithText:@"WHAT"];
    
    self.testFont.centerVertical = YES;
    self.testFont.centerHorizontal = YES;
    
    [self.modelController addModel:self.testFont];
}

@end
