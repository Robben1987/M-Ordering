//
//  MODataController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-29.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MODataController.h"
#import "MODataOperation.h"
#import "MOMenuGroup.h"
#import "MOMenuEntry.h"
#import "MOLoginDelegate.h"
#import "MOCommon.h"
#import "MOLoginViewController.h"

#define MO_BACK_TO_MAIN_THREAD(para)\
[self performSelectorOnMainThread:@selector(backToMain:) withObject:para waitUntilDone:NO];

@interface MODataController ()
{
    NSString*     _userName;
    NSString*     _passWord;
    
    NSMutableDictionary*  _restaurants;
    NSMutableArray* _menuArray;
    NSMutableData*  _responseData;
    
    NSMutableArray* _myHistory;
    NSMutableArray* _otherOders;
    NSMutableArray* _myFavourites;
    
    id _viewCtrl;
    unsigned _ordered;
}
@end


@implementation MODataController

#pragma mark constructor
-(MODataController*)init
{
    if((self = [super init]))
    {
        _menuArray = [[NSMutableArray alloc] init];
        _restaurants = [[NSMutableDictionary alloc] init];
        _myHistory = [[NSMutableArray alloc] init];
        _otherOders = [[NSMutableArray alloc] init];
        _myFavourites = [[NSMutableArray alloc] init];

        _ordered = MO_INVALID_UINT;
    }
    
    return self;
}

#pragma mark static constructor
+(MODataController *)init
{
    MODataController* dataCtrl = [[MODataController alloc] init];

#if !(NETWORK_ACTIVE)
    [dataCtrl initData];
#endif
    return dataCtrl;
}

-(void)initData
{
    _userName = @"李志兴";
    _passWord = @"123456";

    [MODataOperation getRestaurants:_restaurants andMenus:_menuArray];
    
    //[self updateMyHistory];
    //[self updateOtherOrders];
    //[MODataOperation dumpAllMenuList: _menuArray];
    //[MODataOperation dumpAllRestaurants:_restaurants];
    return;
}
-(NSArray*)getRestaurants
{
    return [_restaurants allKeys];
}
-(NSArray*)getMenuList
{
    return _menuArray;
}
-(NSArray*)getMenuQuickIndexs
{
    return nil;
}
-(NSArray*)getMenuListByRestaurant:(NSString*)restaurant
{
    MOMenuGroup* group = [_restaurants objectForKey:restaurant];
    return [group entrys];
}
-(NSArray*)getMenuQuickIndexsByRestaurant:(NSString*)restaurant
{
    return nil;
}
-(BOOL)isOrdered
{
//#if (NETWORK_ACTIVE)
    return (_ordered != MO_INVALID_UINT);
//#else
//    return TRUE;
//#endif
}
-(unsigned)getOrdered
{
    return _ordered;
}
-(void)setOrdered:(unsigned)index
{
    _ordered = index;
}
-(void)clearOrdered
{
    _ordered = MO_INVALID_UINT;
}
-(NSMutableArray*)getMyFavourites
{
    return _myFavourites;
}
-(void)addMyFavourites:(MOMenuEntry*)entry
{
    [_myFavourites addObject: entry];
}


#pragma mark- http interface

-(BOOL)getLogin:(NSString *)name andPassWord:(NSString *)password viewController:(id)viewCtrl
{
    _userName = name;
    _passWord = password;
    _viewCtrl = viewCtrl;
    NSLog(@"userName: %@\npassWord: %@", _userName, _passWord);
    
    [MODataOperation login:name andPassword:password delegate: self];
    
    return TRUE;
}

-(BOOL)logout
{
    [MODataOperation logout:self];
    return TRUE;
}
-(BOOL)sendOrder:(unsigned)index viewController:(id)viewCtrl
{
    _viewCtrl = viewCtrl;
    [MODataOperation order: index delegate:self];
    return TRUE;

}
-(BOOL)sendOrder:(unsigned)index
{
    if(![MODataOperation order: index])
    {
        return FALSE;
    }
    
    _ordered = index;
    return TRUE;

}
-(BOOL)cancelOrder:(unsigned)index viewController:(id)viewCtrl
{
    _viewCtrl = viewCtrl;
    [MODataOperation cancel: index delegate:self];
    return TRUE;
}
-(BOOL)cancelOrder:(unsigned)index
{
    if([MODataOperation cancel: index])
    {
        return FALSE;
    }
    
    [self clearOrdered];
    return TRUE;
}

