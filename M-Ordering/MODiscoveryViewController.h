//
//  MODiscoveryViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"

@interface MODiscoveryViewController : UITableViewController

@property(nonatomic, retain)MODataController* dataCtrl;

+(MODiscoveryViewController*)initWithDataCtrl:(MODataController*)ctrl;

-(MODiscoveryViewController*)initWithDataCtrl:(MODataController*)ctrl;

@end
