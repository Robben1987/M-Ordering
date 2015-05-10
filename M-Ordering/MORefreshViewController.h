//
//  MORefreshViewController.h
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MO_REFRESH_MY_HISTORY,
    MO_REFRESH_OTHERS,
}MO_REFRESH_TABLE_TYPE;

@interface MORefreshViewController : UIViewController

@property(nonatomic, assign)MO_REFRESH_TABLE_TYPE type;

-(MORefreshViewController*)initWithType:(MO_REFRESH_TABLE_TYPE)type;
@end
