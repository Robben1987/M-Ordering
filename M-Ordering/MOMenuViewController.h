//
//  MOMenuViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-18.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"

@interface MOMenuViewController : UITableViewController

@property(nonatomic, retain)MODataController* dataCtrl;


+(instancetype)initWithTitle:(NSString*)title style:(UITableViewStyle)style dataCtrl:(MODataController*)dataCtrl;

@end
