//
//  MOMainController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"
#import "MOLoginViewController.h"

@interface MOMainController : UITabBarController


@property (nonatomic,strong) MODataController* dataCtrl;
//@property (nonatomic,strong) MOLoginViewController* loginCtrl;

-(void)loadViewControllers;

@end
