//
//  RZTwitterData.m
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTwitterData.h"

@implementation RZTwitterData

- (instancetype) init
{
    self = [super init];
    if (self) {
        _loadedTweets = [[NSMutableArray alloc] init];
        _lastMaxIdIntAsString = @"0";
    }
    return self;
}

- (RZTweetData*)nextTweet
{
    if([self.loadedTweets count] != 0)
    {
        self.currentTweet = self.loadedTweets[0];
        [self.loadedTweets removeObjectAtIndex:0];
    }
    else
    {
        self.currentTweet = nil;
    }
    return self.currentTweet;
}

@end
