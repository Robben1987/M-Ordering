//
//  MOCommon.h
//  M-Ordering
//
//  Created by Li Robben on 15-4-21.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#ifndef M_Ordering_MOCommon_h
#define M_Ordering_MOCommon_h
#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"

#define NETWORK_ACTIVE (0)

#if NETWORK_ACTIVE
#define HTTP_URL_REFERER (@"http://10.2.2.188/")
#define HTTP_URL_LOGIN (@"http://10.2.2.188/index.asp?at=chk")
#define HTTP_URL_LOGOUT (@"http://10.2.2.188/index.asp?at=exit")
#define HTTP_URL_RESTAURANT (@"http://10.2.2.188/Menu.asp?at=classs")
#define HTTP_URL_MENU_LIST (@"http://10.2.2.188/Menu.asp?at=list")
#define HTTP_URL_MENU_NEXT (@"http://10.2.2.188/Menu.asp?at=list&page=%urid=&orders=0&txtitle=")
#define HTTP_URL_ORDER_HISTORY (@"http://10.2.2.188/Menu.asp?at=ylog")
#define HTTP_URL_OTHER_ORDERS (@"http://10.2.2.188/Menu.asp?at=otherslog")
#define HTTP_URL_PASSWORD (@"http://10.2.2.188/menu.asp?at=editpsw")
#define HTTP_URL_MONEY (@"http://10.2.2.188/menu.asp?at=money")
#define HTTP_URL_ORDER (@"http://10.2.2.188/Menu.asp?at=eat&Fid=%d")
#define HTTP_URL_CANCEL (@"http://10.2.2.188/Menu.asp?at=rmdd&ddid=%d")
#define HTTP_URL_COMMENT (@"http://10.2.2.188/Menu.asp?at=addpl") //send comment
#define HTTP_URL_COMMENTS (@"http://10.2.2.188/Menu.asp?at=pl&Fid=")//get comments
#else
#define HTTP_URL_REFERER (@"http://10.2.2.188/")
#define HTTP_URL_LOGIN (@"http://10.2.2.188/index.asp?at=chk")
#define HTTP_URL_LOGOUT (@"http://10.2.2.188/index.asp?at=exit")
#define HTTP_URL_RESTAURANT (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-restaurant_files/menu_002.htm")
#define HTTP_URL_MENU_LIST (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-quick_files/menu_002.htm")
#define HTTP_URL_MENU_NEXT (@"http://10.2.2.188/Menu.asp?at=list&page=%urid=&orders=0&txtitle=")
#define HTTP_URL_ORDER_HISTORY (@"http://10.2.2.188/Menu.asp?at=ylog")
#define HTTP_URL_OTHER_ORDERS (@"http://10.2.2.188/Menu.asp?at=otherslog")
#define HTTP_URL_PASSWORD (@"http://10.2.2.188/menu.asp?at=editpsw")
#define HTTP_URL_MONEY (@"http://10.2.2.188/menu.asp?at=money")
#define HTTP_URL_ORDER (@"http://10.2.2.188/Menu.asp?at=eat&Fid=")
#define HTTP_URL_CANCEL (@"http://10.2.2.188/Menu.asp?at=rmdd&ddid=")
#define HTTP_URL_COMMENT (@"http://10.2.2.188/Menu.asp?at=addpl") //send comment
#define HTTP_URL_COMMENTS (@"http://10.2.2.188/Menu.asp?at=pl&Fid=")//get comments
#endif


#define MO_SHOW_INFO(msg) [MBProgressHUD showMessage:msg]
#define MO_SHOW_SUCC(msg) [MBProgressHUD showSuccess:msg]
#define MO_SHOW_FAIL(msg) [MBProgressHUD showError:msg]
#define MO_SHOW_HIDE      [MBProgressHUD hideHUD]

//#define MO_LOG(format, args) NSLog(<#NSString *format, ...#>)


#define MO_INVALID_UINT (0xFFFFFFFF)


#endif
