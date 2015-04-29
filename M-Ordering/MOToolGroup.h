//
//  MOToolGroup.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-22.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOToolGroup : NSObject

@property (nonatomic,copy) NSString*         groupName;
@property (nonatomic,copy) NSString*         detail;
@property (nonatomic,strong) NSMutableArray* entrys;

#pragma mark constructor
-(MOToolGroup *)initWithName:(NSString*)name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys;

#pragma mark static constructor
+(MOToolGroup *)initWithName:(NSString* )name andDetail:(NSString*)detail andEntrys:(NSMutableArray*)entrys;
@end
