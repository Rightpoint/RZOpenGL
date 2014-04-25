//
//  RZGBMFontCharData.h
//  RZGOGL
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface RZGBMFontCharData : NSObject
@property (nonatomic, assign, readonly) GLint charId;
@property (nonatomic, assign, readonly) GLfloat xPos;
@property (nonatomic, assign, readonly) GLfloat yPos;
@property (nonatomic, assign, readonly) GLfloat width;
@property (nonatomic, assign, readonly) GLfloat height;
@property (nonatomic, assign, readonly) GLfloat xOffset;
@property (nonatomic, assign, readonly) GLfloat yOffset;
@property (nonatomic, assign, readonly) GLfloat xAdvance;

-(instancetype)initWithBmGlyphLine:(NSString*)line andScale:(GLfloat)scale;
@end
