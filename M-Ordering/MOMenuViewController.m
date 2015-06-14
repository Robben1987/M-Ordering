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
    NSMutableArray*            _menus;
    NSMutableArray*            _groups;
    UISearchBar*               _searchBar;
    UISearchDisplayController* _searchDisplayController;
    NSMutableArray*            _searchEntrys;//符合条件的搜索联系人
    UIButton* _button;
    NSIndexPath*               _selectedIndexPath;
    
}
@end

@implementation MOMenuViewController

-(MOMenuViewController*)initWithDataCtrl:(MODataController*)dataCtrl
{
    self = [super init];
    if (self)
    {
        self.dataCtrl = dataCtrl;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //[self.navigationController.tabBarController.tabBar setHidden:YES];
    
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
    
    //return _groups.count;
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
        count = [[self.dataCtrl getMenuList] count];
    }else
    {
        count = [[self.dataCtrl getMenuListByRestaurant: self.title] count];
    }
    return count;
}

#pragma mark返回每行的单元格
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOMenuEntry* entry = nil;
    
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry =_searchEntrys[indexPath.row];
    }else
    {
        MOMenuGroup* group = _groups[indexPath.section];
        entry = group.entrys[indexPath.row];
    }
    
    static NSString *cellIdentifier = @"UITableViewCellIdentifierKey1";
    
    //首先根据标识去缓存池取
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = entry.entryName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%u", entry.index];
    
    return cell;
}*/
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOMenuEntry* entry = nil;
    
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry =_searchEntrys[indexPath.row];
    }else
    {
        if([self.title isEqual:@"快速订餐"])
        {
            entry = [[self.dataCtrl getMenuList] objectAtIndex:indexPath.row];
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
        
        UIButton* order = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50, 50)];
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
//#if (NETWORK_ACTIVE)
    if(entry.index != [self.dataCtrl getOrdered])
//#else
//    if(entry.index != 76)
//#endif
    {
        [(UIButton*)cell.accessoryView setTitle:@"预定" forState:UIControlStateNormal];
    }else
    {
        [(UIButton*)cell.accessoryView setTitle:@"取消" forState:UIControlStateNormal];
    }
    NSLog(@"textLabel: %@, detailTextLabel:%@", cell.textLabel, cell.detailTextLabel);

    return cell;
}

-(void)initData
{
    //_menus = [[NSMutableArray alloc] initWithObjects:
              //@"番茄炒蛋", @"青椒肉丝", @"回锅肉",@"番茄炒蛋", @"青椒肉丝", @"回锅肉", nil];
    
    _groups = [[NSMutableArray alloc]init];
    
    unsigned index = 0;
    MOMenuEntry* entry1 = [MOMenuEntry initWithName:@"番茄炒蛋" andIndex:index++];
    MOMenuEntry* entry2 = [MOMenuEntry initWithName:@"青椒肉丝" andIndex:index++];
    MOMenuEntry* entry3 = [MOMenuEntry initWithName:@"回锅肉" andIndex:index++];
    MOMenuEntry* entry4 = [MOMenuEntry initWithName:@"鸡腿饭" andIndex:index++];
    MOMenuGroup* group1 = [MOMenuGroup initWithName:@"A" andDetail:@"With names beginning with A" andEntrys:[NSMutableArray arrayWithObjects:entry1, entry2,entry3,entry4,nil]];
    [_groups addObject:group1];
    
    MOMenuEntry* entry5 = [MOMenuEntry initWithName:@"牛腩饭" andIndex:index++];
    MOMenuEntry* entry6 = [MOMenuEntry initWithName:@"香汁排骨" andIndex:index++];
    MOMenuEntry* entry7 = [MOMenuEntry initWithName:@"卤肉饭" andIndex:index++];
    MOMenuEntry* entry8 = [MOMenuEntry initWithName:@"红烧肉" andIndex:index++];
    MOMenuGroup* group2 = [MOMenuGroup initWithName:@"B" andDetail:@"With names beginning with B" andEntrys:[NSMutableArray arrayWithObjects:entry5, entry6,entry7,entry8,nil]];
    [_groups addObject:group2];
    
    MOMenuEntry* entry9 = [MOMenuEntry initWithName:@"鱼香茄子" andIndex:index++];
    MOMenuEntry* entry10 = [MOMenuEntry initWithName:@"宫保鸡丁" andIndex:index++];
    MOMenuEntry* entry11 = [MOMenuEntry initWithName:@"水煮鱼" andIndex:index++];
    MOMenuGroup* group3 = [MOMenuGroup initWithName:@"C" andDetail:@"With names beginning with C" andEntrys:[NSMutableArray arrayWithObjects:entry9, entry10,entry11, nil]];
    [_groups addObject:group3];
    
}

#pragma mark - 代理方法

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return @"搜索结果";
    }
    
    MOMenuGroup* group=_groups[section];
    return group.groupName;
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    //MOMenuGroup* group=_groups[section];
    //return group.detail;
    return nil;
}

#pragma mark 返回每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* indexs=[[NSMutableArray alloc] init];
    for(MOMenuGroup* group in _groups)
    {
        [indexs addObject: group.groupName];
    }
    return indexs;
}

#pragma mark 选中之前
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];//退出键盘
    return indexPath;
}

#if 0
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 50;
    }
    return 40;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
#endif

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord
{
    _searchEntrys=[NSMutableArray array];
    [_groups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        MOMenuGroup* group = obj;
        [group.entrys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            MOMenuEntry* entry = obj;
            if ([entry.entryName.uppercaseString containsString:keyWord.uppercaseString]
                ||[[NSString stringWithFormat:@"%u", entry.index] containsString:keyWord])
            {
                [_searchEntrys addObject:entry];
            }
        }];
    }];
}

#pragma mark - 搜索框代理
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
        if([button.currentTitle isEqualToString:@"预订"])
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
            entry = [[self.dataCtrl getMenuList] objectAtIndex:button.tag];
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
@end
