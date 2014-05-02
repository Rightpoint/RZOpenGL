//
//  RZTwitterData.h
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RZTweetData;

@interface RZTwitterData : NSObject

@property (copy, nonatomic) NSString *lastMaxIdIntAsString;
@property (strong, nonatomic) NSMutableArray *loadedTweets;
@property (strong, nonatomic) RZTweetData *currentTweet;

- (RZTweetData*)nextTweet;

@end
