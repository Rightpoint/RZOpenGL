//
//  RZGAssetManager.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZGModelData.h"

@class RZGVaoInfo;

@interface RZGAssetManager : NSObject

+ (GLuint)loadTexture:(NSString*)name ofType:(NSString*)type shouldLoadWithMipMapping:(BOOL)mipMappingOn;
+ (GLuint)loadTextureFromUrl:(NSURL *)url shouldLoadWithMipMapping:(BOOL)mipMappingOn;
+ (RZGVaoInfo*)loadVaoInfo:(NSString*)name;
+ (RZGVaoInfo*)loadVaoInfoFromData:(RZGModelData)data AssignName:(NSString*)name;
+ (void)destroyVAO:(GLuint) vaoName;
+ (void)unload;

@end
