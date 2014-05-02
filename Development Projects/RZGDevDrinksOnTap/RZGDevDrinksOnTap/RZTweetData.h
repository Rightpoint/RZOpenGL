//
//  RZTweetData.h
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZTweetData : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *screenName;
@property (copy, nonatomic) NSString *statusText;
@property (copy, nonatomic) NSString *profileImageUrlString;
@property (assign, nonatomic) NSInteger profileImageTextureId;

- (instancetype)initWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText profileImageURLString:(NSString *)imageUrlString;
+ (instancetype)tweetDataWithName:(NSString*)name screenName:(NSString *)screenName statusText:(NSString*)statusText profileImageURLString:(NSString *)imageUrlString;

@end
