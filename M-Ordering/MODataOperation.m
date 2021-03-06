//
//  MODataOperation.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-31.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MODataOperation.h"
#import "hpple/TFHpple.h"
#import "MOMenuGroup.h"
#import "MOOrderEntry.h"
#import "MOCommon.h"


@interface MODataOperation ()
{
}
@end

@implementation MODataOperation

+(BOOL)isLoginPage:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"登录");
}
+(BOOL)isMenuListPage:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"菜单列表");
}
+(BOOL)isMyOrderHistoryPage:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"你的点餐记录");
}
+(BOOL)isOtherOrdersPage:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"别人的点餐记录");
}
+(BOOL)isCommentsPage:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"用户评价");
}
+(BOOL)isSentOrderSuccessfully:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"订单已下好");
}
+(BOOL)isCancelOrderSuccessfully:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"删除成功");
}
+(BOOL)isSendCommentSuccessfully:(NSString*)htmlString
{
    return CONTAIN_SUBSTRING(htmlString, @"添加评论成功");
}


+(BOOL)isLoginRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_LOGIN];
}
+(BOOL)isLogoutRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_LOGOUT];
}
+(BOOL)isOrderRequest:(NSString*)url
{
    return CONTAIN_SUBSTRING(url, @"eat");
}
+(BOOL)isCancleOrderRequest:(NSString*)url
{
    return CONTAIN_SUBSTRING(url, @"rmdd");
}
+(BOOL)isSendCommentsRequest:(NSString*)url
{
    return CONTAIN_SUBSTRING(url, HTTP_URL_COMMENT);
}
+(BOOL)isGetCommentsRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_COMMENTS];
}
+(BOOL)isMyHistoryRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_ORDER_HISTORY];
}
+(BOOL)isOtherOrdersRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_OTHER_ORDERS];
}
+(BOOL)isMoneyRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_MONEY];
}
+(BOOL)isPasswordRequest:(NSString*)url
{
    return [url isEqualToString:HTTP_URL_PASSWORD];
}

#pragma mark- html method
/*
 <tr>
 <td height="30" colspan="6">
 <p align="right"><font color="#000080">首页 上一页</font>&nbsp;
 <a href="Menu.asp?at=list&amp;page=2&amp;rid=18&amp;orders=98&amp;txtitle=">下一页</a> 
 <a href="Menu.asp?at=list&amp;page=2&amp;rid=18&amp;orders=98&amp;txtitle=">尾页</a>
 <font color="#000080">&nbsp;页次：</font>
     <strong>
         <font color="red">1</font>
         <font color="#000080">/2</font>
     </strong><font color="#000080">页</font> 
 <font color="#000080">&nbsp;共<b>38</b>条记录 <b>30</b>条记录/页</font>
 </p>
 </td>
 </tr>
 */
