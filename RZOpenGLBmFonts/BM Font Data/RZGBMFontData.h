//
//  SSGBMFontData.h
//  SSGOGL
//
//  Created by John Stricker on 3/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class SSGBMFontCharData;

@interface SSGBMFontData : NSObject

@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) GLfloat lineHeight;

-(instancetype)initWithFontFile:(NSString*)fontFile;
-(NSArray*)getCharDataArr;
-(SSGBMFontCharData*)charDataFor:(char)c;

@end
