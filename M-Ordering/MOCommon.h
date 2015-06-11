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
#define HTTP_URL_ORDER_RANDOM (@"http://10.2.2.188/Menu.asp?at=sj")
#else
#define HTTP_URL_REFERER (@"http://10.2.2.188/")
#define HTTP_URL_LOGIN (@"http://10.2.2.188/index.asp?at=chk")
#define HTTP_URL_LOGOUT (@"http://10.2.2.188/index.asp?at=exit")
#define HTTP_URL_RESTAURANT (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-restaurant_files/menu_002.htm")
#define HTTP_URL_MENU_LIST (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-quick_files/menu_002.htm")
#define HTTP_URL_MENU_NEXT (@"http://10.2.2.188/Menu.asp?at=list&page=%urid=&orders=0&txtitle=")
#define HTTP_URL_ORDER_HISTORY (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-record_files/menu_002.htm")
#define HTTP_URL_OTHER_ORDERS (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-others_files/menu_002.htm")
#define HTTP_URL_PASSWORD (@"http://10.2.2.188/menu.asp?at=editpsw")
#define HTTP_URL_MONEY (@"http://10.2.2.188/menu.asp?at=money")
#define HTTP_URL_ORDER (@"http://10.2.2.188/Menu.asp?at=eat&Fid=")
#define HTTP_URL_CANCEL (@"http://10.2.2.188/Menu.asp?at=rmdd&ddid=")
#define HTTP_URL_COMMENT (@"http://10.2.2.188/Menu.asp?at=addpl") //send comment
#define HTTP_URL_COMMENTS (@"file:///Users/Robben/Downloads/SampleAPP/httpss/%E5%91%98%E5%B7%A5%E7%82%B9%E9%A4%90%E7%B3%BB%E7%BB%9F-coments_files/menu_002.htm")//get comments
#define HTTP_URL_ORDER_RANDOM (@"http://10.2.2.188/Menu.asp?at=sj")
#endif


#define MO_SHOW_INFO(msg) [MBProgressHUD showMessage:(msg)]
#define MO_SHOW_SUCC(msg) [MBProgressHUD showSuccess:(msg)]
#define MO_SHOW_FAIL(msg) [MBProgressHUD showError:(msg)]
#define MO_SHOW_HIDE      [MBProgressHUD hideHUD]

//#define MO_LOG(format, args...) NSLog(@"[%s - %s : %d]"format@"\n", __FILE__, __FUNCTION__,__LINE__, ##args)
#define MO_LOG(format, args...) NSLog(@"[%s : %d]"format@"\n", __FUNCTION__,__LINE__, ##args)


#define MO_INVALID_UINT (0xFFFFFFFF)

#define MO_SHOW_POINT(str, point)\
            MO_LOG(@"%@ point:(%lf,%lf)", str, point.x, point.y)

#define MO_SHOW_SIZE(str, size)\
            MO_LOG(@"%@ size:(%lf,%lf)", str, size.width, size.height)

#define MO_SHOW_RECT(str, rect)\
            MO_LOG(@"%@ Rect:(%lf,%lf)(%lf,%lf)", str, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#define MO_SHOW_EDGEINSET(str, inset)\
            MO_LOG(@"%@ EdgeInset:(%lf,%lf)(%lf,%lf)", str, inset.left, inset.right, inset.top, inset.bottom)


#define MO_COLOR_RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
        [UIColor colorWithRed:(R)/255.f green:(G)/255.f blue:(B)/255.f alpha:(A)]

#define MO_COLOR_HEX(hex) \
        [UIColor colorWithHexString:(hex)]




#endif
