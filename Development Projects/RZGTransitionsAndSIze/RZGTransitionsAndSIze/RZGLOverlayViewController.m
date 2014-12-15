//
//  RZGLOverlayViewController.m
//  RZGTransitionsAndSIze
//
//  Created by John Stricker on 12/15/14.
//  Copyright (c) 2014 John Stricker. All rights reserved.
//

#import "RZGLOverlayViewController.h"

@interface RZGLOverlayViewController ()

@end

@implementation RZGLOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
