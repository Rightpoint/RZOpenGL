//
//  RZTweetData.m
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZTweetData.h"

@implementation RZTweetData
- (instancetype)initWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText profileImageTextureId:(NSInteger)textureId;
{
    self = [super init];
    if (self) {
        _name = name;
        _screenName = screenName;
        _statusText = statusText;
        _profileImageTextureId = textureId;
    }
    return self;
}
+ (instancetype)tweetDataWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText profileImageTextureId:(NSInteger)textureId
{
    return [[RZTweetData alloc] initWithName:name screenName:screenName statusText:statusText profileImageTextureId:textureId];
}
@end
