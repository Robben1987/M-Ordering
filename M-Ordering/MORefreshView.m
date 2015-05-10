//
//  MORefreshView.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-5.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MORefreshView.h"
#import "MOCommon.h"

@implementation MORefreshView
{
    UILabel*      _hintLabel;
    UILabel*      _timeLabel;
    
    UIImageView*             _arrowImageView;
    UIActivityIndicatorView* _indicatorView;
    
    MORefreshViewType       _viewType;
}
- (id)initWithFrame:(CGRect)frame  type:(MORefreshViewType)type
{
    MO_SHOW_RECT(@"RefreshView frame", frame);
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //下拉可以刷新、松开可以刷新、刷新中
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.autoresizingMask =
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _hintLabel.font = [UIFont boldSystemFontOfSize:13.f];
        _hintLabel.textColor        = [UIColor lightGrayColor];
        _hintLabel.backgroundColor  = [UIColor clearColor];
        _hintLabel.textAlignment    = NSTextAlignmentCenter;
        [self addSubview:_hintLabel];
        
        //上次刷新时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.autoresizingMask =
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _timeLabel.font = [UIFont systemFontOfSize:10.f];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        
        //指示箭头
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = [UIImage imageNamed:@"arrow_up"];
        [_arrowImageView layer].transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        [self addSubview:_arrowImageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped  = YES;
        [self addSubview:_indicatorView];
        
        UIImageView *shadowView = [[UIImageView alloc] init];
        [self addSubview:shadowView];
        
        _viewType = type;
        if(type == MORefreshViewTypeHeader)
        {
            shadowView.image = [UIImage imageNamed:@"shadow_up"];
            shadowView.frame = CGRectMake(0, frame.size.height - 5, frame.size.width, 5);
            
            _hintLabel.frame = CGRectMake(0, (frame.size.height - 50.f) / 3, frame.size.width, 30.f);
            _timeLabel.frame = CGRectMake(0, (frame.size.height - 50.f) / 3 + 30.f, frame.size.width, 20.f);
            
            _arrowImageView.frame = CGRectMake(25.f, (frame.size.height - 65.f) / 2,23.f, 60.f);
            _indicatorView.frame = CGRectMake(25.f, (frame.size.height - 20.0f)/2, 20.0f, 20.f);
        }else
        {
            shadowView.image = [UIImage imageNamed:@"shadow_up"];
            shadowView.frame = CGRectMake(0, 0, frame.size.width, 5);
            
            _hintLabel.frame = CGRectMake(0, (frame.size.height - 30.f) / 2, frame.size.width, 30.f);
            _timeLabel.frame = CGRectZero;
            
            _arrowImageView.frame = CGRectZero;
            _indicatorView.frame = CGRectMake(100.f, (frame.size.height - 20.f) / 2, 20.f, 20.f);
        }
        
        //默认状态
        [self setState:MORefreshViewStateDrag];
    }
    
    return self;
}

#pragma mark - 设置刷新时间
- (void)setUpdateDate:(NSDate*)newDate
{
    if (newDate)
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        _timeLabel.text = [NSString stringWithFormat:@"%@%@", @"更新于:", [formatter stringFromDate:newDate]];
    }
    else
    {
        _timeLabel.text = @"从未更新";
    }
}

- (void)setCurrentDate
{
    [self setUpdateDate:[NSDate date]];
}

#pragma mark - 设置状态文本
-(void)setState:(MORefreshViewState)newState
{
    _state = newState;
    if(self.state == MORefreshViewStateDrag)
    {
        if(_viewType == MORefreshViewTypeHeader)
            _hintLabel.text = @"下拉可以刷新";
        else
            _hintLabel.text = @"上拉加载更多";
        [self switchImage:NO];
        [self setCurrentDate];
    }else if(self.state == MORefreshViewStateLoose)
    {
        if(_viewType == MORefreshViewTypeHeader)
            _hintLabel.text = @"松开立即更新";
        else
            _hintLabel.text = @"松开加载更多";
        [self switchImage:NO];
    }else if(self.state == MORefreshViewStateRefreshing)
    {
        _hintLabel.text = @"加载中...";
        [self switchImage:YES];
    }
}

#pragma mark - 箭头和加载菊花
- (void)flipImageAnimated:(BOOL)animated
{
    static BOOL isFlipped = NO;
    NSTimeInterval duration = animated ? .18 : 0.0;
    [UIView animateWithDuration:duration
                     animations:^()
     {
         _arrowImageView.layer.transform = isFlipped ?
         CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) :
         CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
     }];
    
    isFlipped = !isFlipped;
}

- (void)switchImage:(BOOL)animated
{
    if (animated)
    {
        [_indicatorView startAnimating];
        _arrowImageView.hidden = YES;
    }
    else
    {
        [_indicatorView stopAnimating];
        _arrowImageView.hidden = NO;
    }
}


@end
