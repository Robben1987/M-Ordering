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

@property (nonatomic,strong) NSMutableDictionary* restaurants;
@property (nonatomic,strong) NSMutableArray*      menuArray;
@property (nonatomic,strong) NSMutableArray*      myHistory;
@property (nonatomic,strong) NSMutableArray*      otherOders;
@property (nonatomic,strong) NSMutableArray*      myFavourites;
@property (nonatomic,assign) unsigned             ordered;

@property (nonatomic,copy) NSString*              userName;
@property (nonatomic,copy) NSString*              password; 


#pragma mark constructor
-(MODataController*)init;

#pragma mark static constructor
+(MODataController *)init;

#pragma mark data handle
-(void)loadData;
-(void)saveData;
-(BOOL)isOrdered;
-(NSArray*)getRestaurants;
-(NSArray*)getMenuQuickIndexs;
-(NSArray*)getMenuListByRestaurant:(NSString*)restaurant;
-(NSArray*)getMenuQuickIndexsByRestaurant:(NSString*)restaurant;
-(MOMenuEntry*)getOrderedMenuEntry;
-(MOMenuEntry*)getMenuEntrybyName:(NSString*)name;


#pragma mark http interface-sync
-(NSString*)getLogin:(NSString *)name andPassWord:(NSString *)password;
-(BOOL)logout;
-(BOOL)updateMyHistory;
-(BOOL)updateOtherOrders;
-(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index;
-(BOOL)sendComment:(MOCommentEntry*)entry;
-(NSString*)sendOrder:(unsigned)index;
-(NSString*)cancelOrder:(unsigned)index;




@end
