//
//  MOMenuEntry.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOMenuEntry : NSObject <NSCoding>

@property (nonatomic,copy) NSString*   entryName;
@property (nonatomic,assign) unsigned  index;
@property (nonatomic,assign) float     price;
@property (nonatomic,assign) unsigned  chosedTimes;
@property (nonatomic,copy) NSString*   restaurant;
@property (nonatomic,assign) unsigned  commentNumber;



#pragma mark constructor
-(MOMenuEntry *)initWithName:(NSString *)name andIndex:(unsigned)index;
-(void)dumpEntry;

#pragma mark static constructor
+(MOMenuEntry *)initWithName:(NSString *)name andIndex:(unsigned)index;

@end
