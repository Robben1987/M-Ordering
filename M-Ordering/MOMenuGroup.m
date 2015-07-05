//
//  MOMenuGroup.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOMenuGroup.h"

@implementation MOMenuGroup


#pragma mark constructor
-(MOMenuGroup *)initWithName:(NSString*)name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys
{
    if((self=[super init]))
    {
        self.groupName = name;
        self.detail    = detail;
        self.entrys    = entrys;
    }
    
    return self;
}
-(void)dumpEntry
{
    NSLog(@"groupName: %@\n detail:%@\n tel:%@\n",
          self.groupName,
          self.detail,
          self.tel);
    if(self.entrys)
        NSLog(@"entrys num: %u", (unsigned)self.entrys.count);
    return;
}


#pragma mark static constructor
+(MOMenuGroup *)initWithName:(NSString* )name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys
{
    MOMenuGroup* entry = [[MOMenuGroup alloc] initWithName:name andDetail:detail andEntrys:entrys];
    
    return entry;
}

#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.groupName  forKey:@"groupName"];
    [aCoder encodeObject:self.detail     forKey:@"detail"];
    [aCoder encodeObject:self.tel        forKey:@"tel"];
    [aCoder encodeObject:self.href       forKey:@"href"];
    [aCoder encodeObject:self.entrys     forKey:@"entrys"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.groupName     = [aDecoder decodeObjectForKey:@"groupName"];
        self.detail        = [aDecoder decodeObjectForKey:@"detail"];
        self.tel           = [aDecoder decodeObjectForKey:@"tel"];
        self.href          = [aDecoder decodeObjectForKey:@"href"];
        self.entrys        = [aDecoder decodeObjectForKey:@"entrys"];
    }
    
    return self;
}
@end
