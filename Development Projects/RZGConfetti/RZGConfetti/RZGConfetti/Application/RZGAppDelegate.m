//
//  RZGAppDelegate.m
//  RZGConfetti
//
//  Created by John Stricker on 10/22/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGAppDelegate.h"
#import "RZGExampleMainViewController.h"

@implementation RZGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = [[RZGExampleMainViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
