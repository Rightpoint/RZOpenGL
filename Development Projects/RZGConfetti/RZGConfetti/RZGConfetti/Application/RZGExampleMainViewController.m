//
//  RZGExampleMainViewController.m
//  RZGConfetti
//
//  Created by John Stricker on 10/22/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGExampleMainViewController.h"
#import  "RZGConfettiViewController.h"

@interface RZGExampleMainViewController ()

@property (nonatomic, strong) RZGConfettiViewController *confettiVC;
@property (strong, nonatomic) IBOutlet UIView *confettiContainer;

@end

@implementation RZGExampleMainViewController

- (IBAction)firePressed:(id)sender {
    
    [self.confettiVC fireConfetti];
}

- (IBAction)unloadPressed:(id)sender {
    
    [self.confettiVC.view removeFromSuperview];
    [self.confettiVC removeFromParentViewController];
    
    [self.confettiVC unload];
    
    self.confettiVC = nil;
}

- (IBAction)loadPressed:(id)sender {
    self.confettiVC = [[RZGConfettiViewController alloc] init];
    self.confettiVC.view.opaque = NO;
    
    [self addChildViewController:self.confettiVC];
    [self.confettiContainer addSubview:self.confettiVC.view];
    [self.confettiVC didMoveToParentViewController:self];
}

@end
