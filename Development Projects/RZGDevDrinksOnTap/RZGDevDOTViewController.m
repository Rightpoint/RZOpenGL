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
#import "RZGBMFontHeaders.h"

static const float kRZSecondsPerTweetRequest = 6.0f;
static const float kRZSecondsBetweenDisplayedTweets = 8.0f;
static const float kRZFadeDuration = 0.2f;
static NSString * const kRZHashtagToSearchFor = @"#drinksontap";
static NSString * const kRZTwitterSearchString = @"https://api.twitter.com/1.1/search/tweets.json";

@interface RZGDevDOTViewController ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) RZTwitterData *twitterData;
@property (assign, nonatomic) double timeSinceLastTwitterCheck;
@property (assign, nonatomic) double timeCurrentTweetIsOnScreen;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (assign, nonatomic) BOOL requestInProgress;
@property (strong, nonatomic) NSURLConnection *streamingConnection;
@property (strong, nonatomic) NSMutableData *recievedData;
@property (assign, nonatomic) BOOL firstRun;
@property (strong, nonatomic) RZGBMFontModel *tweetPromptModel;
@property (strong, nonatomic) RZGBMFontModel *tweetTextModel;
@property (strong, nonatomic) RZGBMFontModel *tweetNameModel;
@property (strong, nonatomic) RZGModel *tweetPicModel;
@property (strong, nonatomic) RZGModel *dotModel;
@property (strong, nonatomic) RZGModel *dotModel2;

@end

@implementation RZGDevDOTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glmgr = [[RZGOpenGLManager alloc] initWithView:self.glkView ScreenSize:self.view.bounds.size PerspectiveInRadians:GLKMathDegreesToRadians(45.0f) NearZ:0.1f FarZ:100.0f];
    [self.glmgr setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];
    
    self.firstRun = YES;
    self.timeSinceLastTwitterCheck = 0.0;
    self.timeCurrentTweetIsOnScreen = 0.0;
    self.twitterData = [[RZTwitterData alloc] init];
    self.requestInProgress = YES;
    [self setupAccount];
    
    [self setupTweetModels];
    
    self.dotModel = [[RZGModel alloc] initWithModelFileName:@"dotHoneyComb2" UseDefaultSettingsInManager:self.glmgr];
    self.dotModel.shadowMax = 0.5f;
    self.dotModel.prs.pz = -5.5f;
    self.dotModel.prs.py = 0.75f;
    self.dotModel.prs.px = -0.0f;
    self.dotModel.prs.rz = 0.5f;
    self.dotModel.prs.ry = 0.5f;
    [self.dotModel setTexture0Id:[RZGAssetManager loadTexture:@"dotImageSheet" ofType:@"png" shouldLoadWithMipMapping:YES]];
    [self.modelController addModel:self.dotModel];

}

