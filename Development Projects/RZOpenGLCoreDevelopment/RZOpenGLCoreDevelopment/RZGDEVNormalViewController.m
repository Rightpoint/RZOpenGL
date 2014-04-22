//
//  RZGDEVNormalViewController.m
//  RZOpenGLCoreDevelopment
//
//  Created by John Stricker on 4/18/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGDEVNormalViewController.h"
#import "RZGDEVGLViewController.h"

@interface RZGDEVNormalViewController ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) RZGDEVGLViewController *glViewController;
@end

@implementation RZGDEVNormalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    
    self.glViewController.view.opaque = NO;
    self.glViewController = [[RZGDEVGLViewController alloc] init];
    CGRect frame =  CGRectMake(7,-10, self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    self.glViewController.view.frame = frame;
    [self.view addSubview:self.glViewController.view];
}

@end
