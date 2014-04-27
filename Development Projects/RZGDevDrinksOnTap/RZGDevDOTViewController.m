//
//  RZGDevDOTViewController.m
//  RZGDevDrinksOnTap
//
//  Created by John Stricker on 4/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZGDevDOTViewController.h"
#import "RZTwitterData.h"
#import "RZTweetData.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

static const float kRZSecondsPerTweetRequest = 6.0f;
static const float kRZSecondsBetweenDisplayedTweets = 10.0f;
static const float kRZFadeDuration = 0.2f;
static NSString * const kRZHashtagToSearchFor = @"#twitter";
static NSString * const kRZTwitterSearchString = @"https://api.twitter.com/1.1/search/tweets.json";

@interface RZGDevDOTViewController ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) RZTwitterData *twitterData;
@property (assign, nonatomic) double timeSinceLastTwitterCheck;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (assign, nonatomic) BOOL requestInProgress;
@property (strong, nonatomic) NSURLConnection *streamingConnection;
@property (strong, nonatomic) NSMutableData *recievedData;
@property (assign, nonatomic) BOOL firstRun;
@end

@implementation RZGDevDOTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];
    
    self.firstRun = YES;
    self.timeSinceLastTwitterCheck = 0.0;
    self.twitterData = [[RZTwitterData alloc] init];
    self.requestInProgress = YES;
    [self setupAccount];
}

- (void)setupAccount
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0) {
                self.twitterAccount = [accounts objectAtIndex:0];
                [self startStreamForHashtag:@"twitter" withMinIntString:@"0"];
            }
        }
    }];
}

- (void)startStreamForHashtag:(NSString*)hashTag withMinIntString:(NSString*)minIntString
{
    self.requestInProgress = YES;
    
    NSDictionary *params = @{@"q" : hashTag, @"since_id":minIntString, @"include_rts" : @"0", @"resultType" : @"recent"};
    
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:kRZTwitterSearchString] parameters:params];
    [twitterInfoRequest setAccount:self.twitterAccount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.streamingConnection = [NSURLConnection connectionWithRequest:[twitterInfoRequest preparedURLRequest] delegate:self];
        [self.streamingConnection start];
    });
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(data) {
        
        if(!self.recievedData) {
            self.recievedData = [NSMutableData data];
        }
        
        [self.recievedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.recievedData)
    {
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:self.recievedData options:NSJSONReadingMutableLeaves error:&error];
        
        if(dataDict) {
            [self generateTweetsFromDictionary:dataDict];
        }
    }
    self.recievedData = nil;
    self.requestInProgress = NO;
}

- (void)generateTweetsFromDictionary:(NSDictionary *)dataDict
{
    NSDictionary *metaData = dataDict[@"search_metadata"];
    
    NSString *maxInt = [NSString stringWithFormat:@"%@",[metaData[@"max_id"] stringValue]];
    if(maxInt) {
        self.twitterData.lastMaxIdIntAsString = maxInt;
    }
    
    if (self.firstRun) {
        self.firstRun = NO;
    }
    else {
        NSArray *statuses = dataDict[@"statuses"];
        
        for (NSDictionary *status in statuses) {
            
            NSLog(@"%@ - %@", [status objectForKey:@"text"], [[status objectForKey:@"user"] objectForKey:@"screen_name"]);
            NSDictionary *userDict = [status objectForKey:@"user"];
            
            NSString *name = userDict[@"name"];
            NSString *screenName = userDict[@"screen_name"];
            NSString *text = status[@"text"];
            NSInteger imageId = [RZGAssetManager loadTextureFromUrl:[NSURL URLWithString:userDict[@"profile_image_url"]]  shouldLoadWithMipMapping:NO];
            
            [self.twitterData.loadedTweets addObject:[RZTweetData tweetDataWithName:name screenName:screenName statusText:text profileImageTextureId:imageId]];
        }
    }
}

- (void)update
{
    [super update];
    
    self.timeSinceLastTwitterCheck += self.timeSinceLastUpdate;
    if(self.timeSinceLastTwitterCheck >= kRZSecondsPerTweetRequest){
        self.timeSinceLastTwitterCheck = 0.0;
        [self startStreamForHashtag:kRZHashtagToSearchFor withMinIntString:self.twitterData.lastMaxIdIntAsString];
    }
    
}


@end
