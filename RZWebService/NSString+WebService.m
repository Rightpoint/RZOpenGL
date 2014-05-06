//
//  NSString+WebService.m
//  SOCNativePlugIn
//
//  Created by John Stricker on 11/5/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "NSString+WebService.h"

@implementation NSString (WebService)
-(NSString *)urlEncode
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'()::@&=+$,/?#[]",kCFStringEncodingUTF8));
}
-(id)JSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
}
@end