+(NSString*)getMenuList:(NSMutableArray*)array fromHtml:(NSString*)htmlString
{
    NSMutableString* urlString = nil;
    
    NSRange rangStart=[htmlString rangeOfString:@"<table class=\"en\""];
    NSMutableString *tableStart=[[NSMutableString alloc]initWithString:[htmlString substringFromIndex:rangStart.location]];
    
    NSRange rangEnd=[tableStart rangeOfString:@"</table>"];
    NSMutableString *tableString=[[NSMutableString alloc]initWithString:[tableStart substringToIndex:(rangEnd.location + rangEnd.length)]];
    
#if NETWORK_ACTIVE
    NSData *htmlData=[tableString dataUsingEncoding: NSUTF8StringEncoding];
#else
    NSData *htmlData=[tableString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
#endif
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//tr"];
    
    //Parser the menu list
    for(unsigned i = 3; i < (elements.count-1); i++)
    {
        NSArray* children =[elements[i] children];
        MOMenuEntry* entry = [MOMenuEntry initWithName:[children[1] content] andIndex:[[children[0] content] intValue]];
        [entry setPrice:[[children[2] content] floatValue]];
        [entry setChosedTimes:[[children[3] content] intValue]];
        [entry setRestaurant:[[children[4] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [entry setCommentNumber:[[children[5] content] intValue]];
        //[entry dumpEntry];
        [array addObject:entry];
    }
    
    //get next page
    NSArray* tds = [elements[elements.count-1] children];
    NSArray* ps  = [tds[0] children];
    NSArray* children =[ps[0] children];
    
    for(unsigned j = 1; j < children.count; j++)
    {
        if([[children[j] content] isEqualToString: @"下一页"])
        {
            NSString* href = [children[j] objectForKey:@"href"];
            NSLog(@"next url:%@", [children[j] objectForKey:@"href"]);
            urlString = [NSMutableString stringWithString:HTTP_URL_REFERER];
            [urlString appendString: href];
        }
    }
    
    return urlString;
}
+(void)getRestaurants:(NSMutableDictionary*)dic fromHtml:(NSString*)htmlString
{
    //NSData *htmlData=[htmlString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//a"];
    //NSLog(@"elements: count:%lu",elements.count);
    
    //Parser the Restaurants list
    for(unsigned i = 0; i < (elements.count); i+=2)
    {
        MOMenuGroup* entry = [MOMenuGroup initWithName:[elements[i] content] andDetail:[elements[i+1] content] andEntrys:[[NSMutableArray alloc] init]];
        
        [entry setHref:[elements[i] objectForKey:@"href"]];
        [entry setTel:[[elements[i] objectForKey:@"title"] substringFromIndex:5]];
        
        [dic setObject:entry forKey:[entry groupName]];
    }
    return;
}
+(void)getOtherOrders:(NSMutableArray*)array fromHtml:(NSString*)htmlString
{
    //static unsigned pageNum = 0;
    NSLog(@"htmlString: %@\n", htmlString);

    NSRange rangStart=[htmlString rangeOfString:@"<table class=\"en\""];
    NSMutableString *tableStart=[[NSMutableString alloc]initWithString:[htmlString substringFromIndex:rangStart.location]];
    
    NSRange rangEnd=[tableStart rangeOfString:@"</table>"];
    NSMutableString *tableString=[[NSMutableString alloc]initWithString:[tableStart substringToIndex:(rangEnd.location + rangEnd.length)]];
    
    //NSData *htmlData=[tableString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSData *htmlData=[tableString dataUsingEncoding: NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//tr"];
    
    //Parser the menu list
    for(unsigned i = 2; i < (elements.count-1); i++)
    {
        NSArray* children =[elements[i] children];
        NSArray* grandChildren =[children[0] children];
        
        MOMenuEntry* menuEntry = [[MOMenuEntry alloc] init];
        [menuEntry setRestaurant: [grandChildren[1] content]];
        [menuEntry setEntryName: [grandChildren[2] content]];
        
        MOOrderEntry* orderEntry = [[MOOrderEntry alloc] init];
        [orderEntry setPerson: [grandChildren[0] content]];
        [orderEntry setUrl: [[children[1] children][0] objectForKey:@"href"]];
        [orderEntry setDate: [[[children[0] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\r\n-" withString:@" "]];
        [orderEntry setMenuEntry: menuEntry];
        [orderEntry dumpEntry];
        
        [array addObject:orderEntry];
    }
    
    /*if(!pageNum)
    {
        NSArray* nexts  = [xpathParser searchWithXPathQuery:@"//strong"];
        NSArray* children = [nexts[0] children];
        NSString* page = [[children[children.count - 1] content] substringFromIndex:1];
        pageNum = [page intValue];
    }
    
    return pageNum;*/
}
+(void)getMyHistory:(NSMutableArray*)array fromHtml:(NSString*)htmlString
{
    //static unsigned pageNum = 0;
    
    NSLog(@"htmlString: %@\n", htmlString);
    NSRange rangStart=[htmlString rangeOfString:@"<table class=\"en\""];
    NSMutableString *tableStart=[[NSMutableString alloc]initWithString:[htmlString substringFromIndex:rangStart.location]];
    
    NSRange rangEnd=[tableStart rangeOfString:@"</table>"];
    NSMutableString *tableString=[[NSMutableString alloc]initWithString:[tableStart substringToIndex:(rangEnd.location + rangEnd.length)]];
    
    //NSData *htmlData=[tableString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSData *htmlData=[tableString dataUsingEncoding: NSUTF8StringEncoding];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//tr"];
    
    //Parser the menu list
    for(unsigned i = 2; i < (elements.count-1); i++)
    {
        NSArray* children =[elements[i] children];
                
        MOMenuEntry* menuEntry = [[MOMenuEntry alloc] init];
        [menuEntry setEntryName: [[children[1] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [menuEntry setPrice: [[children[2] content] floatValue]];
        [menuEntry setRestaurant: [[children[3] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        MOOrderEntry* orderEntry = [[MOOrderEntry alloc] init];
        [orderEntry setPerson:@"我"];
        [orderEntry setOrderId:[[children[0] content] intValue]];
        [orderEntry setUrl:[[children[5] children][0] objectForKey:@"href"]];
        [orderEntry setDate: [children[4] content]];
        [orderEntry setMenuEntry: menuEntry];
        [orderEntry dumpEntry];
        
        [array addObject:orderEntry];
    }
    
    /*if(!pageNum)
    {
        NSArray* nexts  = [xpathParser searchWithXPathQuery:@"//strong"];
        NSArray* children = [nexts[0] children];
        NSString* page = [[children[children.count - 1] content] substringFromIndex:1];
        pageNum = [page intValue];
    }
    
    return pageNum;*/
}
+(void)getComments:(NSMutableArray*)array fromHtml:(NSString*)htmlString
{
    //NSLog(@"htmlString: %@\n", htmlString);
    NSRange rangStart=[htmlString rangeOfString:@"</b>"];
    NSMutableString* tableStart=[[NSMutableString alloc]initWithString:[htmlString substringFromIndex:(rangStart.location + rangStart.length)]];
    //NSLog(@"------tableStart: %@\n", tableStart);

    
    NSRange rangEnd=[tableStart rangeOfString:@"<form method"];
    NSMutableString *tableString=[[NSMutableString alloc]initWithString:[tableStart substringToIndex:(rangEnd.location)]];
    
    //NSLog(@"------tableString: %@\n", tableString);
    NSArray* tmpArray = [tableString componentsSeparatedByString:@"<br>"];
    for(NSString* entry in tmpArray)
    {
        [entry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [entry stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([entry length] && !CONTAIN_SUBSTRING(entry, @"相关评论")
           && !CONTAIN_SUBSTRING(entry, @"\r\n"))
        {
            [array addObject:entry];
        }
    }
    return;
}


#pragma mark- http method
+(NSString*)login:(NSString*)userName andPassword:(NSString*)passWord
{
   // get the url
    NSURL* url = [NSURL URLWithString:HTTP_URL_LOGIN];
    
    // get the url requrst
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq setHTTPMethod:@"POST"];
    [httpReq addValue:HTTP_URL_REFERER forHTTPHeaderField:@"Referer"];
    
    // set http body
    NSString* body = [NSString stringWithFormat:@"username=%@&password=%@",
                      userName, passWord];
    [httpReq setHTTPBody:[body dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    
    [MODataOperation dumpHttpRequest:httpReq];
    
    // send http request
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* recv = [NSURLConnection sendSynchronousRequest:httpReq returningResponse:&response error:&error];
    if(error)
    {
        NSLog(@"send http Request failed: %@", error);
        return @"请求失败";
    }
    
    [MODataOperation dumpHttpResponse:response];
    
    if([(NSHTTPURLResponse *)response statusCode] / 100 != 2)
    {
        NSLog(@"server response error:%u", (unsigned)[(NSHTTPURLResponse *)response statusCode]);
        return @"服务器响应错误";
    }
    
    NSString* html = [[NSString alloc] initWithData:recv encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body:\n%@", html);
    
    if([MODataOperation isLoginPage: html])
    {
        NSLog(@"login failed");
        return @"账号或密码错误";
    }
    
    
    NSLog(@"login succ....");
    return nil;
}
+(BOOL)logout
{
    // get the url
    NSURL* url = [NSURL URLWithString:HTTP_URL_LOGOUT];
    
    // get the url requrst
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq addValue:HTTP_URL_REFERER forHTTPHeaderField:@"Referer"];
    
    // send http request
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* recv = [NSURLConnection sendSynchronousRequest:httpReq returningResponse:&response error:&error];
    if(error)
    {
        NSLog(@"send http Request failed: %@", error);
        return FALSE;
    }
    
    [MODataOperation dumpHttpResponse:response];
    
    if([(NSHTTPURLResponse *)response statusCode] / 100 != 2)
    {
        NSLog(@"server response error:%u", (unsigned)[(NSHTTPURLResponse *)response statusCode]);
        return FALSE;
    }
    
    NSString* html = [[NSString alloc] initWithData:recv encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body:\n%@", html);
    
    if(![MODataOperation isLoginPage: html])
    {
        NSLog(@"logout failed");
        return FALSE;
    }
    
    NSLog(@"logout succ");
    return TRUE;
}
+(BOOL)getRestaurants:(NSMutableDictionary*)restaurants andMenus:(NSMutableArray*)menus
{
#if NETWORK_ACTIVE
    
    //get restaurants
    NSString* htmlBody = [MODataOperation sendHttpRequestSync:HTTP_URL_RESTAURANT];
    if(!htmlBody)
    {
        NSLog(@"get url(%@) failed", HTTP_URL_RESTAURANT);
        return FALSE;
    }
    [MODataOperation getRestaurants:restaurants fromHtml:htmlBody];
    
    // get menu list
    NSString* url = HTTP_URL_MENU_LIST;
    do
    {
        htmlBody = [MODataOperation sendHttpRequestSync: url];
        if(!htmlBody)
        {
            NSLog(@"get url(%@) failed", url);
            return FALSE;
        }
        
        url = [MODataOperation getMenuList:menus fromHtml:htmlBody];
    } while (url);
    
#else
    NSString* html = [MODataOperation getHtmlfromUrl:HTTP_URL_RESTAURANT];
    [MODataOperation getRestaurants:restaurants fromHtml:html];
    
    
    html = [MODataOperation getHtmlfromUrl: HTTP_URL_MENU_LIST];
    unsigned num = [MODataOperation getMenuList:menus fromHtml:html];
    NSLog(@"page num: %u", num);
    
#endif
    
    for (MOMenuEntry* entry in menus)
    {
        MOMenuGroup* group = [restaurants objectForKey:[entry restaurant]];
        [[group entrys] addObject:entry];
    }
    
    return TRUE;
}
+(NSString*)order:(unsigned)index
{
    NSString* url = [NSString stringWithFormat:HTTP_URL_ORDER];
    NSString* html = [self sendHttpRequestSync: [url stringByAppendingFormat: @"%d", index]];
    if(!html)
    {
        return @"网络错误!";
    }

    if(![self isSentOrderSuccessfully: html])
    {
        return @"预定失败!";
    }

    NSLog(@"order succ");
    return nil;
}
+(NSString*)cancel:(unsigned)index
{
    NSString* url = [NSString stringWithFormat:HTTP_URL_CANCEL];
    NSString* html = [self sendHttpRequestSync: [url stringByAppendingFormat: @"%d", index]];
    if(!html)
    {
        return @"网络错误!";;
    }

    if(![self isCancelOrderSuccessfully: html])
    {
        return @"取消失败!";;
    }

    NSLog(@"order cancel succ");
    return nil;
}
+(BOOL)getMyHistory:(NSMutableArray*)array
{
#if NETWORK_ACTIVE
    NSString* html = [self sendHttpRequestSync: HTTP_URL_ORDER_HISTORY];
    if(!html)
    {
        NSLog(@"get my history failed");
        return FALSE;
    }

    if(![self isMyOrderHistoryPage: html])
    {
        NSLog(@"get my history failed: %@", html);//failed cause
        return FALSE;
    }
#else
    NSString* html = [MODataOperation getHtmlfromUrl:HTTP_URL_ORDER_HISTORY];
#endif
    [MODataOperation getMyHistory:array fromHtml:html];
    
    NSLog(@"get my history succ");
    return TRUE;
}
+(BOOL)getOtherOrders:(NSMutableArray*)array
{
#if NETWORK_ACTIVE
    NSString* html = [self sendHttpRequestSync: HTTP_URL_OTHER_ORDERS];
    if(!html)
    {
        NSLog(@"get other orders failed");
        return FALSE;
    }

    if(![self isOtherOrdersPage: html])
    {
        NSLog(@"get other orders failed");//failed cause
        return FALSE;
    }
#else
     NSString* html = [MODataOperation getHtmlfromUrl:HTTP_URL_OTHER_ORDERS];
#endif
    
    [MODataOperation getOtherOrders:array fromHtml:html];
    NSLog(@"get other orders succ");
    return TRUE;
}
+(BOOL)comment:(MOCommentEntry*)entry
{
    // get the url
    NSURL* url = [NSURL URLWithString:HTTP_URL_COMMENT];
    
    // get the url requrst
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq setHTTPMethod:@"POST"];
    NSString* referer = HTTP_URL_COMMENTS;
    [httpReq addValue:[referer stringByAppendingFormat: @"%d", entry.index] forHTTPHeaderField:@"Referer"];
    
    // set http body
    NSString* body = [NSString stringWithFormat:@"addpl_con=%@&addpl_Lev=%d&addpl_FID=%d",
                      entry.content, entry.level, entry.index];
    [httpReq setHTTPBody:[body dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    
    [MODataOperation dumpHttpRequest:httpReq];
    
    // send http request
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* recv = [NSURLConnection sendSynchronousRequest:httpReq returningResponse:&response error:&error];
    if(error)
    {
        NSLog(@"send http Request failed: %@", error);
        return FALSE;
    }
    
    [MODataOperation dumpHttpResponse:response];
    
    if([(NSHTTPURLResponse *)response statusCode] / 100 != 2)
    {
        NSLog(@"server response error:%u", (unsigned)[(NSHTTPURLResponse *)response statusCode]);
        return FALSE;
    }
    
    NSString* html = [[NSString alloc] initWithData:recv encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body:\n%@", html);
    
    if(![MODataOperation isSendCommentSuccessfully: html])
    {
        NSLog(@"comment failed");
        return FALSE;
    }
    
    NSLog(@"comment succ");
    return TRUE;  
}
+(BOOL)getComments:(NSMutableArray*)array byIndex:(unsigned)index
{
#if NETWORK_ACTIVE
    NSString* url = HTTP_URL_COMMENTS;
    NSString* html = [self sendHttpRequestSync: [url stringByAppendingFormat: @"%d", index]];
    if(!html)
    {
        NSLog(@"get comments failed");
        return FALSE;
    }

    if(![self isCommentsPage: html])
    {
        NSLog(@"get comments failed: %@", html);//failed cause
        return FALSE;
    }
#else
    NSString* html = [MODataOperation getHtmlfromUrl:HTTP_URL_COMMENTS];
#endif
    
    [MODataOperation getComments:array fromHtml:html];
    
    NSLog(@"get comments succ");
    return TRUE;
}


+(NSString*)sendHttpRequestSync:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq addValue:HTTP_URL_REFERER forHTTPHeaderField:@"Referer"];
    
    // send http request
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* recv = [NSURLConnection sendSynchronousRequest:httpReq returningResponse:&response error:&error];
    if(error)
    {
        NSLog(@"send http Request failed: %@", error);
        return nil;
    }
    
    [MODataOperation dumpHttpResponse:response];
    
    if([(NSHTTPURLResponse *)response statusCode] / 100 != 2)
    {
        NSLog(@"server response error:%u", (unsigned)[(NSHTTPURLResponse *)response statusCode]);
        return nil;
    }
    
    NSString* html = [[NSString alloc] initWithData:recv encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"body:\n%@", html);
    
    return html;
    
}
+(void)sendHttpRequestNonSync:(NSString*)urlString delegate:(id)delegate
{
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq addValue:HTTP_URL_REFERER forHTTPHeaderField:@"Referer"];
    NSLog(@"NSURLRequest : %@", httpReq);
    
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:httpReq delegate:delegate];
    NSLog(@"NSURLConnection : %@", conn);
    
    [conn start];
    
    NSLog(@"已经发出请求---");
}
+(void)getHttpPageNonSync:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* httpReq = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    // set http head
    [httpReq addValue:HTTP_URL_REFERER forHTTPHeaderField:@"Referer"];
    
    NSURLConnection* conn=[NSURLConnection connectionWithRequest:httpReq delegate:self];
    
    [conn start];
}

+(NSString*)getHtmlfromUrl:(NSString*)urlString
{
    //NSLog(@"urlString:%@\n", urlString);
    NSError* error = nil;
    //NSString* htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    NSString* htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:&error];
    if(htmlString == nil)
    {
        NSLog(@"get url(%@) failed: %@", urlString, error);
        return nil;
    }
    //NSLog(@"str:%@\n", htmlString);
    
    return htmlString;
}

#pragma mark- File Management

+(BOOL)isFileExist:(NSString*)fileName
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSString* docPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* file = [docPath stringByAppendingPathComponent: fileName];
    
    MO_LOG(@"isFileExist:%@", file);

    return [fileMgr fileExistsAtPath:file];
}

+(id)readFile:(NSString*)fileName
{
    NSString *docPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* file=[docPath stringByAppendingPathComponent: fileName];
    
    MO_LOG(@"readFile:%@", file);
    return [NSKeyedUnarchiver unarchiveObjectWithFile: file];
}

+(BOOL)writeObj:(id)obj toFile:(NSString*)fileName
{
    //NSData* data = [NSKeyedArchiver archivedDataWithRootObject: self];
    
    NSString* docPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* file = [docPath stringByAppendingPathComponent: fileName];
    
    MO_LOG(@"writeFile:%@", file);

    return [NSKeyedArchiver archiveRootObject:obj toFile:file];
}

#pragma mark- dump method
+(void)dumpAllMenuList:(NSArray*)array
{
    for(MOMenuEntry* entry in array)
        [entry dumpEntry];
}
+(void)dumpAllRestaurants:(NSMutableDictionary*)dic
{
    for(NSString* key in dic)
    {
        MOMenuGroup* entry = [dic objectForKey:key];
        [entry dumpEntry];
    }
}
+(void)dumpHttpRequest:(NSURLRequest*)request
{
    NSLog(@"dump the http request:");
    NSLog(@"NSURLRequest : %@", request);
    NSLog(@"NSURLRequest headers : %@", [request allHTTPHeaderFields]);
    NSLog(@"NSURLRequest body : %@", [request HTTPBody]);
    
}
+(void)dumpHttpResponse:(NSURLResponse*)response
{
    NSLog(@"dump the http response:");
    NSLog(@"response status code:%u",(unsigned)[(NSHTTPURLResponse *)response statusCode]);
    NSLog(@"response expect length:%lld", [(NSHTTPURLResponse *)response expectedContentLength]);
    NSLog(@"response all headfield:%@",[(NSHTTPURLResponse *)response allHeaderFields]);
}
+(void)dumpHttpCookies
{
    NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [cookieJar cookies])
    {
        NSLog(@"cookie:%@", cookie);
    }
}



@end
