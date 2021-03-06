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

#define MO_HOME_AD_IMAGE_HEIGHT (150)
#define MO_MENU_X_PADDING (5)
#define MO_MENU_Y_PADDING (2)


@interface MOHomeViewController ()
{
    NSMutableArray*     _groups;
}
@end


@implementation MOHomeViewController

+(instancetype)initWithTitle:(NSString*)title style:(UITableViewStyle)style dataCtrl:(MODataController*)dataCtrl
{
    MOHomeViewController* viewCtrl = [[MOHomeViewController alloc] initWithStyle:style];
    [viewCtrl setDataCtrl:dataCtrl];
    [viewCtrl setTitle:title];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return viewCtrl;
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
    NSArray* pages = @[@"mavenir", @"mitel"];
    MOImageScrollView* topImgView = [[MOImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MO_HOME_AD_IMAGE_HEIGHT) pages:pages];
    
    NSArray* group1 = @[topImgView];
    [_groups addObject:group1];
    
    //2. quick menu Buttons
    CGFloat w = (self.view.frame.size.width - MO_MENU_X_PADDING * 4)/2;
    CGFloat h = (MO_TABLEVIEW_CELL_HEIGHT - MO_MENU_Y_PADDING * 2);

    CGRect firRect = CGRectMake(MO_MENU_X_PADDING, MO_MENU_Y_PADDING, w, h);
    CGRect secRect = CGRectMake((self.view.frame.size.width/2 + MO_MENU_X_PADDING), MO_MENU_Y_PADDING, w, h);

    UIButton* tel = [UIButton buttonWithType:UIButtonTypeCustom];
    [tel setTitle:@"通讯录" forState:UIControlStateNormal];
    [tel setFrame:firRect];
    [tel addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [tel setBackgroundColor: MO_COLOR_RGBA(126,206,244,1)];
    [tel.layer setCornerRadius:10.0];
    
    UIButton* meet = [UIButton buttonWithType:UIButtonTypeCustom];
    [meet setTitle:@"会议室" forState:UIControlStateNormal];
    [meet setFrame:secRect];
    [meet.layer setCornerRadius:10.0];
    [meet addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [meet setBackgroundColor: MO_COLOR_RGBA(132,204,201,1)];
    
    UIView* util1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
    [util1 addSubview:tel];
    [util1 addSubview:meet];
    
    UIButton* massage = [UIButton buttonWithType:UIButtonTypeCustom];
    [massage setTitle:@"按摩" forState:UIControlStateNormal];
    [massage setFrame:firRect];
    [massage.layer setCornerRadius:10.0];
    [massage addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    [massage setBackgroundColor: MO_COLOR_RGBA(182,184,222,1)];
    
    UIButton* plus = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [plus setFrame:secRect];
    [plus setBackgroundColor: [UIColor lightGrayColor]];
    [plus.layer setCornerRadius:10.0];
    //[plus addTarget:self action:@selector(touchUpIndise:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* util2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
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

-(CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.f;
    if(section == 0)
    {
        height = 0.2f;
    }else
    {
        height = 10.0f;
    }
    
    return height;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        NSString* title = [_groups[indexPath.section] objectAtIndex:indexPath.row];
        MOMenuViewController* menu = [MOMenuViewController initWithTitle:title
                                                                style:UITableViewStylePlain
                                                             dataCtrl:self.dataCtrl];
        [menu setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:menu animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UIView* entry = [_groups[indexPath.section] objectAtIndex:0];
        return (entry.frame.size.height);
    }else
    {
        return MO_TABLEVIEW_CELL_HEIGHT;
    }
}

-(void)touchUpIndise:(UIButton*)button
{
    UIViewController* vc = [[UIViewController alloc] init];
    [vc.view setBackgroundColor:[UIColor yellowColor]];
    [vc setTitle:@"Todo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
