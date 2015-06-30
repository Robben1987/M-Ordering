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


#define MO_DATA_FILE(name) [NSString stringWithFormat:@"%@.data", name]

@interface MODataController ()
{
    NSString*              _userName;
    NSString*              _password;    
}
@end


@implementation MODataController

#pragma mark static constructor
+(MODataController *)init
{
    MODataController* dataCtrl = [[MODataController alloc] init];
    return dataCtrl;
}

#pragma mark constructor
-(MODataController*)init
{
    if((self = [super init]))
    {
        self.ordered = MO_INVALID_UINT;
    }
    
    return self;
}

#pragma mark data handle

-(void)loadData
{
#if !(NETWORK_ACTIVE)
    _userName = @"李志兴";
    _password = @"123456";
#endif
    
    NSString* file = MO_DATA_FILE(_userName);
    if([MODataOperation isFileExist: file])
    {
        MO_LOG(@"data file exist...");
        MODataController* dataCtrl = (MODataController*)[MODataOperation readFile:file];
        
        self.menuArray = [NSMutableArray arrayWithArray:dataCtrl.menuArray];
        self.restaurants = [NSMutableDictionary dictionaryWithDictionary:dataCtrl.restaurants];
        self.myHistory = [NSMutableArray arrayWithArray:dataCtrl.myHistory];
        self.otherOders = [NSMutableArray arrayWithArray:dataCtrl.otherOders];
        self.myFavourites = [NSMutableArray arrayWithArray:dataCtrl.myFavourites];
        
    }else
    {
        self.menuArray = [NSMutableArray array];
        self.restaurants = [NSMutableDictionary dictionary];
        
        [MODataOperation getRestaurants:self.restaurants andMenus:self.menuArray];
    }
    
    
}
-(void)saveData
{
    [MODataOperation writeObj:self toFile: MO_DATA_FILE(_userName)];
}

-(NSArray*)getRestaurants
{
    return [self.restaurants allKeys];
}

-(NSArray*)getMenuQuickIndexs
{
    return nil;
}
-(NSArray*)getMenuListByRestaurant:(NSString*)restaurant
{
    MOMenuGroup* group = [self.restaurants objectForKey:restaurant];
    return [group entrys];
}
-(NSArray*)getMenuQuickIndexsByRestaurant:(NSString*)restaurant
{
    return nil;
}
-(BOOL)isOrdered
{
    return (self.ordered != MO_INVALID_UINT);
}
-(void)clearOrdered
{
    self.ordered = MO_INVALID_UINT;
}

-(MOMenuEntry*)getOrderedMenuEntry
{
    for(MOMenuEntry* entry in self.menuArray)
    {
        if(entry.index == self.ordered)
        {
            return entry;
        }
    }
    return nil;
}

-(MOMenuEntry*)getMenuEntrybyName:(NSString*)name
{
    for(MOMenuEntry* entry in self.menuArray)
    {
        if([entry.entryName isEqualToString:name])
        {
            return entry;
        }
    }
    
    return nil;
}

-(void)addMyFavourites:(MOMenuEntry*)entry
{
    if(!self.myFavourites) self.myFavourites = [[NSMutableArray alloc] init];
    [self.myFavourites addObject: entry];
}



#pragma mark- http interface
-(NSString*)getLogin:(NSString *)name andPassWord:(NSString *)password
{
    NSString* result = [MODataOperation login:name andPassword:password];
#if !(NETWORK_ACTIVE)
    result = nil;
#endif
    if(!result)
    {
        _userName = name;
        _password = password;
        [self loadData];
    }

    return result;
}
-(BOOL)logout
{
    return [MODataOperation logout];
}
-(NSString*)sendOrder:(unsigned)index
{
    NSString* result = [MODataOperation order: index];
    if(!result)
    {
        self.ordered = index;
    }
    
    return result;
}
-(NSString*)cancelOrder:(unsigned)index
{
    NSString* result = [MODataOperation cancel: index];

    if(!result)
    {
        [self clearOrdered];
    }
    return result;
}

-(BOOL)updateMyHistory
{
    if(!self.myHistory)
    {
        self.myHistory = [NSMutableArray array];
    }else
    {
        [self.myHistory removeAllObjects];
    }

    if(![MODataOperation getMyHistory: self.myHistory])
    {
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL)updateOtherOrders
{
    if(!self.otherOders)
    {
        self.otherOders = [NSMutableArray array];
    }else
    {
        [self.otherOders removeAllObjects];
    }
        
    if(![MODataOperation getOtherOrders: self.otherOders])
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
    return [MODataOperation comment: content];
}



#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userName          forKey:@"userName"];
    [aCoder encodeObject:_password          forKey:@"passWord"];
    [aCoder encodeObject:self.restaurants   forKey:@"restaurants"];
    [aCoder encodeObject:self.menuArray     forKey:@"menuArray"];
    [aCoder encodeObject:self.myHistory     forKey:@"myHistory"];
    [aCoder encodeObject:self.otherOders    forKey:@"otherOders"];
    [aCoder encodeObject:self.myFavourites  forKey:@"myFavourites"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _userName              = [aDecoder decodeObjectForKey:@"userName"];
        _password              = [aDecoder decodeObjectForKey:@"passWord"];
        self.restaurants       = [aDecoder decodeObjectForKey:@"restaurants"];
        self.menuArray         = [aDecoder decodeObjectForKey:@"menuArray"];
        self.myHistory         = [aDecoder decodeObjectForKey:@"myHistory"];
        self.otherOders        = [aDecoder decodeObjectForKey:@"otherOders"];
        self.myFavourites      = [aDecoder decodeObjectForKey:@"myFavourites"];
    }
    
    return self;
}


@end