- (void)setupTweetModels
{
    [self.glmgr loadBitmapFontShaderAndSettings];
    
    RZGBMFontData *goldFontData = [[RZGBMFontData alloc] initWithFontFile:@"dotRedFont"];
    int goldTextureId = [RZGAssetManager loadTexture:@"dotRedFont" ofType:@"png" shouldLoadWithMipMapping:YES];
    
    RZGBMFontData *whiteFontData = [[RZGBMFontData alloc] initWithFontFile:@"whiteHn"];
    int whiteTextureId = [RZGAssetManager loadTexture:@"whiteHn" ofType:@"png" shouldLoadWithMipMapping:YES];
    
    self.tweetPromptModel = [[RZGBMFontModel alloc] initWithName:@"promptText" BMfontData:whiteFontData UseGLManager:self.glmgr];
    [self.tweetPromptModel setTexture0Id:whiteTextureId];
    self.tweetPromptModel.centerHorizontal = YES;
    self.tweetPromptModel.centerVertical = YES;
    [self.tweetPromptModel setupWithCharMax:50];
    [self.tweetPromptModel updateWithText:[NSString stringWithFormat:@"tweet %@~to see your tweet here!",kRZHashtagToSearchFor]];

    self.tweetPromptModel.prs.pz = -2.0f;
    self.tweetPromptModel.prs.py = -0.5f;
    
    self.tweetTextModel = [[RZGBMFontModel alloc] initWithName:@"tweetText" BMfontData:goldFontData UseGLManager:self.glmgr];
    [self.tweetTextModel setTexture0Id:goldTextureId];
    [self.tweetTextModel setupWithCharMax:200];
    self.tweetTextModel.isHidden = YES;
    self.tweetTextModel.prs.sxyz = 1.0f;
    self.tweetTextModel.prs.pz = -2.0f;
    self.tweetTextModel.prs.py = -0.4f;
    self.tweetTextModel.prs.px = -0.95f;
    self.tweetTextModel.maxWidth = 2.4f;
    
    self.tweetNameModel = [[RZGBMFontModel alloc] initWithName:@"tweetNameModel" BMfontData:whiteFontData UseGLManager:self.glmgr];
    [self.tweetNameModel setTexture0Id:whiteTextureId];
    [self.tweetNameModel setupWithCharMax:200];
    self.tweetNameModel.isHidden = YES;
    self.tweetNameModel.prs.sxyz = 1.2f;
    self.tweetNameModel.prs.pz = -2.0f;
    self.tweetNameModel.prs.py = -0.25f;
    self.tweetNameModel.prs.px = -1.4f;
    
    self.tweetPicModel = [[RZGModel alloc] initWithModelFileName:@"quad" UseDefaultSettingsInManager:self.glmgr];
    self.tweetPicModel.prs.px = -6.0f;
    self.tweetPicModel.prs.pz = -10.0f;
    self.tweetPicModel.isHidden = YES;
    self.tweetPicModel.prs.py = -2.4f;
    
    [self.modelController addModel:self.tweetPromptModel];
    [self.modelController addModel:self.tweetTextModel];
    [self.modelController addModel:self.tweetNameModel];
    [self.modelController addModel:self.tweetPicModel];
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
            
        //    NSLog(@"%@ - %@", [status objectForKey:@"text"], [[status objectForKey:@"user"] objectForKey:@"screen_name"]);
            NSDictionary *userDict = [status objectForKey:@"user"];
            
            NSString *name = userDict[@"name"];
            NSString *screenName = userDict[@"screen_name"];
            NSString *text = status[@"text"];
            NSString *imageURL = userDict[@"profile_image_url"];
            imageURL = [imageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
            
            
            
            [self.twitterData.loadedTweets addObject:[RZTweetData tweetDataWithName:name screenName:screenName statusText:text profileImageURLString:imageURL]];
        }
    }
}

- (void)showNextTweet
{
    RZTweetData *tweet = [self.twitterData nextTweet];
    
    if(tweet) {
        [self.tweetPicModel setTexture0Id:[RZGAssetManager loadTextureFromUrl:[NSURL URLWithString:tweet.profileImageUrlString] shouldLoadWithMipMapping:NO]];
        [self.tweetTextModel updateWithText:tweet.statusText];
        [self.tweetNameModel updateWithText:tweet.screenName];
        self.tweetPromptModel.isHidden = YES;
        self.tweetPicModel.isHidden = NO;
        self.tweetNameModel.isHidden = NO;
        self.tweetTextModel.isHidden = NO;
    }
    else {
        self.tweetPromptModel.isHidden = NO;
        self.tweetPicModel.isHidden = YES;
        self.tweetNameModel.isHidden = YES;
        self.tweetTextModel.isHidden = YES;
    }
}

- (void)fadePromptToAlpha:(GLfloat)alpha WithDelay:(GLfloat)delay
{
    [self.tweetPromptModel addCommand:[[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(alpha) Duration:kRZFadeDuration IsAbsolute:YES Delay:delay]];
}

- (void)fadeTweetToAlpha:(GLfloat)alpha WithDelay:(GLfloat)delay
{
    [self.tweetPicModel addCommand:[[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(alpha) Duration:kRZFadeDuration IsAbsolute:YES Delay:delay]];
    [self.tweetNameModel addCommand:[[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(alpha) Duration:kRZFadeDuration IsAbsolute:YES Delay:delay]];
    [self.tweetTextModel addCommand:[[RZGCommand alloc] initWithCommandEnum:kRZGCommand_alpha Target:GLKVector4MakeWith1f(alpha) Duration:kRZFadeDuration IsAbsolute:YES Delay:delay]];
}

- (void)update
{
    [super update];
    
    self.timeSinceLastTwitterCheck += self.timeSinceLastUpdate;
    if(self.timeSinceLastTwitterCheck >= kRZSecondsPerTweetRequest){
        self.timeSinceLastTwitterCheck = 0.0;
        [self startStreamForHashtag:kRZHashtagToSearchFor withMinIntString:self.twitterData.lastMaxIdIntAsString];
    }
    
    self.timeCurrentTweetIsOnScreen += self.timeSinceLastUpdate;
    if(self.timeCurrentTweetIsOnScreen >= kRZSecondsBetweenDisplayedTweets){
        self.timeCurrentTweetIsOnScreen = 0.0;
        [self showNextTweet];
    }
    
}


@end
