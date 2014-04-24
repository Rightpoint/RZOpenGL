//
//  RZGBMFontCharData.m
//  RZGOGL
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGBMFontCharData.h"

@implementation RZGBMFontCharData
-(instancetype)initWithBmGlyphLine:(NSString *)line andScale:(GLfloat)scale
{
    self = [super init];
    
    NSArray* columns = [line componentsSeparatedByString:@"="];
    
    if([columns count] < 8)
    {
        NSLog(@"ERROR READING FONT FILE, columns less then 8");
        return nil;
    }
    _charId = [((NSString*) [columns objectAtIndex:1]) floatValue];
    _xPos = [((NSString*) [columns objectAtIndex:2]) floatValue]/scale;
    _yPos= 1 - [((NSString*) [columns objectAtIndex:3]) floatValue]/scale;
    _width = [((NSString*) [columns objectAtIndex:4]) floatValue]/scale;
    _height = [((NSString*) [columns objectAtIndex:5]) floatValue]/scale;
    _xOffset = [((NSString*) [columns objectAtIndex:6]) floatValue]/scale;
    _yOffset = [((NSString*) [columns objectAtIndex:7]) floatValue]/scale;
    _xAdvance = [((NSString*) [columns objectAtIndex:8]) floatValue]/scale;
    
    return  self;
}
@end
