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

@end

@implementation RZGExampleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confettiVC = [[RZGConfettiViewController alloc] init];
    self.confettiVC.view.frame = self.view.bounds;
    self.confettiVC.view.opaque = NO;
    
    [self addChildViewController:self.confettiVC];
    [self.view addSubview:self.confettiVC.view];
}

- (IBAction)firePressed:(id)sender {
    [self.confettiVC fireConfetti];
}


@end
