//
//  MORefreshViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MORefreshViewController.h"
#import "MORefreshTableView.h"
#import "MOCommon.h"
#import "MODataOperation.h"
#import "MOOrderEntry.h"
#import "MOCommentViewController.h"


const NSInteger MORefreshHeaderHeight = 64;
const NSInteger MORefreshFooterHeight = 50;

@interface MORefreshViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    MORefreshTableView*   _tableView;
    
    BOOL                  _reload;
}

@end


@implementation MORefreshViewController

-(MORefreshViewController*)initWithType:(MO_REFRESH_TABLE_TYPE)type andDataCtrl:(MODataController*)ctrl
{
    self = [super init];
    if (self)
    {
        self.type = type;
        self.dataCtrl = ctrl;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[MORefreshTableView alloc] initWithFrame:self.view.bounds showRefreshHeader:YES showRefreshFooter:NO];
    _tableView.refreshHeaderHeight = MORefreshHeaderHeight;
    _tableView.refreshFooterHeight = MORefreshFooterHeight;
    _tableView.dataSource = self;
    __weak MORefreshViewController *vc = self;    
    _tableView.dragEndBlock = ^(MORefreshViewType type)
    {
        if (type == MORefreshViewTypeHeader)
        {
            [vc updateData];
        }
        else
        {
            //[vc addMoreDataInOtherThread];
        }
    };
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* array = nil;
    if(self.type == MO_REFRESH_OTHERS)
    {
        array = [self.dataCtrl otherOders];
    }else
    {
        array = [self.dataCtrl myHistory];
    }
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOOrderEntry* entry = nil;
    NSMutableArray* array = nil;
    NSString* item = nil;
    NSMutableString* detail = nil;

    UIButton* order = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60, 60)];
    [order setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    if(self.type == MO_REFRESH_OTHERS)
    {
        array = [self.dataCtrl otherOders];
        entry = [array objectAtIndex: indexPath.row];
        
        item  = [NSString stringWithFormat:@"%@ %@",[entry person],[entry.menuEntry entryName]];
        detail = [NSMutableString stringWithFormat:@"%@ %@",[entry.menuEntry restaurant],[entry date]];

        [order setTitle:@"点这个" forState:UIControlStateNormal];
        [order addTarget:self action:@selector(touchOrder:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        array = [self.dataCtrl myHistory];
        entry = [array objectAtIndex: indexPath.row];
        item  = [NSString stringWithFormat:@"%@",[entry.menuEntry entryName]];
        detail  = [NSMutableString stringWithFormat:@"%@ (%.2f 元) %@",
                 [entry.menuEntry restaurant],
                 [entry.menuEntry price],
                 [entry date]];
        [order setTitle: @"点评" forState:UIControlStateNormal];
        [order addTarget:self action:@selector(touchComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    [order setTag: indexPath.row];

    static NSString* cellIdentifier = @"refereshTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setAccessoryView:order];
    
    [cell.textLabel setText: item];
    [cell.detailTextLabel setText: detail];
    return cell;
}

#pragma mark - Button TouchUpInside event
-(void)touchOrder:(UIButton*)button
{
    if([self.dataCtrl isOrdered])
    {
        MO_SHOW_FAIL(([NSString stringWithFormat:@"您已经预定了:"]));
        return;
    }
    
    MOMenuEntry* entry = [[[self.dataCtrl otherOders] objectAtIndex:button.tag] menuEntry];
    NSString* detail = [NSString stringWithFormat:@"%@ 的 %@", entry.restaurant, entry.entryName];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您预订的是" message:detail delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert setTag:entry.index];
    [alert show];
}
-(void)touchComment:(UIButton*)button
{
    MOOrderEntry* orderEntry = [[self.dataCtrl myHistory] objectAtIndex:button.tag];
    MOMenuEntry* menuEntry = [self.dataCtrl getMenuEntrybyName: [orderEntry.menuEntry entryName]];
    [orderEntry.menuEntry setIndex:[menuEntry index]];
    
    MOCommentViewController* commentView = [[MOCommentViewController alloc] initWithComment:orderEntry andDataCtrl:self.dataCtrl];
    [commentView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commentView animated:YES];
    //[self presentViewController:commentView animated:YES completion:nil];
}

#pragma mark Alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if (buttonIndex == 1)
    {
        MO_SHOW_INFO(@"正在为您订餐...");
        [NSThread detachNewThreadSelector:@selector(sendOrder:) toTarget:self withObject:alertView];
    }
    
    return;
}

#pragma mark - Reload data from internet
-(void)showResult:(NSString*)result
{
    MO_SHOW_HIDE;
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        MO_SHOW_SUCC(@"恭喜您,订餐成功!");
    }
}
-(void)sendOrder:(UIAlertView *)alertView
{
    NSString* result = [self.dataCtrl sendOrder: (unsigned)alertView.tag];
    
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}

- (void)reloadData:(NSString*)str
{
    if(str)
    {
        MO_SHOW_FAIL(str);
    }
    
    [_tableView reloadData];
    [_tableView finishRefresh];
}
- (void)downloadData
{
    //sleep(5);
    NSString* str = nil;
    BOOL result = FALSE;

    if(self.type == MO_REFRESH_OTHERS)
    {
        result = [self.dataCtrl updateOtherOrders];
    }else
    {
        result = [self.dataCtrl updateMyHistory];
    }
    
    if(!result)
    {
        str = [NSString stringWithFormat:@"更新失败..."];
    }
    
    [self performSelectorOnMainThread:@selector(reloadData:) withObject:str waitUntilDone:NO];
}
- (void)updateData
{
    [NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
}
- (void)viewDidAppear:(BOOL)animated
{
    //if the contentInset is updated, the scrollViewDidScroll will be trigged
    _tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [_tableView scrollViewDidEndDragging: _tableView willDecelerate:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

