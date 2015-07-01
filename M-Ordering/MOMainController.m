//
//  MOMainController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOMainController.h"
#import "MOHomeViewController.h"
#import "MOSelfViewController.h"
#import "MODiscoveryViewController.h"
#import "MOOthersViewController.h"
#import "MOQuickOrderTableViewController.h"
#import "MOCommon.h"

@interface MOMainController ()
{
}
@end

@implementation MOMainController

- (void)viewDidLoad
{
    static int num = 0;
    NSLog(@"main:%d", ++num);
    
    [super viewDidLoad];
    
    [self initDataCtrl];
    
#if !(NETWORK_ACTIVE)
    [self.dataCtrl loadData];
    [self loadViewControllers];
#else
    //load login view first
    [self performSelectorOnMainThread:@selector(loadLoginView)withObject:nil waitUntilDone:NO];

#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDataCtrl
{
    self.dataCtrl = [MODataController init];
    NSLog(@"data ctrl:%@", self.dataCtrl);
}

- (void)loadLoginView
{
    MOLoginViewController* loginCtrl = [MOLoginViewController initWithDataCtrl: self.dataCtrl];
    
    //[self.view addSubview: self.loginCtrl.view];
    [self presentViewController:loginCtrl animated:YES completion:nil];
    
}

- (void)loadViewControllers
{
    //1. Home view
    MOHomeViewController* homeView = [[MOHomeViewController alloc] initWithDataCtrl:self.dataCtrl];
    UITabBarItem* homeItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home"] tag:0];
    homeView.tabBarItem = homeItem;
    UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    //2. Quick Order view
    MOQuickOrderTableViewController* quickView = [[MOQuickOrderTableViewController alloc] initWithDataCtrl:self.dataCtrl];
    UITabBarItem* quickItem = [[UITabBarItem alloc] initWithTitle:@"快速订餐" image:[UIImage imageNamed:@"magnifier"] tag:1];
    quickView.tabBarItem = quickItem;
    UINavigationController* quickNav = [[UINavigationController alloc] initWithRootViewController:quickView];
    
    //2. Discovery view
    MODiscoveryViewController* disView = [[MODiscoveryViewController alloc] initWithDataCtrl:self.dataCtrl];
    UITabBarItem* disItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"globe"] tag:1];
    disView.tabBarItem = disItem;
    UINavigationController* disNav = [[UINavigationController alloc] initWithRootViewController:disView];
    
    //3. Self view
    MOSelfViewController* selfView = [[MOSelfViewController alloc] initWithDataCtrl:self.dataCtrl];
    UITabBarItem* selfItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"man"] tag:2];
    selfView.tabBarItem = selfItem;
    UINavigationController* selfNav = [[UINavigationController alloc] initWithRootViewController:selfView];
    
    NSArray *viewControllers = @[homeNav, quickNav, disNav, selfNav];
    [self setViewControllers:viewControllers animated:YES];
}


@end
