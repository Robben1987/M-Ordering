//
//  MOStarRateView.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - Delegate MOStarRateViewDelegate
@class MOStarRateView;

@protocol MOStarRateViewDelegate <NSObject>
@optional
- (void)starRateView:(MOStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end


#pragma mark - Class MOStarRateView
@interface MOStarRateView : UIView

@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0--1，默认为1
@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO

@property (nonatomic, weak) id<MOStarRateViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;

@end

