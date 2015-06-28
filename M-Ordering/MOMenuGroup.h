//
//  MOMenuGroup.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOMenuGroup : NSObject <NSCoding>

@property (nonatomic,copy) NSString*         groupName;
@property (nonatomic,copy) NSString*         detail;
@property (nonatomic,copy) NSString*         tel;
@property (nonatomic,copy) NSString*         href;
@property (nonatomic,strong) NSMutableArray* entrys;


#pragma mark constructor
-(MOMenuGroup *)initWithName:(NSString*)name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys;
-(void)dumpEntry;

#pragma mark static constructor
+(MOMenuGroup *)initWithName:(NSString* )name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys;


@end
