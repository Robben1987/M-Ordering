//
//  MORefreshTableView.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MORefreshTableView.h"
#import "MOCommon.h"

@implementation MORefreshTableView
{
    MORefreshView* _refreshHeader;
    MORefreshView* _refreshFooter;
    
    BOOL _headerRefreshing;
    BOOL _footerRefreshing;
}

- (id)initWithFrame:(CGRect)frame showRefreshHeader:(BOOL)showHeader showRefreshFooter:(BOOL)showFooter
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.isShowRefreshHeader = showHeader;
        self.isShowRefreshFooter = showFooter;
        
        if (showHeader)
        {
            [self addRefreshHeader];
        }
        
        if (showFooter)
        {
            [self addRefreshFooter];
        }
        
        self.delegate = self;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.refreshHeaderHeight = 64.f;
        self.refreshFooterHeight = 64.f;
    }
    
    return self;
}

- (void)addRefreshHeader
{
    if (self.isShowRefreshHeader && !_refreshHeader)
    {
        CGRect frame = CGRectMake(0, -self.refreshHeaderHeight, self.bounds.size.width, self.refreshHeaderHeight);
        _refreshHeader = [[MORefreshView alloc] initWithFrame:frame type:MORefreshViewTypeHeader];
        [self addSubview:_refreshHeader];
    }
}

- (void)addRefreshFooter
{
    if (self.isShowRefreshFooter && !_refreshFooter)
    {
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        CGRect frame = CGRectMake(0, height, self.bounds.size.width, self.refreshFooterHeight);
        _refreshFooter = [[MORefreshView alloc] initWithFrame:frame type:MORefreshViewTypeFooter];
        self.tableFooterView = _refreshFooter;
    }
}

- (void)removeRefreshHeader
{
    if (_refreshHeader)
    {
        [_refreshHeader removeFromSuperview];
        self.contentInset = UIEdgeInsetsZero;
    }
}

- (void)removeRefreshFooter
{
    if (_refreshFooter)
    {
        [_refreshFooter removeFromSuperview];
        self.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static int i = 1;
    NSLog(@"%d times", i++);
    
    /*MO_SHOW_POINT(@"scrollView contentOffset", scrollView.contentOffset);
    MO_SHOW_SIZE(@"scrollView contentSize", scrollView.contentSize);
    MO_SHOW_RECT(@"scrollView frame", scrollView.frame);
    MO_SHOW_EDGEINSET(@"scrollView contentInset", scrollView.contentInset);
    */
    //动态修改headerView的位置
    /*if (_headerRefreshing)
     {
     if (scrollView.contentOffset.y >= -scrollView.contentInset.top
     && scrollView.contentOffset.y < 0)
     {
     NSLog(@"recorrect ...");
     //注意:修改scrollView.contentInset时，若使当前界面显示位置发生变化，会触发scrollViewDidScroll:，从而导致死循环。
     //因此此处scrollView.contentInset.top必须为-scrollView.contentOffset.y
     scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
     }
     else if (scrollView.contentOffset.y == 0)//到0说明headerView已经在tableView最上方，不需要再修改了
     {
     //scrollView.contentInset = UIEdgeInsetsZero;
     }
     }*/
    
    //拉动足够距离，状态变更为“松开....”
    if (self.isShowRefreshHeader && _refreshHeader)
    {
        if (_refreshHeader.state == MORefreshViewStateDrag
            && scrollView.contentOffset.y < -self.refreshHeaderHeight - 10.f
            && !_headerRefreshing
            && !_footerRefreshing)
        {
            [_refreshHeader flipImageAnimated:YES];
            [_refreshHeader setState:MORefreshViewStateLoose];
        }
    }
    
    if (self.isShowRefreshFooter && _refreshFooter)
    {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        if (_refreshFooter.state == MORefreshViewStateDrag
            && scrollPosition <= self.refreshFooterHeight
            && scrollView.contentOffset.y >= 0.f
            && !_headerRefreshing
            && !_footerRefreshing)
        {
            _footerRefreshing = YES;
            [_refreshFooter setState:MORefreshViewStateRefreshing];
            //执行数据加载操作
            self.dragEndBlock(MORefreshViewTypeFooter);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    /*MO_SHOW_POINT(@"scrollView contentOffset", scrollView.contentOffset);
     MO_SHOW_SIZE(@"scrollView contentSize", scrollView.contentSize);
     MO_SHOW_RECT(@"scrollView frame", scrollView.frame);
     MO_SHOW_EDGEINSET(@"scrollView contentInset", scrollView.contentInset);*/
    
    //拉动足够距离，松开后，状态变更为“加载中...”
    if (self.isShowRefreshHeader && _refreshHeader)
    {
        if (_refreshHeader.state == MORefreshViewStateLoose
            && scrollView.contentOffset.y < -self.refreshHeaderHeight - 10.0f
            && !_headerRefreshing
            && !_footerRefreshing)//每次只允许上拉或者下拉其中一个执行
        {
            _headerRefreshing = YES;
            //使refresh panel保持显示
            self.contentInset = UIEdgeInsetsMake(self.refreshHeaderHeight+64, 0, 0, 0);
            [_refreshHeader setState:MORefreshViewStateRefreshing];
        }
    }
    
    //执行加载数据操作
    if (_headerRefreshing)
    {
        self.dragEndBlock(MORefreshViewTypeHeader);
    }
}

#pragma mark - Other
- (void)finishRefresh
{
    MORefreshView* dragView = nil;
    if (_headerRefreshing)
    {
        dragView = _refreshHeader;
    }
    else if (_footerRefreshing)
    {
        dragView = _refreshFooter;
    }
    
    if (dragView)
    {
        //恢复箭头为原始指向，不需要动画效果
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [self setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
        [UIView commitAnimations];
        
        [dragView flipImageAnimated:NO];
        [dragView setState:MORefreshViewStateDrag];
    }
    
    _headerRefreshing = NO;
    _footerRefreshing = NO;
}


@end

