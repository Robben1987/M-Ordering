//
//  MOOrderEntry.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOMenuEntry.h"

@interface MOOrderEntry : NSObject <NSCoding>

@property (nonatomic,assign) unsigned      orderId;
@property (nonatomic,copy) NSString*       person;
@property (nonatomic,copy) NSString*       url;
@property (nonatomic,copy) NSString*       date;
@property (nonatomic,strong) MOMenuEntry*  menuEntry;

-(void)dumpEntry;

@end
