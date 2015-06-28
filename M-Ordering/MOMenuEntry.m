//
//  MOMenuEntry.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOMenuEntry.h"

@implementation MOMenuEntry



#pragma mark constructor
-(MOMenuEntry *)initWithName:(NSString *)name andIndex:(unsigned)index
{
    if((self=[super init]))
    {
        self.entryName = name;
        self.index = index;
    }
    
    return self;
}
-(void)dumpEntry
{
    NSLog(@"entryName: %@, index:%u, price:%f, chosedTimes:%u, restaurant:%@, commentNumber:%u",
          self.entryName,
          self.index,
          self.price,
          self.chosedTimes,
          self.restaurant,
          self.commentNumber);
}

#pragma mark static constructor
+(MOMenuEntry *)initWithName:(NSString *)name andIndex:(unsigned)index
{
    MOMenuEntry* entry = [[MOMenuEntry alloc] initWithName:name andIndex:index];
    
    return entry;
}


#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.entryName   forKey:@"entryName"];
    [aCoder encodeInt:self.index          forKey:@"index"];
    [aCoder encodeFloat:self.price        forKey:@"price"];
    [aCoder encodeInt:self.chosedTimes    forKey:@"chosedTimes"];
    [aCoder encodeObject:self.restaurant  forKey:@"restaurant"];
    [aCoder encodeInt:self.commentNumber  forKey:@"commentNumber"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.entryName          = [aDecoder decodeObjectForKey:@"entryName"];
        self.index              = [aDecoder decodeIntForKey:@"index"];
        self.price              = [aDecoder decodeFloatForKey:@"price"];
        self.chosedTimes        = [aDecoder decodeIntForKey:@"chosedTimes"];
        self.restaurant         = [aDecoder decodeObjectForKey:@"restaurant"];
        self.commentNumber      = [aDecoder decodeIntForKey:@"commentNumber"];
    }
    
    return self;
}
@end
