//
//  MOOrderEntry.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOOrderEntry.h"

@implementation MOOrderEntry

-(void)dumpEntry
{
    NSLog(@"MOOrderEntry---- orderId:%u, person:%@, url:%@, date:%@",
          self.orderId, self.person, self.url, self.date);
    [self.menuEntry dumpEntry];
}

@end
