//
//  MOAccount.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOAccount.h"

#define MO_ACCOUNT_IMAGE        @"头像"

#define MO_ACCOUNT_USERNAME     @"用户名"
#define MO_ACCOUNT_PHONE        @"电话"
#define MO_ACCOUNT_SKYPE        @"skype"
#define MO_ACCOUNT_EMAIL        @"email"

#define MO_ACCOUNT_SECTION      @"部门"



@implementation MOAccount


#pragma mark static constructor
+(instancetype)initWithName:(NSString *)name andPassword:(NSString *)password
{   
    return [[MOAccount alloc] initWithName:name andPassword:password];
}
+(instancetype)account
{
    return [[MOAccount alloc] initWithName:nil andPassword:nil];
}

#pragma mark constructor
-(MOAccount*)initWithName:(NSString *)name andPassword:(NSString *)password
{
    if((self=[super init]))
    {
        self.userName = name;
        self.password = password;
    }
    
    return self;
}

+(MOAccount*)loadAccount:(NSUserDefaults*)userDefaults
{
    MOAccount* account =
    [MOAccount initWithName:[userDefaults stringForKey:@"userName"]
                andPassword:[userDefaults stringForKey:@"password"]];
    [account setPhone:[userDefaults       stringForKey:@"phone"]];
    [account setSkype:[userDefaults       stringForKey:@"skype"]];
    [account setEmail:[userDefaults       stringForKey:@"email"]];
    [account setSection:[userDefaults     stringForKey:@"section"]];
    NSData* image = [userDefaults         objectForKey:@"image"];
    [account setImage:[UIImage imageWithData:image]];
    
    return account;
}

-(void)saveAccount:(NSUserDefaults*)userDefaults
{
    [userDefaults setObject:self.userName forKey:@"userName"];
    [userDefaults setObject:self.password forKey:@"password"];
    [userDefaults setObject:self.phone    forKey:@"phone"];
    [userDefaults setObject:self.skype    forKey:@"skype"];
    [userDefaults setObject:self.email    forKey:@"email"];
    [userDefaults setObject:self.section  forKey:@"section"];
    NSData* image = UIImagePNGRepresentation(self.image);
    [userDefaults setObject:image         forKey:@"image"];

}

-(void)toArray:(NSMutableArray*)array
{    
    NSArray* group1 = [NSArray arrayWithObjects:
                       [NSMutableDictionary dictionaryWithObject:self.image forKey:MO_ACCOUNT_IMAGE],
                       nil];
    [array addObject:group1];
    
    NSArray* group2 = [NSArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObject:self.userName forKey:MO_ACCOUNT_USERNAME],
                      [NSMutableDictionary dictionaryWithObject:self.phone forKey:MO_ACCOUNT_PHONE],
                      [NSMutableDictionary dictionaryWithObject:self.skype forKey:MO_ACCOUNT_SKYPE],
                      [NSMutableDictionary dictionaryWithObject:self.email forKey:MO_ACCOUNT_EMAIL],
                      nil];

    [array addObject:group2];
    
    NSArray* group3 = [NSArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObject:self.section forKey:MO_ACCOUNT_SECTION],
                       nil];
    [array addObject:group3];
}
-(void)updateInfo:(NSDictionary*)dic
{
    NSString* key = [dic.allKeys objectAtIndex:0];
    NSString* value = [dic valueForKey:key];
    
    if([key isEqualToString:MO_ACCOUNT_USERNAME])
    {
        [self setUserName:value];
    }else if([key isEqualToString:MO_ACCOUNT_PHONE])
    {
        [self setPhone:value];
    }else if([key isEqualToString:MO_ACCOUNT_SKYPE])
    {
        [self setSkype:value];
    }else if([key isEqualToString:MO_ACCOUNT_EMAIL])
    {
        [self setEmail:value];
    }else if([key isEqualToString:MO_ACCOUNT_SECTION])
    {
        [self setSection:value];
    }
    return;
}

#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName   forKey:@"userName"];
    [aCoder encodeObject:self.password   forKey:@"password"];
    [aCoder encodeObject:self.phone      forKey:@"phone"];
    [aCoder encodeObject:self.skype      forKey:@"skype"];
    [aCoder encodeObject:self.email      forKey:@"email"];
    [aCoder encodeObject:self.section    forKey:@"section"];

    [aCoder encodeObject:self.image      forKey:@"image"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.userName      = [aDecoder decodeObjectForKey:@"userName"];
        self.password      = [aDecoder decodeObjectForKey:@"password"];
        self.phone         = [aDecoder decodeObjectForKey:@"phone"];
        self.skype         = [aDecoder decodeObjectForKey:@"skype"];
        self.email         = [aDecoder decodeObjectForKey:@"email"];
        self.section       = [aDecoder decodeObjectForKey:@"section"];
        
        self.image         = [aDecoder decodeObjectForKey:@"image"];
    }
    
    return self;
}

-(void)dumpAccount
{
    NSLog(@"userName: %@, password:%@, phone:%@, skype:%@, email:%@, section:%@",
          self.userName,
          self.password,
          self.phone,
          self.skype,
          self.email,
          self.section);
}
@end
