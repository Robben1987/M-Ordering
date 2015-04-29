//
//  MODataOperation.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-31.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MODataOperation : NSObject



+(void)dumpAllMenuList:(NSArray*)array;
+(void)dumpAllRestaurants:(NSMutableDictionary*)dic;

+(void)dumpHttpRequest:(NSURLRequest*)request;
+(void)dumpHttpResponse:(NSURLResponse*)response;
+(void)dumpHttpCookies;




+(BOOL)isLoginPage:(NSString*)htmlString;
+(BOOL)isMenuListPage:(NSString*)htmlString;
+(BOOL)isMyOrderHistoryPage:(NSString*)htmlString;
+(BOOL)isOtherOrdersPage:(NSString*)htmlString;
+(BOOL)isCommentsPage:(NSString*)htmlString;
+(BOOL)isSentOrderSuccessfully:(NSString*)htmlString;
+(BOOL)isCancelOrderSuccessfully:(NSString*)htmlString;
+(BOOL)isSendCommensSuccessfully:(NSString*)htmlString;


+(BOOL)isLoginRequest:(NSString*)url;
+(BOOL)isLogoutRequest:(NSString*)url;
+(BOOL)isOrderRequest:(NSString*)url;
+(BOOL)isCancleOrderRequest:(NSString*)url;
+(BOOL)isSendCommentsRequest:(NSString*)url;
+(BOOL)isGetCommentsRequest:(NSString*)url;
+(BOOL)isMyHistoryRequest:(NSString*)url;
+(BOOL)isOtherOrdersRequest:(NSString*)url;
+(BOOL)isMoneyRequest:(NSString*)url;
+(BOOL)isPasswordRequest:(NSString*)url;


#pragma mark- http interface non-sync
+(void)login:(NSString*)userName andPassword:(NSString*)passWord delegate:(id)delegate;
+(void)logout:(id)delegate;
+(void)order:(unsigned)index delegate:(id)delegate;
+(void)cancel:(unsigned)index delegate:(id)delegate;
+(void)getMyHistory:(id)delegate;
+(void)getOtherOrders:(id)delegate;
+(void)getComments:(unsigned)index delegate:(id)delegate;

#pragma mark- http interface sync
+(BOOL)login:(NSString*)userName andPassword:(NSString*)passWord;
+(BOOL)logout;
+(BOOL)order:(unsigned)index;
+(BOOL)cancel:(unsigned)index;
+(BOOL)comment:(NSString*)content to:(unsigned)index;
+(BOOL)getMyHistory;
+(BOOL)getOtherOrders;
+(BOOL)getComments:(unsigned)index;


+(BOOL)getRestaurants:(NSMutableDictionary*)restaurants andMenus:(NSMutableArray*)array;

//+(void)sendHttpRequest:(NSString*)urlString;
@end
