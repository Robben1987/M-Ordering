//
//  MOAccount.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-19.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MOAccount : NSObject <NSCoding>

@property (nonatomic,copy) NSString*     userName;
@property (nonatomic,copy) NSString*     password;
@property (nonatomic,retain) UIImage*    image;


#pragma mark - static constructor
+(instancetype)initWithName:(NSString *)name andPassword:(NSString *)password;
+(instancetype)account;

-(void)dumpAccount;

@end
