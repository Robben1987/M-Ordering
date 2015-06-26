//
//  MOImageScrollView.m
//  M-Ordering
//
//  Created by Li Robben on 15-6-22.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOImageScrollView.h"

@interface MOImageScrollView ()
{
    UIScrollView*   _scrollView;
    UIPageControl*  _pageControl;
    NSArray*        _pages;
    NSTimer*        _timer;
    
    unsigned        _current;
}
@end

@implementation MOImageScrollView

+(id)initWithFrame:(CGRect)frame pages:(NSArray*)pages
{
    MOImageScrollView* scrollView = [[MOImageScrollView alloc] initWithFrame: frame pages: pages];
    return scrollView;
}

-(id)initWithFrame:(CGRect)frame pages:(NSArray*)pages
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        _pages   = pages;
        _timer   = nil;
        _current = 0;
        
        //Initial ScrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake([pages count] * frame.size.width, 0)];
        [self addSubview:_scrollView];
        
        for(int i = 0; i <  [pages count]; i++)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            [imageView setImage:[UIImage imageNamed:[pages objectAtIndex:i]]];
            [_scrollView addSubview:imageView];
        }
        
        //Initial PageView
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setNumberOfPages:[pages count]];
        [_pageControl sizeToFit];
        [_pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height*0.9)];
        [self addSubview:_pageControl];
        
        //[self addTimer];
    }
    
    return self;
}

- (void)next
{
    unsigned page = (unsigned)[_pageControl currentPage];
    page++;
    page %= _pages.count;
    
    //滚动scrollview
    CGFloat x = page * _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"滚动中");
    
    CGFloat w =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    //NSLog(@"contentSize:%lf, contentOffset:%lf, width:%lf, current:%lu",
    //      scrollView.contentSize.width, x, W, _pageControl.currentPage);
    unsigned page = (x + w / 2) /  w;
    
    [_pageControl setCurrentPage:page];
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    //[self addTimer];
}


@end
