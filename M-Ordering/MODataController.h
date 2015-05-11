//
//  MODataController.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-29.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

-(BOOL)getLogin:(NSString *)name andPassWord:(NSString *)password viewController:(UIViewController*)viewCtrl;
//-(BOOL)getLogin:(NSString *)name andPassWord:(NSString *)password ;
-(BOOL)logout;
-(BOOL)sendOrder:(unsigned)index viewController:(id)viewCtrl;
-(BOOL)cancelOrder:(unsigned)index viewController:(id)viewCtrl;
-(BOOL)sendComment:(NSString*)content to:(unsigned)index;
-(BOOL)getMyHistory;
-(BOOL)getOtherOrders;
-(BOOL)getComments:(unsigned)index;




@end