-(NSMutableArray*)getMyHistory
{   
    return _myHistory;
}
-(BOOL)updateMyHistory
{   
    if(![MODataOperation getMyHistory: _myHistory])
    {
        return FALSE;
    }
    
    return TRUE;
}
-(NSMutableArray*)getOtherOrders
{   
    return _otherOders;
}
-(BOOL)updateOtherOrders
{   
    if(![MODataOperation getOtherOrders: _otherOders])
    {
        return FALSE;
    }
    
    return TRUE;
}
-(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index
{
    return [MODataOperation getComments:array byIndex:index];
}
-(BOOL)sendComment:(NSString*)content to:(unsigned)index
{
    [MODataOperation comment: content to: index];
    return TRUE;
}




-(void)backToMain:(id)ctrl
{
    [ctrl backToMain];
}

#pragma mark- NSURLConnectionDataDelegate代理方法

//当接收到服务器的响应（连通了服务器）时会调用
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到服务器的响应");
    [MODataOperation dumpHttpResponse:response];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
    assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
    
    if ((httpResponse.statusCode / 100) != 2)
    {
        MO_SHOW_HIDE;
        MO_SHOW_FAIL(@"服务器响应失败...");
    }
    
    if(!_responseData) _responseData = [NSMutableData data];
    NSLog(@"NSURLResponse : %@", response);
}

//当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"接收到服务器的数据...");
    
    
    [_responseData appendData:data];
    NSLog(@"%lu---%@--",_responseData.length,[NSThread currentThread]);
}

//当服务器的数据加载完毕时就会调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"服务器的数据加载完毕");
    
    NSString* body = [[NSString alloc] initWithData:_responseData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body:\n%@", body);
    
    NSString* url = [[[connection originalRequest] URL] absoluteString];
    if([MODataOperation isLoginRequest: url])
    {
        if([MODataOperation isLoginPage: body])
        {
            NSLog(@"login failed");
            MO_SHOW_HIDE;
            MO_SHOW_FAIL(@"账号或密码错误");
        }else
        {
            [self initData];
            MO_BACK_TO_MAIN_THREAD(_viewCtrl);
        }
    }else if([MODataOperation isOrderRequest: url])
    {
        if(![MODataOperation isSentOrderSuccessfully: body])
        {
            NSLog(@"order failed");//failed cause
            MO_SHOW_HIDE;
            MO_SHOW_FAIL(@"订餐失败");
            [self clearOrdered];

            MO_BACK_TO_MAIN_THREAD(_viewCtrl);//reload tableview
        }else
        {
            MO_SHOW_HIDE;
            MO_SHOW_SUCC(@"订餐成功");
        }
    }else if([MODataOperation isCancleOrderRequest: url])
    {
        if(![MODataOperation isCancelOrderSuccessfully: body])
        {
            NSLog(@"cancel order failed");//failed cause
            MO_SHOW_HIDE;
            MO_SHOW_FAIL(@"取消订餐失败");
            MO_BACK_TO_MAIN_THREAD(_viewCtrl);
        }else
        {
            [self clearOrdered];
            MO_SHOW_HIDE;
            MO_SHOW_SUCC(@"取消订餐成功");
        }
    }else if([MODataOperation isMyHistoryRequest: url])
    {
        
    }
    else if([MODataOperation isOtherOrdersRequest: url])
    {
        
    }
    else if([MODataOperation isGetCommentsRequest: url])
    {
        
    }
    else if([MODataOperation isSendCommentsRequest: url])
    {
        
    }
    else if([MODataOperation isLogoutRequest: url])
    {
        
    }
    else if([MODataOperation isPasswordRequest: url])
    {
        
    }
    else if([MODataOperation isMoneyRequest: url])
    {
    }

    
    //clear buffer
    [_responseData setLength:0];
}

//请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求错误...");
    
    NSString* url = [[[connection originalRequest] URL] absoluteString];
    if([MODataOperation isOrderRequest: url])
    {
        [self clearOrdered];
    }
    
    MO_SHOW_HIDE;
    MO_SHOW_FAIL(@"请求错误...");
    
#if !(NETWORK_ACTIVE)
    
    [self initData];
    MO_BACK_TO_MAIN_THREAD(_viewCtrl);
    //[self performSelectorOnMainThread:@selector(backToMain:) withObject:_viewCtrl waitUntilDone:NO];
#endif
    NSLog(@"connection :%@, Error:%@", connection, error);
}
@end




