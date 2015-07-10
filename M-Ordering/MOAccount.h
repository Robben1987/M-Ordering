//
//  MOAccount.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    MOAccountUserName = 0,
    MOAccountPhone,
    MOAccountSkype,
    MOAccountEmail,
    MOAccountSection,
    MOAccountImage
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
