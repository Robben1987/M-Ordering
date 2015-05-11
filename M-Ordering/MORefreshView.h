//
//  MORefreshView.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-5.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MORefreshViewTypeHeader,
    MORefreshViewTypeFooter
}MORefreshViewType;

typedef enum
{
    MORefreshViewStateDrag,      //下拉可以刷新
    MORefreshViewStateLoose,     //松开立即刷新
    MORefreshViewStateRefreshing          //加载中...
}MORefreshViewState;

@interface MORefreshView : UIView

@property (nonatomic, assign) MORefreshViewState state;

- (id)initWithFrame:(CGRect)frame type:(MORefreshViewType)type;

- (void)flipImageAnimated:(BOOL)animated;
- (void)setCurrentDate;
@end
