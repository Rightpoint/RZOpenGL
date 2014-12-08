//
//  RZFDExampleViewController.m
//  RZFlypDiscs
//
//  Created by John Stricker on 12/8/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZFDExampleViewController.h"
#import "RZGViewController.h"
#import "RZFDDiscsViewController.h"

@interface RZFDExampleViewController ()

@property (strong, nonatomic) RZFDDiscsViewController *glViewController;
@end

@implementation RZFDExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glViewController.view.opaque = NO;
    self.glViewController = [[RZFDDiscsViewController alloc] init];
    CGRect frame =  CGRectMake(20,50, self.view.frame.size.width, self.view.frame.size.height);
    self.glViewController.view.frame = frame;
    [self.view addSubview:self.glViewController.view];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.glViewController.view];
}

@end
