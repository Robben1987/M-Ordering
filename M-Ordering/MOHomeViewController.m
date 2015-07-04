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

//MO_COLOR_RGBA(182,184,222,1)
//MO_COLOR_RGBA(126,206,244,1)
//MO_COLOR_RGBA(132,204,201,1)
//MO_COLOR_RGBA(125,193,221,1)
//MO_COLOR_RGBA(136,171,218,1)

@interface MOHomeViewController ()
{
    NSMutableArray*     _groups;
}
@end


@implementation MOHomeViewController

+(MOHomeViewController*)initWithDataCtrl:(MODataController*)dataCtrl
{
    MOHomeViewController* viewCtrl = [[MOHomeViewController alloc] initWithDataCtrl:dataCtrl];

    return viewCtrl;
}

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
    NSArray* pages = @[@"top.jpg", @"top.jpg"];
    MOImageScrollView* topImgView = [[MOImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150) pages:pages];
    
    NSArray* group1 = @[topImgView];
    [_groups addObject:group1];
    
    //2. quick menu Buttons
    UIButton* tel = [UIButton buttonWithType:UIButtonTypeCustom];
    [tel setTitle:@"通讯录" forState:UIControlStateNormal];
    [tel setFrame:CGRectMake(5, 0, 150, 40)];
    [tel addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [tel setBackgroundColor: MO_COLOR_RGBA(126,206,244,1)];
    [tel.layer setCornerRadius:10.0];
    
    UIButton* meet = [UIButton buttonWithType:UIButtonTypeCustom];
    [meet setTitle:@"会议室" forState:UIControlStateNormal];
    [meet setFrame:CGRectMake(165, 0, 150, 40)];
    [meet.layer setCornerRadius:10.0];
    [meet addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [meet setBackgroundColor: MO_COLOR_RGBA(132,204,201,1)];
    
    UIView* util1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [util1 addSubview:tel];
    [util1 addSubview:meet];
    
    UIButton* massage = [UIButton buttonWithType:UIButtonTypeCustom];
    [massage setTitle:@"按摩" forState:UIControlStateNormal];
    [massage setFrame:CGRectMake(5, 0, 150, 40)];
    [massage.layer setCornerRadius:10.0];
    [massage addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [massage setBackgroundColor: MO_COLOR_RGBA(182,184,222,1)];
    
    UIButton* plus = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [plus setFrame:CGRectMake(165, 0, 150, 40)];
    [plus setBackgroundColor: [UIColor lightGrayColor]];
    [plus.layer setCornerRadius:10.0];
    //[plus addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* util2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [util2 addSubview:massage];
    [util2 addSubview:plus];

    NSArray* group2 = @[util1, util2];
    [_groups addObject:group2];
    
    //3. restruant
    NSArray* group3 = [NSArray arrayWithArray:[self.dataCtrl getRestaurants]];
    [_groups addObject:group3];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groups[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"homeTableView";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section != 2)
    {
        [cell.contentView addSubview:[_groups[indexPath.section] objectAtIndex:indexPath.row]];
    }else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText: [_groups[indexPath.section] objectAtIndex:indexPath.row]];
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"实用工具";
    }else if(section == 2)
    {
        return @"餐馆点餐";
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        NSString* title = [[self.dataCtrl getRestaurants] objectAtIndex:indexPath.row];
        MOMenuViewController* menu = [MOMenuViewController initWithTitle:title
                                                                style:UITableViewStylePlain
                                                             dataCtrl:self.dataCtrl];
        [self.navigationController pushViewController:menu animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 2)
    {
        UIView* entry = [_groups[indexPath.section] objectAtIndex:0];
        return (entry.frame.size.height+5);
    }else
    {
        return 44;
    }
}


-(void)touchUpIndise:(UIButton*)button
{
    UIViewController* vc = [[UIViewController alloc] init];
    [vc.view setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    //[self addOtherViews];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[self.tabBarController.tabBar setHidden:YES];
}
@end
