//
//  RZFDAppDelegate.m
//  RZFlypDiscs
//
//  Created by John Stricker on 12/8/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZFDAppDelegate.h"
#import "RZFDExampleViewController.h"

@implementation RZFDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RZFDExampleViewController *evc = [[RZFDExampleViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:evc];
    self.window.rootViewController = navController;
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
