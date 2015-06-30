//
//  MODataOperation.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-31.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOMenuEntry.h"
#import "MOCommentEntry.h"

@interface MODataOperation : NSObject


#pragma mark- file operation
+(BOOL)isFileExist:(NSString*)fileName;
+(id)readFile:(NSString*)fileName;
+(BOOL)writeObj:(id)obj toFile:(NSString*)fileName;


#pragma mark- http operation
+(NSString*)login:(NSString*)userName andPassword:(NSString*)passWord;
+(BOOL)logout;
+(NSString*)order:(unsigned)index;
+(NSString*)cancel:(unsigned)index;
+(BOOL)comment:(MOCommentEntry*)entry;
+(BOOL)getMyHistory:(NSMutableArray*)array;
+(BOOL)getOtherOrders:(NSMutableArray*)array;
+(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index;
+(BOOL)getRestaurants:(NSMutableDictionary*)restaurants andMenus:(NSMutableArray*)array;

+(BOOL)isLoginPage:(NSString*)htmlString;
+(BOOL)isMenuListPage:(NSString*)htmlString;
+(BOOL)isMyOrderHistoryPage:(NSString*)htmlString;
+(BOOL)isOtherOrdersPage:(NSString*)htmlString;
+(BOOL)isCommentsPage:(NSString*)htmlString;
+(BOOL)isSentOrderSuccessfully:(NSString*)htmlString;
+(BOOL)isCancelOrderSuccessfully:(NSString*)htmlString;
+(BOOL)isSendCommentSuccessfully:(NSString*)htmlString;

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


#pragma mark- dump operation
+(void)dumpAllMenuList:(NSArray*)array;
+(void)dumpAllRestaurants:(NSMutableDictionary*)dic;
+(void)dumpHttpRequest:(NSURLRequest*)request;
+(void)dumpHttpResponse:(NSURLResponse*)response;
+(void)dumpHttpCookies;
@end
