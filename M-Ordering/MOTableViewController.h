//
//  MOTableViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODataController.h"

typedef void(^MOUpdateBlock)(void);

typedef enum
{
    MOSelfInfoTableView,
    MOTableView
}MOTableViewType;

#pragma MOTableViewController
@interface MOTableViewController : UITableViewController

@property(nonatomic, retain)MODataController* dataCtrl;

@property (nonatomic, copy)MOUpdateBlock callBack;


+(instancetype)initWithTitle:(NSString*)title
                        type:(MOTableViewType)type
                    dataCtrl:(MODataController*)dataCtrl;

@end
