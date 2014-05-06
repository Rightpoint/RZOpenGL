//
//  SOCWSRequest.h
//  SOCiOS
//
//  Created by John Stricker on 11/6/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionHandler)(NSString*,NSError*);
typedef void(^requestDictionaryCompletionHandler)(NSDictionary*);
@interface RZWSRequest : NSObject

+ (void)requestToPath:(NSString*)path withDataString:(NSString*)dataString onCompletion:(requestCompletionHandler)complete;
+ (void)requestDataFromPath:(NSString*)path onCompletion:(requestDictionaryCompletionHandler)complete;
+ (void)requestDataFromPath:(NSString*)path withDataString:(NSString*)dataString onCompletion:(requestDictionaryCompletionHandler)complete;

@end
