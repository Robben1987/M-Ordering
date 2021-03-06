//
//  MOMainController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "Reachability.h"

#import "MOMainController.h"
#import "MOHomeViewController.h"
#import "MOSelfViewController.h"
#import "MODiscoveryViewController.h"
#import "MOQuickOrderTableViewController.h"
#import "MOCommon.h"

@interface MOMainController ()
{
    Reachability* _internetReachability;
}
@end

@implementation MOMainController

- (void)viewDidLoad
{
    static int num = 0;
    NSLog(@"main:%d", ++num);
    
    [super viewDidLoad];
    
    [self addObserver];
    
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
    MOHomeViewController* homeView = [MOHomeViewController initWithTitle:@"主页" style:UITableViewStyleGrouped dataCtrl:self.dataCtrl];
    UITabBarItem* homeItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home"] tag:0];
    homeView.tabBarItem = homeItem;
    UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    //2. Quick Order view
    MOQuickOrderTableViewController* quickView = [MOQuickOrderTableViewController initWithTitle:@"快速订餐" style:UITableViewStylePlain dataCtrl:self.dataCtrl];
    UITabBarItem* quickItem = [[UITabBarItem alloc] initWithTitle:@"快速订餐" image:[UIImage imageNamed:@"magnifier"] tag:1];
    quickView.tabBarItem = quickItem;
    UINavigationController* quickNav = [[UINavigationController alloc] initWithRootViewController:quickView];
    
    //2. Discovery view
    MODiscoveryViewController* disView = [MODiscoveryViewController initWithTitle:@"发现" style:UITableViewStyleGrouped dataCtrl:self.dataCtrl];
    UITabBarItem* disItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"globe"] tag:1];
    disView.tabBarItem = disItem;
    UINavigationController* disNav = [[UINavigationController alloc] initWithRootViewController:disView];
    
    //3. Self view
    MOSelfViewController* selfView = [MOSelfViewController initWithTitle:@"我" style:UITableViewStyleGrouped dataCtrl:self.dataCtrl];
    UITabBarItem* selfItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"man"] tag:2];
    selfView.tabBarItem = selfItem;
    UINavigationController* selfNav = [[UINavigationController alloc] initWithRootViewController:selfView];
    
    NSArray *viewControllers = @[homeNav, quickNav, disNav, selfNav];
    [self setViewControllers:viewControllers animated:YES];
}

#pragma mark - add observer
- (void)addObserver
{
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    _internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
}
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
   	if (curReach == _internetReachability)
    {
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
            {
                MO_SHOW_FAIL(@"客官，网络未连接!");
                break;
            }
            case ReachableViaWWAN:
            {
                MO_SHOW_SUCC(@"客官，移动网络已连接!");
                break;
            }
            case ReachableViaWiFi:
            {
                MO_SHOW_SUCC(@"客官，WIFI已连接!");
                break;
            }
            default:
                break;
        }

    }
}

- (void)dealloc
{
    [_internetReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
