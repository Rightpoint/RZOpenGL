//
//  RZGBMFontData.h
//  RZGOGL
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class RZGBMFontCharData;

@interface RZGBMFontData : NSObject

@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) GLfloat lineHeight;

-(instancetype)initWithFontFile:(NSString*)fontFile;
-(NSArray*)getCharDataArr;
-(RZGBMFontCharData*)charDataFor:(char)c;

@end
