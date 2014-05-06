//
//  RZWebService.m
//  Appapult
//
//  Created by John Stricker on 1/20/14.
//  Copyright (c) 2014 RZ. All rights reserved.
//

#import "RZWebService.h"
#import "Reachability.h"
#import "NSString+WebService.h"

@implementation RZWebService

static NSString * const kHostCheckUrl = @"www.google.com"; //with the host check, don't include http or https
static NSString * const kRZTwitterSearchUrl = @"https://api.twitter.com/1.1/search/tweets.json";

+ (RZWebService*)sharedInstance
{
    static RZWebService *sharedInstance = nil;
    static dispatch_once_t dpoToken;
    dispatch_once(&dpoToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (BOOL)isHostReachable
{
    Reachability *hostReachability = [Reachability reachabilityWithHostName:[kHostCheckUrl copy]];
    NetworkStatus netStatus = [hostReachability currentReachabilityStatus];
    if(netStatus == NotReachable)
        return NO;
    return YES;
}

- (void)searchForTweetsWithHashtag:(NSString *)hashtagString WithCompletionhandler:(requestDictionaryCompletionHandler)complete
{
    NSString *path = [NSString string]
}

- (void)searchAppstoreFor:(NSString*)searchString WithCompletionHandler:(requestDictionaryCompletionHandler)complete;
{
    NSString *path = [NSString stringWithFormat:@"%@%@&entity=software&limit=10",kAppSearchUrl,[searchString urlEncode]];
    [RZWSRequest requestDataFromPath:path onCompletion:complete];
}

- (void)searchForAppsWithDeviceId:(NSString *)deviceId WithCompletionhandler:(requestDictionaryCompletionHandler)complete
{
    NSString *path = [NSString stringWithFormat:@"%@%@",kRequestAppsForDeviceUrl,deviceId];
    [RZWSRequest requestDataFromPath:path onCompletion:complete];
}

- (void)searchForLinksWIthDeviceId:(NSString *)deviceId AppId:(NSString *)appId WithCompleationHandler:(requestDictionaryCompletionHandler)complete
{
    NSString *path = [NSString stringWithFormat:@"%@accountId=%@&appId=%@",kRequestLinksForAppsUrl,deviceId,appId];
    [RZWSRequest requestDataFromPath:path onCompletion:complete];
}

- (void)getAppInfoForAppId:(NSString *)appId WithCompleationhandler:(requestDictionaryCompletionHandler)complete
{
    NSString *path = [NSString stringWithFormat:@"%@%@",kRequestAppInfoWithAppId ,appId];
    [RZWSRequest requestDataFromPath:path onCompletion:complete];
}
@end
