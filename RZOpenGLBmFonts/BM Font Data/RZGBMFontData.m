//
//  SSGBMFontData.m
//  SSGOGL
//
//  Created by John Stricker on 3/7/14.
//  Copyright (c) 2014 Sway Software. All rights reserved.
//

#import "SSGBMFontData.h"
#import "SSGBMFontCharData.h"

static NSMutableDictionary *dict;

@interface SSGBMFontData()

@property (nonatomic, strong) NSArray *charDataArr;

- (void)logData;

@end

@implementation SSGBMFontData

-(instancetype)initWithFontFile:(NSString*)fontFile
{
    self = [super init];
    
    if(dict == nil)
    {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    if([dict objectForKey:fontFile])
    {
        SSGBMFontData *loadedBmd = [dict objectForKey:fontFile];
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
            [mutCharArr addObject:[[SSGBMFontCharData alloc] initWithBmGlyphLine:[lines objectAtIndex:i] andScale:self.scale]];
        }
        
        self.charDataArr = [[NSArray alloc] initWithArray:mutCharArr];
        
        //[self logData];
        [dict setObject:self forKey:fontFile];
    }
    return self;
}

-(SSGBMFontCharData*)charDataFor:(char)c
{
    int charInt = (int)c;
    for(SSGBMFontCharData *cd in self.charDataArr)
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
    for(SSGBMFontCharData *cd in self.charDataArr)
    {
        NSLog(@"CharID: %i(%c): Pos:(%f,%f) W: %f  H: %f Os:(%f,%f)",cd.charId,(char)cd.charId,cd.xPos,cd.yPos,cd.width,cd.height,cd.xOffset,cd.yOffset);
    }
}
@end
