//
//  SOCWSRequest.m
//  SOCiOS
//
//  Created by John Stricker on 11/6/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZWSRequest.h"
#import "NSString+WebService.h"

static NSString * const kApiKey = @"njThn8pavk2pf0cakgHRwffAQ";
static NSString * const kApiSecret = @"krblCxNbU5w877PuudMmEq6ksAlYYdSlwVBcON7JIUaetRkmSm";
static NSString * const kTwitterRequestUrl = @"https://api.twitter.com/oauth2/token";
@implementation RZWSRequest

+ (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(void)requestTweetsWithHashtag:(NSString *)hashtag
{
    NSString *apiKeyRFC = [kApiKey stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *apiKeySecretRFC = [kApiSecret stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *concatKeySecret = [NSString stringWithFormat:@"%@:%@",apiKeyRFC,apiKeySecretRFC];
    NSString *concatKeySecretBase64 = [self base64String:concatKeySecret];
    
    NSOperationQueue *bgq = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kTwitterRequestUrl]
                                                                cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                            timeoutInterval:5];
    [request setHTTPMethod:@"GET"];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[@"Basic " stringByAppendingString:concatKeySecretBase64] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *str = @"grant-type=client_credentials";
    NSData *httpBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:httpBody];
    
}

+(void)requestToPath:(NSString *)path withDataString:(NSString *)dataString onCompletion:(requestCompletionHandler)complete
{
    NSOperationQueue *bgq = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:5];
    if(dataString)
    {
        [request setURL:[NSURL URLWithString:path]];
        dataString = [NSString stringWithFormat:@"data=%@",dataString];
      //  dataString = [dataString urlEncode];
        NSData *postData = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        [request setHTTPBody:postData];
    }
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:bgq
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if(complete)
                               {
                                   complete(result,error);
                               }
                           }];
}

+(void)requestDataFromPath:(NSString*)path onCompletion:(requestDictionaryCompletionHandler)complete
{
    [self requestDataFromPath:path withDataString:nil onCompletion:complete];
}

+(void)requestDataFromPath:(NSString *)path withDataString:(NSString *)dataString onCompletion:(requestDictionaryCompletionHandler)complete
{
    [RZWSRequest requestToPath:path withDataString:dataString onCompletion:^(NSString *result, NSError *error){
        if(error || [result isEqualToString:@""])
        {
            NSLog(@"Error recieved: %@",error.description);
            if(complete) complete(nil);
        }
        else
        {
          //  NSLog(@"result: %@", result);
             NSDictionary *contestDictionary = [result JSON];
            if(complete) complete(contestDictionary);
        }
    }];
}
@end
