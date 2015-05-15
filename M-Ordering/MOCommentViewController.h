//
//  MOCommentViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-12.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOOrderEntry.h"
#import "MODataController.h" 
#import "MOCommentEntry.h"


@interface MOCommentViewController : UIViewController

@property(nonatomic, retain)MODataController*   dataCtrl;
@property(nonatomic, retain)MOCommentEntry*     commentEntry;

-(MOCommentViewController*)initWithComment:(MOCommentEntry*)commentEntry andDataCtrl:(MODataController*)ctrl;

@end
