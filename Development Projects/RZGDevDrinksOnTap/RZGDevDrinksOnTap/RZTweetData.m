//
//  RZTweetData.m
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTweetData.h"

@implementation RZTweetData
- (instancetype)initWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText  profileImageURLString:(NSString *)imageUrlString;
{
    self = [super init];
    if (self) {
        _name = name;
        _screenName = screenName;
        _statusText = statusText;
        _profileImageUrlString = imageUrlString;
    }
    return self;
}
+ (instancetype)tweetDataWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText  profileImageURLString:(NSString *)imageUrlString;
{
    return [[RZTweetData alloc] initWithName:name screenName:screenName statusText:statusText  profileImageURLString:(NSString *)imageUrlString];
}
@end
