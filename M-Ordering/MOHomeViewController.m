//
//  MOHomeViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOHomeViewController.h"
#import "MOMenuViewController.h"
#import "MOMainController.h"

@interface MOHomeViewController ()

-(void)touchUpIndise:(UIButton*)button;
@end

@implementation MOHomeViewController

- (void)loadView
{
    [super loadView];
    
    self.title = @"主页";
    self.tabBarItem.title = @"主页";
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    //[view release];
    
}
- (void)viewDidLoad
{
    static int num = 0;
    NSLog(@"home:%d", ++num);
    [super viewDidLoad];
    
    [self addOtherViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addOtherViews
{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(push)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(90, 100, 140, 40)];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];*/
    
    //1. Top Img
    UIImageView* topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 52, 316, 150)];
    [topImgView setImage:[UIImage imageNamed:@"top.jpg"]];
    [self.view addSubview:topImgView];
    
    //MOMainController* main = (MOMainController*)self.navigationController.tabBarController;
    //unsigned index = 0;
    
    //2. Menu Buttons
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button1 setTitle:@"好清乡" forState:UIControlStateNormal];
    //[button1 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(2, 203, 157, 120)];
    [button1 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button1 setBackgroundColor: [UIColor blueColor]];
    [button1 setBackgroundImage:[UIImage imageNamed:@"frx"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button2 setTitle:@"福荣祥" forState:UIControlStateNormal];
    //[button2 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(161, 203, 157, 120)];
    [button2 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button2 setBackgroundColor: [UIColor greenColor]];
    [button2 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button3 setTitle:@"真功夫" forState:UIControlStateNormal];
    //[button3 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(2, 323, 157, 120)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundColor: [UIColor yellowColor]];
    [button3 setTag:3];
    [self.view addSubview:button3];
    
}

-(void)touchUpIndise:(UIButton*)button
{
    MOMenuViewController* menu = [[MOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    [menu setTitle:[button titleForState:UIControlStateNormal]];
    MOMainController* main = (MOMainController*)self.navigationController.tabBarController;
    NSLog(@"ctrl:%@", main.dataCtrl);
    [menu setDataCtrl: main.dataCtrl];
    [self.navigationController pushViewController:menu animated:YES];
}

#pragma mark - Navigation
- (void)push
{
    UIViewController *vc5 = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc5 animated:YES];
    //[self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@".....home viewDidAppear");
    //[self addOtherViews];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self.tabBarController.tabBar setHidden:YES];
}

@end
