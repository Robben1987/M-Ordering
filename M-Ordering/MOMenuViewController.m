//
//  MOMenuViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-18.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOMenuViewController.h"
#import "MOMainController.h"
#import "MOMenuEntry.h"
#import "MOMenuGroup.h"
#import "MODataOperation.h"
#import "MOCommon.h"

@interface MOMenuViewController ()<UISearchBarDelegate,
                                   UISearchDisplayDelegate,
                                   UIAlertViewDelegate>
{
    UISearchBar*               _searchBar;
    UISearchDisplayController* _searchDisplayController;
    NSMutableArray*            _searchEntrys;//符合条件的搜索联系人
    NSIndexPath*               _selectedIndexPath;
    
}
@end

@implementation MOMenuViewController

+(instancetype)initWithTitle:(NSString*)title style:(UITableViewStyle)style dataCtrl:(MODataController*)dataCtrl
{
    MOMenuViewController* viewCtrl = [[MOMenuViewController alloc] initWithStyle:style];
    [viewCtrl setTitle:title];
    [viewCtrl setDataCtrl:dataCtrl];
    
    return viewCtrl;
}

- (void)loadView
{
    [super loadView];
    
    //1. UITableView
    [self.tableView setDataSource:self];
    
    //2.UISearchBar
    _searchBar=[[UISearchBar alloc]init];
    [_searchBar sizeToFit];//大小自适应容器
    _searchBar.placeholder = @"Please input...";
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton = NO;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    self.tableView.tableHeaderView = _searchBar;
    
    //3. UISearchDisplayController
    _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate=self;
    _searchDisplayController.searchResultsDataSource=self;
    _searchDisplayController.searchResultsDelegate=self;
    [_searchDisplayController setActive:NO animated:YES];
    
    //4. 设置分割风格，不显示分割线
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //如果当前是UISearchDisplayController内部的tableView则不分组
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return _searchEntrys.count;
    }
    
    NSUInteger count = 0;
    if([self.title isEqual:@"快速订餐"])
    {
        count = [[self.dataCtrl menuArray] count];
    }else
    {
        count = [[self.dataCtrl getMenuListByRestaurant: self.title] count];
    }
    
    return count;
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOMenuEntry* entry = nil;
    
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = _searchEntrys[indexPath.row];
    }else
    {
        if([self.title isEqual:@"快速订餐"])
        {
            entry = [[self.dataCtrl menuArray] objectAtIndex:indexPath.row];
        }else
        {
            entry = [[self.dataCtrl getMenuListByRestaurant: self.title] objectAtIndex:indexPath.row];
        }
    }
    
    static NSString *cellIdentifier = @"menuTableView";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIButton* order = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, MO_TABLEVIEW_CELL_HEIGHT, MO_TABLEVIEW_CELL_HEIGHT)];
        [order setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [order addTarget:self action:@selector(touchOrder:) forControlEvents:UIControlEventTouchUpInside];
        [order setTag:indexPath.row];
        [order.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
        [cell setAccessoryView:order];
    }
    [entry dumpEntry];
    [cell.textLabel setText: entry.entryName];
    NSString* detail = [[NSString alloc] initWithFormat:@"%@(人气: %u, 价格: %2.2f, 评论:%u)",
                        entry.restaurant,
                        entry.chosedTimes,
                        entry.price,
                        entry.commentNumber];
    [cell.detailTextLabel setText:detail];
    if(entry.index != [self.dataCtrl ordered])
    {
        [(UIButton*)cell.accessoryView setTitle:@"预定" forState:UIControlStateNormal];
    }else
    {
        [(UIButton*)cell.accessoryView setTitle:@"取消" forState:UIControlStateNormal];
    }
    NSLog(@"textLabel: %@, detailTextLabel:%@", cell.textLabel, cell.detailTextLabel);

    return cell;
}

#pragma mark 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MO_TABLEVIEW_CELL_HEIGHT;
}

#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return @"搜索结果";
    }
    
    return nil;
}

#pragma mark 选中之前
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];//退出键盘
    return indexPath;
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord
{
    _searchEntrys = [NSMutableArray array];
    
    void (^enumerateBlock)(id, NSUInteger, BOOL*) = ^(id obj, NSUInteger idx, BOOL *stop)
    {
        MOMenuEntry* entry = obj;
        if ([entry.entryName.uppercaseString containsString:keyWord.uppercaseString]
            ||[[NSString stringWithFormat:@"%u", entry.index] containsString:keyWord])
        {
            [_searchEntrys addObject:entry];
        }
    };

    if([self.title isEqual:@"快速订餐"])
    {
        [[self.dataCtrl menuArray] enumerateObjectsUsingBlock: enumerateBlock];
    }else
    {
        [[self.dataCtrl getMenuListByRestaurant: self.title] enumerateObjectsUsingBlock: enumerateBlock];
    }
}

#pragma mark - UISearchDisplayController代理方法
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchDataWithKeyWord:searchString];
    return YES;
}


#pragma mark - Button TouchUpInside event
-(void)touchOrder:(UIButton*)button
{
    _selectedIndexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    MOMenuEntry* entry = nil;
    NSString*    detail = nil;
    UIAlertView* alert = nil;

    if([self.dataCtrl isOrdered])
    {
        entry = [self.dataCtrl getOrderedMenuEntry];
        detail = [NSString stringWithFormat:@"%@ 的 %@", entry.restaurant, entry.entryName];
        if(![button.currentTitle isEqualToString:@"取消"])
        {
            MO_SHOW_FAIL(([NSString stringWithFormat:@"您已经预定了: %@", detail]));
            return;
        }else
        {
            alert = [[UIAlertView alloc]initWithTitle:@"取消订单" message:detail delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
                
    }else
    {
        if([self.title isEqual:@"快速订餐"])
        {
            entry = [[self.dataCtrl menuArray] objectAtIndex:button.tag];
        }else
        {
            entry = [[self.dataCtrl getMenuListByRestaurant: self.title] objectAtIndex:button.tag];
        }

        detail = [NSString stringWithFormat:@"%@ 的 %@", entry.restaurant, entry.entryName];

        alert = [[UIAlertView alloc]initWithTitle:@"您预订的是" message:detail delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert setTag:entry.index];
    [alert show];
}

#pragma mark 弹框的代理方法，下订单
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if([alertView.title isEqualToString:@"取消订单"])
        {
            NSLog(@"正在为您取消订单");
            [NSThread detachNewThreadSelector:@selector(cancelOrder:) toTarget:self withObject:alertView];
            MO_SHOW_INFO(@"正在为您取消订单");
        }else
        {
            NSLog(@"订单已经发送");
            [NSThread detachNewThreadSelector:@selector(sendOrder:) toTarget:self withObject:alertView];
            MO_SHOW_INFO(@"正在为您订餐..."); 
        }
    }
    
    return;
}

#pragma mark - http method
-(void)showResult:(NSString*)result
{
    MO_SHOW_HIDE;
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        //reload current cell
        NSArray *indexPaths=@[_selectedIndexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        MO_SHOW_SUCC(@"操作成功!");
    }
}
-(void)sendOrder:(UIAlertView *)alertView
{
    NSString* result = [self.dataCtrl sendOrder: (unsigned)alertView.tag];
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}
-(void)cancelOrder:(UIAlertView *)alertView
{
    NSString* result = [self.dataCtrl cancelOrder: (unsigned)alertView.tag];
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
}
-(void)viewWillDisappear:(BOOL)animated
{
}
@end
