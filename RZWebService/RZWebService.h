//
//  RZWebService.h
//  Appapult
//
//  Created by John Stricker on 1/20/14.
//  Copyright (c) 2014 RZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZWSRequest.h"

@interface RZWebService : NSObject
+ (RZWebService*)sharedInstance;
- (BOOL)isHostReachable;
- (void)searchForTweetsWithHashtag:(NSString*)hashtagString WithCompletionhandler:(requestDictionaryCompletionHandler)complete;

- (void)searchAppstoreFor:(NSString*)searchString WithCompletionHandler:(requestDictionaryCompletionHandler)complete;
- (void)searchForAppsWithDeviceId:(NSString*)deviceId WithCompletionhandler:(requestDictionaryCompletionHandler)complete;
- (void)searchForLinksWIthDeviceId:(NSString *)deviceId AppId:(NSString *)appId WithCompleationHandler:(requestDictionaryCompletionHandler)complete;
- (void)getAppInfoForAppId:(NSString*)appId WithCompleationhandler:(requestDictionaryCompletionHandler)complete;
@end
