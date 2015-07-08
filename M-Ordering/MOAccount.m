//
//  MOAccount.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOAccount.h"

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
@end
