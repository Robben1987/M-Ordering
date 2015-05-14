//
//  MODataController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-29.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MOCommentEntry.h"
#import "MOMenuEntry.h"

@interface MODataController : NSObject


#pragma mark constructor
-(MODataController*)init;

#pragma mark static constructor
+(MODataController *)init;

-(void)initData;
-(NSArray*)getRestaurants;
-(NSArray*)getMenuList;
-(NSArray*)getMenuQuickIndexs;
-(NSArray*)getMenuListByRestaurant:(NSString*)restaurant;
-(NSArray*)getMenuQuickIndexsByRestaurant:(NSString*)restaurant;
-(unsigned)getOrdered;
-(void)setOrdered:(unsigned)index;
-(BOOL)isOrdered;

#pragma non-sync
-(BOOL)getLogin:(NSString *)name andPassWord:(NSString *)password viewController:(UIViewController*)viewCtrl;
//-(BOOL)getLogin:(NSString *)name andPassWord:(NSString *)password ;
-(BOOL)logout;
-(BOOL)sendOrder:(unsigned)index viewController:(id)viewCtrl;
-(BOOL)cancelOrder:(unsigned)index viewController:(id)viewCtrl;
-(BOOL)sendComment:(MOCommentEntry*)entry;
-(NSMutableArray*)getMyHistory;
-(BOOL)updateMyHistory;
-(NSMutableArray*)getOtherOrders;
-(BOOL)updateOtherOrders;
-(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index;

#pragma sync
-(BOOL)sendOrder:(unsigned)index;



-(MOMenuEntry*)getMenuEntrybyName:(NSString*)name;
@end
