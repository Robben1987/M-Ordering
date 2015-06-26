//
//  MOHomeViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"

@interface MOHomeViewController : UITableViewController

@property(nonatomic, retain)MODataController* dataCtrl;

+(MOHomeViewController*)initWithDataCtrl:(MODataController*)dataCtrl;

-(MOHomeViewController*)initWithDataCtrl:(MODataController*)dataCtrl;

@end
