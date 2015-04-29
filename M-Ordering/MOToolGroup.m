//
//  MOToolGroup.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-22.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOToolGroup.h"

@implementation MOToolGroup

#pragma mark constructor
-(MOToolGroup *)initWithName:(NSString*)name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys
{
    if((self=[super init]))
    {
        self.groupName = name;
        self.detail    = detail;
        self.entrys    = entrys;
    }
    
    return self;
}

#pragma mark static constructor
+(MOToolGroup *)initWithName:(NSString* )name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys
{
    MOToolGroup* entry = [[MOToolGroup alloc] initWithName:name andDetail:detail andEntrys:entrys];
    
    return entry;
}

@end
