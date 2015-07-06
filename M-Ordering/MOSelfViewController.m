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

@interface MOSelfViewController ()
{
    NSMutableArray* _groups;
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
    
    MOToolGroup* group1 = [MOToolGroup initWithName:@"A" andDetail:@"With names beginning with A" andEntrys:[NSMutableArray arrayWithObjects: [self.dataCtrl userName], nil]];
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
        return 100;
    }
    
    return 44;
}




#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    
    MOToolGroup* group = _groups[indexPath.section];
    NSString* entry = group.entrys[indexPath.row];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.imageView setFrame:CGRectMake(20, 10, 60, 60)];
        [cell.imageView setImage:[self.dataCtrl.account image]];
        //[cell.imageView setImage:[UIImage imageNamed:@"Robben.jpg"]];
        [cell.textLabel setText:entry];
        [cell.textLabel setFrame:CGRectMake(100, 20, 50, 30)];
        
    }else if(indexPath.section == 1)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = entry;
        //NSLog(@"section %ld: %@", indexPath.section, cell);
    }else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = entry;
        //NSLog(@"section %ld: %@", indexPath.section, cell);

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
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UIViewController* vc = [[UIViewController alloc] init];
            [vc.view setBackgroundColor:[UIColor yellowColor]];
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
    
    
    /*
     UIViewController* vc = [[UIViewController alloc] init];
     [vc.view setBackgroundColor:[UIColor yellowColor]];
     [self.navigationController pushViewController:vc animated:YES];
     */
    
    //    //创建弹出窗口
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"System Info" message:[contact getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //    alert.alertViewStyle=UIAlertViewStylePlainTextInput; //设置窗口内容样式
    //    UITextField *textField= [alert textFieldAtIndex:0]; //取得文本框
    //    textField.text=contact.phoneNumber; //设置文本框内容
    //    [alert show]; //显示窗口
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

