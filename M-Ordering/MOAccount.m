//
//  MOAccount.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOAccount.h"

#define MO_ACCOUNT_USERNAME     @"用户名"
#define MO_ACCOUNT_PHONE        @"电话"
#define MO_ACCOUNT_SKYPE        @"skype"
#define MO_ACCOUNT_EMAIL        @"email"
#define MO_ACCOUNT_SECTION      @"部门"

#define MO_ACCOUNT_IMAGE        @"头像"


@implementation MOAccount

static NSArray* mapping = nil;


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

+(NSString*)valueAtIndex:(NSUInteger)index
{
    if(!mapping) mapping = @[MO_ACCOUNT_USERNAME,
                             MO_ACCOUNT_PHONE,
                             MO_ACCOUNT_SKYPE,
                             MO_ACCOUNT_EMAIL,
                             MO_ACCOUNT_SECTION];
    
    return [mapping objectAtIndex:index];
}
+(NSUInteger)indexOfValue:(NSString*)value;
{
    if(!mapping) mapping = @[MO_ACCOUNT_USERNAME,
                             MO_ACCOUNT_PHONE,
                             MO_ACCOUNT_SKYPE,
                             MO_ACCOUNT_EMAIL,
                             MO_ACCOUNT_SECTION];
    
    return [mapping indexOfObject:value];
}

-(void)toArray:(NSMutableArray*)array
{    
    NSDictionary* dic1 = [NSDictionary dictionaryWithObject:self.image forKey:@"头像"];
    [array addObject:dic1];
    
    NSArray* group = [NSArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"用户名"],
                      [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"电话"],
                      [NSMutableDictionary dictionaryWithObject:self.skype forKey:@"skype"],
                      [NSMutableDictionary dictionaryWithObject:self.email forKey:@"email"],
                      [NSMutableDictionary dictionaryWithObject:self.section forKey:@"部门"],
                      nil];
    [array addObject:group];
}
-(void)updateInfo:(NSDictionary*)dic
{
    NSString* key = [dic.allKeys objectAtIndex:0];
    
    switch ([MOAccount indexOfValue: key])
    {
        case MOAccountUserName:
            [self setUserName:[dic valueForKey:key]];
            break;
        case MOAccountPhone:
            [self setPhone:[dic valueForKey:key]];
            break;
        case MOAccountSkype:
            [self setSkype:[dic valueForKey:key]];
            break;
        case MOAccountEmail:
            [self setEmail:[dic valueForKey:key]];
            break;
        case MOAccountSection:
            [self setSection:[dic valueForKey:key]];
            break;
        default:
            break;
    }
    
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
