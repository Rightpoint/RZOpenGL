//
//  RZTweetData.h
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZTweetData : NSObject

@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *screenName;
@property (copy, nonatomic) NSString *statusText;
@property (assign, nonatomic) NSInteger profileImageTextureId;

@end
