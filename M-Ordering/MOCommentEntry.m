//
//  MOCommentEntry.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOCommentEntry.h"

@implementation MOCommentEntry



#pragma mark constructor
-(MOCommentEntry *)initWithContent:(NSString *)content andIndex:(unsigned)index;
{
    if((self=[super init]))
    {
        self.index   = index;
        self.level   = 0;
        self.content = content;
    }
    
    return self;
}

#pragma mark static constructor
+(MOCommentEntry *)initWithContent:(NSString *)content andIndex:(unsigned)index
{
    MOCommentEntry* entry = [[MOCommentEntry alloc] initWithContent:content andIndex:index];
    
    return entry;
}


-(void)dumpEntry
{
    NSLog(@"content: %@, index:%u, level:%u",
          self.content,
          self.index,
          self.level);
}
/*
//    IOS-??Model(????)?Version(?????)?app(?????)?  
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);  
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);  
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);  
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);  
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);  
    */
@end
