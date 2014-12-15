//
//  RZGLTransitionMainViewController.m
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGLTransitionMainViewController.h"
#import "RZGLOpenGLViewController.h"
#import <RZZoomBlurAnimationController.h>
#import <RZTransitionsManager.h>
#import "RZGLOverlayViewController.h"

@interface RZGLTransitionMainViewController ()

@end

@implementation RZGLTransitionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RZGLOpenGLViewController *ogVC = [[RZGLOpenGLViewController alloc] init];
    ogVC.glViewSize = CGSizeMake(100.0f, 100.0f);
    ogVC.view.frame = CGRectMake(0, 50, 100.0f, 100.0f);
    [self.view addSubview:ogVC.view];
    
    RZZoomBlurAnimationController *blurAnimationController = [[RZZoomBlurAnimationController alloc] init];
    blurAnimationController.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    [RZTransitionsManager shared].defaultPresentDismissAnimationController = blurAnimationController;
}
- (IBAction)presentTapped:(id)sender
{
    RZGLOverlayViewController *overlayVC = [[RZGLOverlayViewController alloc] init];
    overlayVC.transitioningDelegate = [RZTransitionsManager shared];
    
    [self presentViewController:overlayVC animated:YES completion:nil];
}

@end
