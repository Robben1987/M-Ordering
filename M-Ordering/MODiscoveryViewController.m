//
//  MODiscoveryViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MODiscoveryViewController.h"
#import "MOToolGroup.h"
#import "MORefreshViewController.h"
#import "MOShakeViewController.h"
#import "MOCommon.h"

@interface MODiscoveryViewController ()
{
    NSMutableArray* _groups;

}
@end

@implementation MODiscoveryViewController

+(instancetype)initWithTitle:(NSString*)title style:(UITableViewStyle)style dataCtrl:(MODataController*)dataCtrl
{
    MODiscoveryViewController* viewCtrl = [[MODiscoveryViewController alloc] initWithStyle:style];
    [viewCtrl setDataCtrl:dataCtrl];
    [viewCtrl setTitle:title];
    
    return viewCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTables];
}


-(void)initTables
{
    _groups = [[NSMutableArray alloc]init];
    
    MOToolGroup* group1 = [MOToolGroup initWithName:@"A" andDetail:@"With names beginning with A" andEntrys:[NSMutableArray arrayWithObjects: @"朋友们点了什么", nil]];
    [_groups addObject:group1];
    
    
    MOToolGroup* group2 = [MOToolGroup initWithName:@"B" andDetail:@"With names beginning with B" andEntrys:[NSMutableArray arrayWithObjects: @"摇一摇点餐", @"摇一摇预定按摩", nil]];
    [_groups addObject:group2];
    
    MOToolGroup* group3 = [MOToolGroup initWithName:@"C" andDetail:@"With names beginning with C" andEntrys:[NSMutableArray arrayWithObjects: @"晒图片", nil]];
    [_groups addObject:group3];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groups count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((MOToolGroup*)_groups[section]).entrys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MO_TABLEVIEW_CELL_HEIGHT;
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"discoverycellIdentifier";
    
    MOToolGroup* group = _groups[indexPath.section];
    NSString* entry = group.entrys[indexPath.row];
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:entry];
    return cell;
}

#pragma mark 点击行进入新页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            MORefreshViewController* vc = [[MORefreshViewController alloc] initWithType: MO_REFRESH_OTHERS andDataCtrl: self.dataCtrl];
            [vc setTitle:@"朋友们点了什么"];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            MOShakeViewController* vc = [[MOShakeViewController alloc] initWithDataCtrl: self.dataCtrl];
            [vc setTitle:@"摇一摇点餐"];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            UIViewController* vc = [[UIViewController alloc] init];
            [vc.view setBackgroundColor:[UIColor grayColor]];
            [vc setTitle:@"预定按摩"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        UIViewController* vc = [[UIViewController alloc] init];
        [vc.view setBackgroundColor:[UIColor yellowColor]];
        [vc setTitle:@"图片"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
