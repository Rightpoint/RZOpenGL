//
//  RZGPSlide.h
//  RZGPresentation
//
//  Created by John Stricker on 9/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RZGModel;
@class RZGOpenGLManager;

@interface RZGPSlide : NSObject

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, assign) NSInteger textureId;
@property (nonatomic, assign) BOOL isImageType;
@property (nonatomic, assign) float imageZAdj;
@property (nonatomic, assign) float imageYAdj;

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body;
- (instancetype)initWithTitle:(NSString *)title pictureName:(NSString *)picture imageZAdj:(float)zAdj imageYAdj:(float)yAdj openGLManager:(RZGOpenGLManager *)glmgr;

@end
