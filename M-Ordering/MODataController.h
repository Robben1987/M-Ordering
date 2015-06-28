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

@interface MODataController : NSObject <NSCoding>


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
-(MOMenuEntry*)getOrderedMenuEntry;
-(void)setOrdered:(unsigned)index;
-(BOOL)isOrdered;
-(MOMenuEntry*)getMenuEntrybyName:(NSString*)name;


#pragma sync
-(NSString*)getLogin:(NSString *)name andPassWord:(NSString *)password;
-(BOOL)logout;
-(NSMutableArray*)getMyHistory;
-(BOOL)updateMyHistory;
-(NSMutableArray*)getOtherOrders;
-(BOOL)updateOtherOrders;
-(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index;
-(BOOL)sendComment:(MOCommentEntry*)entry;
-(NSString*)sendOrder:(unsigned)index;
-(NSString*)cancelOrder:(unsigned)index;




@end
