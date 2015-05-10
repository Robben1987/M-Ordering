//
//  MORefreshTableView.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MORefreshView.h"


typedef void(^DragEndBlock)(MORefreshViewType);

@interface MORefreshTableView : UITableView<UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, assign) BOOL isShowRefreshHeader;
@property (nonatomic, assign) BOOL isShowRefreshFooter;

@property (nonatomic, assign) CGFloat refreshHeaderHeight;
@property (nonatomic, assign) CGFloat refreshFooterHeight;

@property (nonatomic, copy) DragEndBlock dragEndBlock;


- (id)initWithFrame:(CGRect)frame showRefreshHeader:(BOOL)showHeader showRefreshFooter:(BOOL)showFooter;

- (void)addRefreshHeader;
- (void)addRefreshFooter;

- (void)removeRefreshHeader;
- (void)removeRefreshFooter;

//数据加载（或其他操作）完成后调用，重新隐藏刷新view
- (void)finishRefresh;


@end
