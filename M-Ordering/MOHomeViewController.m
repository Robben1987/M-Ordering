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
#import "MOCommon.h"
#import "MOImageScrollView.h"


@interface MOHomeViewController ()
{
    NSMutableArray* _groups;
}
@end


@implementation MOHomeViewController

-(MOHomeViewController*)initWithDataCtrl:(MODataController*)dataCtrl
{
    self = [super init];
    if (self)
    {
        [self setTitle:@"主页"];
        [self setDataCtrl:dataCtrl];
        [self.tableView setDataSource:self];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
}

-(void)initData
{
    _groups = [[NSMutableArray alloc]init];
    
    //1. Top Img
    //UIImageView* topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    //[topImgView setImage:[UIImage imageNamed:@"top.jpg"]];
    NSArray* pages = @[@"top.jpg", @"top.jpg"];
    MOImageScrollView* topImgView = [[MOImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150) pages:pages];
    
    NSArray* group1 = @[topImgView];
    [_groups addObject:group1];
    
    //2. quick menu Buttons
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"通讯录" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(5, 0, 150, 40)];
    [button1 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor: MO_COLOR_RGBA(126,206,244,1)];
    [button1.layer setCornerRadius:10.0];
    //[button1 setBackgroundImage:[UIImage imageNamed:@"frx"] forState:UIControlStateNormal];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"会议室" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(165, 0, 150, 40)];
    [button2.layer setCornerRadius:10.0];
    [button2 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundColor: MO_COLOR_RGBA(132,204,201,1)];
    //[button2 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    
    UIView* com1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    //[com1 setBackgroundColor:[UIColor grayColor]];
    [com1 addSubview:button1];
    [com1 addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"按摩" forState:UIControlStateNormal];
    //[button3 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(5, 0, 150, 40)];
    [button3.layer setCornerRadius:10.0];
    [button3 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button3 setBackgroundColor: MO_COLOR_RGBA(136,171,218,1)];
    [button3 setBackgroundColor: MO_COLOR_RGBA(182,184,222,1)];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setTitle:@"+" forState:UIControlStateNormal];
    [button4.titleLabel setFont:[UIFont systemFontOfSize:30.0f]];
    [button4 setFrame:CGRectMake(165, 0, 150, 40)];
    //[button4 setBackgroundColor: MO_COLOR_RGBA(125,193,221,1)];
    [button4 setBackgroundColor: [UIColor lightGrayColor]];
    [button4.layer setCornerRadius:10.0];
    [button4 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* com2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [com2 addSubview:button3];
    [com2 addSubview:button4];

    NSArray* group2 = @[com1, com2];
    [_groups addObject:group2];
    
    //3. restruant
    UIButton *button11 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button11 setTitle:@"好清乡" forState:UIControlStateNormal];
    [button11 setFrame:CGRectMake(5, 0, 310, 40)];
    [button11 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button11 setBackgroundColor: MO_COLOR_RGBA(126,206,244,1)];
    [button11.layer setCornerRadius:10.0];
    //[button1 setBackgroundImage:[UIImage imageNamed:@"frx"] forState:UIControlStateNormal];
    
    UIButton *button21 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button21 setTitle:@"福荣祥" forState:UIControlStateNormal];
    [button21 setFrame:CGRectMake(5, 0, 310, 40)];
    [button21.layer setCornerRadius:10.0];
    [button21 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button21 setBackgroundColor: MO_COLOR_RGBA(132,204,201,1)];
    //[button2 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    
    UIButton *button31 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button31 setTitle:@"真功夫" forState:UIControlStateNormal];
    //[button3 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button31 setFrame:CGRectMake(5, 0, 310, 40)];
    [button31.layer setCornerRadius:10.0];
    [button31 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button3 setBackgroundColor: MO_COLOR_RGBA(136,171,218,1)];
    [button31 setBackgroundColor: MO_COLOR_RGBA(182,184,222,1)];
    
    UIButton *button41 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button41 setTitle:@"+" forState:UIControlStateNormal];
    [button41.titleLabel setFont:[UIFont systemFontOfSize:30.0f]];
    [button41 setFrame:CGRectMake(5, 0, 310, 40)];
    //[button41 setBackgroundColor: MO_COLOR_RGBA(125,193,221,1)];
    [button41 setBackgroundColor: [UIColor lightGrayColor]];
    [button41.layer setCornerRadius:10.0];
    [button41 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray* group3 = @[button11, button21,button31,button41];
    [_groups addObject:group3];
    
}
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groups[section] count];
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"homeTableView";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //[]
    [cell.contentView addSubview:[_groups[indexPath.section] objectAtIndex:indexPath.row]];
    if(indexPath.section == 2)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}
#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* entry = [_groups[indexPath.section] objectAtIndex:0];
    return (entry.frame.size.height+5);
}
#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"实用工具";
    }else if(section == 2)
    {
        return @"餐馆点餐";
    }
    //return [NSString stringWithFormat:@"the %lu group header", section];
    return nil;
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    //return [NSString stringWithFormat:@"the %lu group footer", section];
    return nil;
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

#if 0

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

- (void)didReceiveMemoryWarning 
{
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
    [button1 setTitle:@"好清乡" forState:UIControlStateNormal];
    //[button1 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(5, 205, 157, 40)];
    [button1 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor: [UIColor blueColor]];//#4682B4  70 130 180
    [button1 setBackgroundColor: MO_COLOR_RGBA(126,206,244,1)];
    [button1.layer setCornerRadius:10.0];
    //[button1 setBackgroundImage:[UIImage imageNamed:@"frx"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"福荣祥" forState:UIControlStateNormal];
    //[button2 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(165, 205, 157, 40)];
    [button2.layer setCornerRadius:10.0];
    [button2 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button2 setBackgroundColor: [UIColor greenColor]];
    [button2 setBackgroundColor: MO_COLOR_RGBA(132,204,201,1)];

    //[button2 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"真功夫" forState:UIControlStateNormal];
    //[button3 setTitle:[[main.dataCtrl getRestaurants] objectAtIndex:index++]forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(2, 323, 157, 120)];
    [button3.layer setCornerRadius:10.0];
    //[button3 setContentEdgeInsets:UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5)];
    //[button3 setBackgroundImage:[UIImage imageNamed:@"zgf"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    //[button3 setBackgroundColor: [UIColor yellowColor]];
    //[button3 setBackgroundColor: MO_COLOR_RGBA(136,171,218,1)];
    
    //[button3 setBackgroundColor: MO_COLOR_RGBA(125,193,221,1)];
    [button3 setBackgroundColor: MO_COLOR_RGBA(182,184,222,1)];
    

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
#endif
@end
