//
//  MOSelfViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOSelfViewController.h"
#import "MOMainController.h"
#import "MOToolGroup.h"
#import "MORefreshViewController.h"
#import "MOCommentViewController.h"
#import "MOCommon.h"
#import "MOTableViewController.h"

#define MO_TABLEVIEW_IMAGE_CELL_HEIGHT (100.0f)
#define MO_PORTRAIT_IMAGE_LEN (90.0f)
#define MO_PORTRAIT_PADDING (10.0f)


@interface MOSelfViewController ()
{
    NSMutableArray*     _groups;
    NSIndexPath*        _selectedIndexPath;

}

@end

@implementation MOSelfViewController

+(instancetype)initWithTitle:(NSString*)title style:(UITableViewStyle)style dataCtrl:(MODataController*)dataCtrl
{
    MOSelfViewController* viewCtrl = [[MOSelfViewController alloc] initWithStyle:style];
    [viewCtrl setTitle:title];
    [viewCtrl setDataCtrl:dataCtrl];
    
    return viewCtrl;
}

- (void)viewDidLoad
{
    //static int num = 0;
    //NSLog(@"self:%d", ++num);
    
    [super viewDidLoad];
    
    [self initTablesData];
}

-(void)initTablesData
{
    _groups = [NSMutableArray array];
    
    NSString* name = [self.dataCtrl userName];
    if(!name) name = @"未登录";
    MOToolGroup* group1 = [MOToolGroup initWithName:@"A" andDetail:@"With names beginning with A" andEntrys:[NSMutableArray arrayWithObjects: name, nil]];
    [_groups addObject:group1];
    
    
    MOToolGroup* group2 = [MOToolGroup initWithName:@"B" andDetail:@"With names beginning with B" andEntrys:[NSMutableArray arrayWithObjects: @"我的收藏", @"我的记录", @"我的提醒", nil]];
    [_groups addObject:group2];
    
    MOToolGroup* group3 = [MOToolGroup initWithName:@"C" andDetail:@"With names beginning with C" andEntrys:[NSMutableArray arrayWithObjects: @"设置", nil]];
    [_groups addObject:group3];
    
}

#pragma mark tableView delegate
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
    if(indexPath.section == 0)
    {
        return MO_TABLEVIEW_IMAGE_CELL_HEIGHT;
    }
    
    return MO_TABLEVIEW_CELL_HEIGHT;
}


#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MOSelfcellIdentifier";
    
    MOToolGroup* group = _groups[indexPath.section];
    NSString* entry = group.entrys[indexPath.row];
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if(indexPath.section == 0)
    {
        CGFloat w = MO_PORTRAIT_IMAGE_LEN, h = MO_PORTRAIT_IMAGE_LEN;
        CGFloat y = (MO_TABLEVIEW_IMAGE_CELL_HEIGHT - h)/2;
        CGFloat x = (MO_PORTRAIT_PADDING);
        CGRect imageFrame = CGRectMake(x, y, w, h);
        
        y = (MO_PORTRAIT_IMAGE_LEN/2 - MO_PORTRAIT_PADDING);
        x = (MO_PORTRAIT_PADDING*2 + MO_PORTRAIT_IMAGE_LEN);
        CGRect labelFrame = CGRectMake(x, y, 80, 30);

        [cell.contentView addSubview:[self getCircleImageView:imageFrame
                                                        image:[self.dataCtrl.account portraitImage]]];
        UILabel* textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [textLabel setText:entry];
        [textLabel setFont:[UIFont systemFontOfSize:18]];
        [cell.contentView addSubview:textLabel];
        
    }else
    {
        cell.textLabel.text = entry;
    }
    
    return cell;
}
#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    //return [NSString stringWithFormat:@"the %lu group header", section];
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.2f;
}

#pragma mark 点击行进入新页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            MOTableViewController* vc = [MOTableViewController initWithTitle:@"self" type:MOSelfInfoTableView dataCtrl:self.dataCtrl];
            
            __weak UITableView* table = self.tableView;
            [vc setCallBack:^(void)
            {
                NSArray* indexPaths = @[_selectedIndexPath];
                [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 1)
    {
        if(indexPath.row == 1)
        {
            MORefreshViewController* vc = [[MORefreshViewController alloc] initWithType:MO_REFRESH_MY_HISTORY andDataCtrl: self.dataCtrl];
            [vc setTitle:@"订餐记录"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else
    {
        MOCommentViewController* vc = [[MOCommentViewController alloc] init];
        [vc setTitle:@"评论"];
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentModalViewController:vc animated:YES];
    }
}

#pragma mark get ImageView
-(UIImageView*)getCircleImageView:(CGRect)frame image:(UIImage*)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    [imageView.layer setCornerRadius:(imageView.frame.size.height/2)];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(4, 4);
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shadowRadius = 2.0;
    imageView.layer.borderColor = [[UIColor clearColor] CGColor];
    imageView.layer.borderWidth = 1.0f;
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    
    //UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    //[imageView addGestureRecognizer:portraitTap];

    return imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

