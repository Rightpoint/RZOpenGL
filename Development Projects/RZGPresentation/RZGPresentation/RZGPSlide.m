//
//  RZGPSlide.m
//  RZGPresentation
//
//  Created by John Stricker on 9/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGPSlide.h"
#import "RZGModel.h"
#import "RZGAssetManager.h"
#import "RZGOpenGLManager.h"

@implementation RZGPSlide

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body
{
    self = [super init];
    if ( self ) {
        self.titleText = title;
        self.bodyText = body;
        self.isImageType = NO;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title pictureName:(NSString *)picture openGLManager:(RZGOpenGLManager *)glmgr
{
    self = [super init];
    if ( self ) {
        self.titleText = title;
        self.textureId = [RZGAssetManager loadTexture:picture ofType:@"png" shouldLoadWithMipMapping:NO];
        self.isImageType = YES;
    }
    return self;
}


@end
