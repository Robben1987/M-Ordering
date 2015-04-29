//
//  MOOthersViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-17.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOOthersViewController.h"

@interface MOOthersViewController ()

@end

@implementation MOOthersViewController

- (void)loadView
{
    [super loadView];
    
    self.title = @"其他";
    self.tabBarItem.title = @"其他";
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor yellowColor];
    self.view = view;
    //[view release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
