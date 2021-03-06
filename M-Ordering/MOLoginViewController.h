//
//  MOLoginViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-20.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"

@interface MOLoginViewController : UIViewController 

@property(nonatomic, retain)MODataController* dataCtrl;

+(MOLoginViewController*)initWithDataCtrl:(MODataController*)ctrl;

-(MOLoginViewController*)initWithDataCtrl:(MODataController*)ctrl;

@end
