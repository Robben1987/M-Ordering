//
//  MOLoginDelegate.h
//  M-Ordering
//
//  Created by Li Robben on 15-3-21.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#ifndef M_Ordering_MOLoginDelegate_h
#define M_Ordering_MOLoginDelegate_h

@protocol MOLoginDelegate <NSObject>

@optional
-(BOOL)getLogin:(NSString*)name andPassWord:(NSString*)password;

@end

#endif
