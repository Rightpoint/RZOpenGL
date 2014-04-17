//
//  RZGVaoInfo.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/17/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGVaoInfo.h"
#import <GLKit/GLKMathTypes.h>

@implementation RZGVaoInfo

- (instancetype)initWithVaoIndex:(GLuint)vaoIndex vboIndex:(GLuint)vboIndex andNVerts:(GLuint)nVerts
{
    self = [super init];
    if( self ) {
        _vaoIndex = vaoIndex;
        _vboIndex = vboIndex;
        _nVerts = nVerts;
    }
    return self;
}

@end
