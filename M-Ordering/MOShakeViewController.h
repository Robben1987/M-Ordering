//
//  MOShakeViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"


@interface MOShakeViewController : UIViewController

@property(nonatomic, retain)MODataController* dataCtrl;

-(MOShakeViewController*)initWithDataCtrl:(MODataController*)ctrl;

@end
