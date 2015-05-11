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
    
    //get statusbar rect
    //CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //get navigationbar rect
    //CGRect rectNav = self.navigationController.navigationBar.frame;
    
    //CGFloat height = (rectStatus.size.height+rectNav.size.height);
    //CGRect tableFrame = CGRectMake(0, height, self.view.bounds.size.width,(self.view.bounds.size.height - height));
    
    _tableView = [[MORefreshTableView alloc] initWithFrame:self.view.bounds showRefreshHeader:YES showRefreshFooter:NO];
    //_tableView = [[MORefreshTableView alloc] initWithFrame:tableFrame showRefreshHeader:YES showRefreshFooter:NO];
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
        array = [self.dataCtrl getOtherOrders];
    }else
    {
        array = [self.dataCtrl getMyHistory];
    }
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* array = nil;
    if(self.type == MO_REFRESH_OTHERS)
    {
        array = [self.dataCtrl getOtherOrders];
    }else
    {
        array = [self.dataCtrl getMyHistory];
    }
    
    static NSString* cellIdentifier = @"refereshTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Row";
        //todo
    }
    
    return cell;
}

#pragma mark - 获取数据
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
    sleep(5);
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



@end

