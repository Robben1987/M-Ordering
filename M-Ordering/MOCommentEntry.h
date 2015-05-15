//
//  MOCommentEntry.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOCommentEntry : NSObject

@property (nonatomic,assign) unsigned  index; //MOMenuEntry index
@property (nonatomic,assign) unsigned  level;
@property (nonatomic,copy) NSString*   content;



#pragma mark constructor
-(MOCommentEntry *)initWithContent:(NSString *)content andIndex:(unsigned)index;

#pragma mark static constructor
+(MOCommentEntry *)initWithContent:(NSString *)content andIndex:(unsigned)index;


-(void)dumpEntry;

@end
