//
//  RZGVaoInfo.h
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RZGVaoInfo : NSObject

@property (nonatomic, assign) GLuint vaoIndex;
@property (nonatomic, assign) GLuint vboIndex;
@property (nonatomic, assign) GLuint nVerts;

- (instancetype)initWithVaoIndex:(GLuint)vaoIndex vboIndex:(GLuint)vboIndex andNVerts:(GLuint)nVerts;

@end
