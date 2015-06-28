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
    NSString*              _userName;
    NSString*              _passWord;
    
    NSMutableDictionary*   _restaurants;
    NSMutableArray*        _menuArray;
    
    NSMutableArray*        _myHistory;
    NSMutableArray*        _otherOders;
    NSMutableArray*        _myFavourites;
    NSMutableData*         _responseData; //?

    unsigned               _ordered;
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
    MODataController* dataCtrl = nil;
    if([MODataOperation isFileExist: MO_DATA_FILE])
    {
        MO_LOG(@"data file exist...");
        dataCtrl = (MODataController*)[MODataOperation readFile:MO_DATA_FILE];
    }else
    {
        MO_LOG(@"data file not exist...");
        dataCtrl = [[MODataController alloc] init];

#if !(NETWORK_ACTIVE)
        [dataCtrl initData];
        //[MODataOperation writeFile: dataCtrl];
#endif
    }
    
    return dataCtrl;
}

-(void)initData
{
    _userName = @"李志兴";
    _passWord = @"123456";

    [MODataOperation getRestaurants:_restaurants andMenus:_menuArray];
    
    NSMutableArray* tmp = [NSMutableArray array];
    [self getComments:tmp byIndex:0];
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
-(MOMenuEntry*)getOrderedMenuEntry
{
    for(MOMenuEntry* entry in _menuArray)
    {
        if(entry.index == _ordered)
        {
            return entry;
        }
    }
    return nil;
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
-(MOMenuEntry*)getMenuEntrybyName:(NSString*)name
{
    for(MOMenuEntry* entry in _menuArray)
    {
        if([entry.entryName isEqualToString:name])
        {
            return entry;
        }
    }
    
    return nil;
}


#pragma mark- http interface
-(NSString*)getLogin:(NSString *)name andPassWord:(NSString *)password
{
    NSString* result = [MODataOperation login:name andPassword:password];
    if(!result) 
    {
        _userName = name;
        _passWord = password;
        [self initData];
    }
    return result;
}
-(BOOL)logout
{
    [MODataOperation logout];
    return TRUE;
}
-(NSString*)sendOrder:(unsigned)index
{
    NSString* result = [MODataOperation order: index];
    if(!result)
    {
        _ordered = index;
    }
    
    return result;
}
/*-(BOOL)cancelOrder:(unsigned)index
{
    if([MODataOperation cancel: index])
    {
        return FALSE;
    }
    
    [self clearOrdered];
    return TRUE;
}*/
-(NSString*)cancelOrder:(unsigned)index
{
    NSString* result = [MODataOperation cancel: index];

    if(!result)
    {
        [self clearOrdered];
    }
    return result;
}
-(NSMutableArray*)getMyHistory
{   
    return _myHistory;
}
-(BOOL)updateMyHistory
{
    [_myHistory removeAllObjects];

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
    [_otherOders removeAllObjects];
    
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
-(BOOL)sendComment:(MOCommentEntry*)content
{
    [MODataOperation comment: content];
    return TRUE;
}

#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userName      forKey:@"userName"];
    [aCoder encodeObject:_passWord      forKey:@"passWord"];
    [aCoder encodeObject:_restaurants   forKey:@"restaurants"];
    [aCoder encodeObject:_menuArray     forKey:@"menuArray"];
    [aCoder encodeObject:_myHistory     forKey:@"myHistory"];
    [aCoder encodeObject:_otherOders    forKey:@"otherOders"];
    [aCoder encodeObject:_myFavourites  forKey:@"myFavourites"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _userName          = [aDecoder decodeObjectForKey:@"userName"];
        _passWord          = [aDecoder decodeObjectForKey:@"passWord"];
        _restaurants       = [aDecoder decodeObjectForKey:@"restaurants"];
        _menuArray         = [aDecoder decodeObjectForKey:@"menuArray"];
        _myHistory         = [aDecoder decodeObjectForKey:@"myHistory"];
        _otherOders        = [aDecoder decodeObjectForKey:@"otherOders"];
        _myFavourites      = [aDecoder decodeObjectForKey:@"myFavourites"];
    }
    
    return self;
}


@end




