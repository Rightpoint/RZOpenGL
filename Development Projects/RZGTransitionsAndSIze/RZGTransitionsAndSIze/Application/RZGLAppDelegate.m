//
//  RZGLAppDelegate.m
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGLAppDelegate.h"
#import "RZGLTransitionMainViewController.h"

@implementation RZGLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[RZGLTransitionMainViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
