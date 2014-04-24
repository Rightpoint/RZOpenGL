//
//  RZGBMFontData.m
//  RZGOGL
//
//  Created by John Stricker on 4/24/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGBMFontData.h"
#import "RZGBMFontCharData.h"

static NSMutableDictionary *dict;

@interface RZGBMFontData()

@property (nonatomic, strong) NSArray *charDataArr;

- (void)logData;

@end

@implementation RZGBMFontData

-(instancetype)initWithFontFile:(NSString*)fontFile
{
    self = [super init];
    
    if(dict == nil)
    {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    if([dict objectForKey:fontFile])
    {
        RZGBMFontData *loadedBmd = [dict objectForKey:fontFile];
        self.charDataArr = [loadedBmd getCharDataArr];
        self.scale = loadedBmd.scale;
        self.lineHeight = loadedBmd.lineHeight;
    }
    else
    {
        NSString *path =  [[NSBundle mainBundle] pathForResource:fontFile
                                                          ofType:@"fnt"];
        NSString* content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        if(!content)
        {
            NSLog(@"WARNING: Font file %@ not found",fontFile);
            return nil;
        }
        
        NSArray *lines = [content componentsSeparatedByString:@"\n"];
        
        NSArray *dataLine = [((NSString*) [lines objectAtIndex:1]) componentsSeparatedByString:@"="];
        
        self.scale = [((NSString*) [dataLine objectAtIndex:3]) floatValue];
        self.lineHeight = [((NSString*) [dataLine objectAtIndex:1]) floatValue]/self.scale;
        
        NSMutableArray *mutCharArr = [[NSMutableArray alloc] init];
        
        //currently BMFont puts an extra \n at the end, so count - 1
        for(int i = 4; i < [lines count]-1; i++)
        {
            [mutCharArr addObject:[[RZGBMFontCharData alloc] initWithBmGlyphLine:[lines objectAtIndex:i] andScale:self.scale]];
        }
        
        self.charDataArr = [[NSArray alloc] initWithArray:mutCharArr];
        
        //[self logData];
        [dict setObject:self forKey:fontFile];
    }
    return self;
}

-(RZGBMFontCharData*)charDataFor:(char)c
{
    int charInt = (int)c;
    for(RZGBMFontCharData *cd in self.charDataArr)
    {
        if(cd.charId == charInt)
            return cd;
    }
    NSLog(@"WARNING: Char '%c' not present in spritefont",c);
    return nil;
}

-(NSArray*)getCharDataArr
{
    return self.charDataArr;
}

-(void)logData
{
    for(RZGBMFontCharData *cd in self.charDataArr)
    {
        NSLog(@"CharID: %i(%c): Pos:(%f,%f) W: %f  H: %f Os:(%f,%f)",cd.charId,(char)cd.charId,cd.xPos,cd.yPos,cd.width,cd.height,cd.xOffset,cd.yOffset);
    }
}
@end
