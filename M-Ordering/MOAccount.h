//
//  MOAccount.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MO_GET_GROUP_ROW_ID(group, row) (((group) << 16) | (row))
#define MO_GET_GROUP_INDEX(index) ((index) >> 16)
#define MO_GET_ROW_INDEX(index)   ((index) & 0x0000FFFF)

typedef enum
{
    //group-1
    MOAccountImage    = 0x00000000,
    
    //group-2
    MOAccountUserName = 0x00010000,
    MOAccountPhone,
    MOAccountSkype,
    MOAccountEmail,
    
    //group-3
    MOAccountSection  = 0x00020000,
    
    //end
    MOAccountEnd      = 0xffffffff
}MOAccountInfoEnum;

@interface MOAccount : NSObject <NSCoding>

@property (nonatomic,copy) NSString*     userName;
@property (nonatomic,copy) NSString*     password;
@property (nonatomic,copy) NSString*     phone;
@property (nonatomic,copy) NSString*     skype;
@property (nonatomic,copy) NSString*     email;
@property (nonatomic,copy) NSString*     section;
@property (nonatomic,retain) UIImage*    image;



#pragma mark - static constructor
+(instancetype)initWithName:(NSString *)name andPassword:(NSString *)password;
+(instancetype)account;

+(MOAccount*)loadAccount:(NSUserDefaults*)userDefaults;
-(void)saveAccount:(NSUserDefaults*)userDefaults;


-(void)toArray:(NSMutableArray*)array;
-(void)updateInfo:(NSDictionary*)dic;



-(void)dumpAccount;

@end
