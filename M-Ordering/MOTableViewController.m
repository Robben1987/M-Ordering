//
//  MOTableViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOTableViewController.h"
#import "MOCommon.h"
#import "MOAccount.h"

#define MO_TABLEVIEW_IMAGE_CELL_HEIGHT (70)

@interface MOTableViewController ()
{
    NSMutableArray*     _groups;
    NSIndexPath*        _selectedIndexPath;

}

@end

@implementation MOTableViewController

+(instancetype)initWithTitle:(NSString*)title type:(MOTableViewType)type dataCtrl:(MODataController*)dataCtrl
{
	UITableViewStyle style = UITableViewStyleGrouped;    
    
    MOTableViewController* viewCtrl = [[MOTableViewController alloc] initWithStyle:style];
    [viewCtrl setTitle:title];
    [viewCtrl setDataCtrl:dataCtrl];
    
    return viewCtrl;
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
    
    [self initTablesData];
}

-(void)initTablesData
{
    _groups = [NSMutableArray array];
    
    [self.dataCtrl.account toArray:_groups];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groups count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_groups[section] count];
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
    static NSString* cellIdentifier = @"MOTableCellIdentifier";
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if(indexPath.section == 0)
    {
        NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString* key = [entry.allKeys objectAtIndex:0];
        //[cell.imageView setFrame:CGRectMake(20, 10, 60, 60)];
        //[cell.imageView setImage:[self.dataCtrl.account image]];
        //[cell.imageView setImage:[UIImage imageNamed:@"Robben.jpg"]];
        [cell.textLabel setText: key];
        UIImageView* view = [[UIImageView alloc] initWithImage:[entry objectForKey:key]];
        [view setFrame:CGRectMake(250, 5, MO_TABLEVIEW_IMAGE_CELL_HEIGHT, MO_TABLEVIEW_IMAGE_CELL_HEIGHT-10)];
        [cell.contentView addSubview:view];
    }else
    {
        NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString* key = [entry.allKeys objectAtIndex:0];
        [cell.textLabel setText: key];
        [cell.detailTextLabel setText: [entry valueForKey:key]];
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
    _selectedIndexPath=indexPath;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UIViewController* vc = [[UIViewController alloc] init];
            [vc.view setBackgroundColor:[UIColor yellowColor]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
		NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		NSString* key = [entry.allKeys objectAtIndex:0];

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:key message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	    UITextField* textField = [alert textFieldAtIndex:0];
	    [textField setText:[entry valueForKey:key]];
	    [alert show]; 
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) 
    {
		NSMutableDictionary* entry = [[_groups objectAtIndex:_selectedIndexPath.section] objectAtIndex:_selectedIndexPath.row];
		NSString* key = [entry.allKeys objectAtIndex:0];

		UITextField *textField= [alertView textFieldAtIndex:0];
        [entry setValue:textField.text forKey:key];
        [self.dataCtrl.account updateInfo: entry];
        
        NSArray* indexPaths = @[_selectedIndexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

