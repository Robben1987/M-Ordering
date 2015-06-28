//
//  MOOrderEntry.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOOrderEntry.h"
#import "MOCommon.h"

@implementation MOOrderEntry


#pragma mark- NSCoding Protocoal
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.orderId          forKey:@"orderId"];
    [aCoder encodeObject:self.person        forKey:@"person"];
    [aCoder encodeObject:self.url           forKey:@"url"];
    [aCoder encodeObject:self.date           forKey:@"date"];
    [aCoder encodeObject:self.menuEntry     forKey:@"menuEntry"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.orderId           = [aDecoder decodeIntForKey:@"orderId"];
        self.person            = [aDecoder decodeObjectForKey:@"person"];
        self.url               = [aDecoder decodeObjectForKey:@"url"];
        self.date              = [aDecoder decodeObjectForKey:@"date"];
        self.menuEntry         = [aDecoder decodeObjectForKey:@"menuEntry"];
    }
    
    return self;
}

#pragma mark- dump
-(void)dumpEntry
{
    NSLog(@"MOOrderEntry---- orderId:%u, person:%@, url:%@, date:%@",
          self.orderId, self.person, self.url, self.date);
    [self.menuEntry dumpEntry];
}

@end
