//
//  MOImageScrollView.h
//  M-Ordering
//
//  Created by Li Robben on 15-6-22.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOImageScrollView : UIView <UIScrollViewDelegate>
{
}

+(id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;

-(id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;

@end
