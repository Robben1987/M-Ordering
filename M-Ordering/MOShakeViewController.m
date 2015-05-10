//
//  MOShakeViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "MOShakeViewController.h"
#import "MOCommon.h"
#import "MODataOperation.h"

#define MO_SHAKE_SUBVIEW_OFFSET (50)
#define MO_SHAKE_ANIMATE_DURATION (0.5)
typedef enum
{
    MO_ORDER_INVALID = 0,
    MO_ORDER_SEND    = 1,
    MO_ORDER_CANCEL  = 2,
}MO_SHAKE_ORDER_STATE;

@interface MOShakeViewController ()
{
    //UIImageView* _imgBackground;
    UIImageView* _imgUp;
    UIImageView* _imgDown;
    UIActivityIndicatorView* _indicatorView;
    MOMenuEntry* _ordered;
}
@end

@implementation MOShakeViewController
-(void)initView
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _ordered = [[MOMenuEntry alloc] init];
    //[self clearOrdered];
    
    CGRect upRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.5);
    CGRect downRect = CGRectMake(0, upRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    MO_SHOW_RECT(@"upRect", upRect);
    MO_SHOW_RECT(@"downRect", downRect);

    _imgUp = [[UIImageView alloc] initWithFrame: upRect];
    [_imgUp setImage: [UIImage imageNamed:@"shake_up01"]];
    [self.view addSubview:_imgUp];
    
    _imgDown = [[UIImageView alloc] initWithFrame: downRect];
    [_imgDown setImage: [UIImage imageNamed:@"shake_down01"]];
    [self.view addSubview:_imgDown];
    
    _indicatorView = [[UIActivityIndicatorView alloc]
                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView setCenter:self.view.center];
    [self.view addSubview:_indicatorView];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];
    
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"start shark");
        [UIView animateWithDuration:MO_SHAKE_ANIMATE_DURATION animations:^{
            [_imgUp setFrame: CGRectMake((_imgUp.frame.origin.x), (_imgUp.frame.origin.y - MO_SHAKE_SUBVIEW_OFFSET), _imgUp.frame.size.width, _imgUp.frame.size.height)];
            [_imgDown setFrame:CGRectMake((_imgDown.frame.origin.x), (_imgDown.frame.origin.y + MO_SHAKE_SUBVIEW_OFFSET), _imgDown.frame.size.width, _imgDown.frame.size.height)];
            [_indicatorView startAnimating];
        }];
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"finish shark");
        [self sendHttpRequestByThread];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel shark");
}
-(BOOL)isOrdered
{
    return (_ordered.index != MO_INVALID_UINT);
}
-(void)clearOrdered
{
    [_ordered setIndex:MO_INVALID_UINT];
}

-(void)showDetailView
{
    //320 * 0.85 = 272
    UIView* infoView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width * 0.85, MO_SHAKE_SUBVIEW_OFFSET)];
    [infoView setCenter:self.view.center];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, MO_SHAKE_SUBVIEW_OFFSET)];
    infoLabel.text = @"您预订了。。。。。。";
    
    UIButton* infoButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 72, MO_SHAKE_SUBVIEW_OFFSET)];
    [infoButton setBackgroundColor: [UIColor grayColor]];
    [infoButton setTitle:@"不满意,取消" forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(orderCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [infoView addSubview:infoLabel];
    [infoView addSubview:infoButton];
    
    [self.view addSubview:infoView];
}
#pragma mark - 发送异步请求
-(void)orderCancel:(UIButton*)btn
{
    NSLog(@"orderCancel");
    [self sendHttpRequestByThread];
}
-(void)showResult:(NSString*)result
{
    [UIView animateWithDuration:MO_SHAKE_ANIMATE_DURATION animations:^{
        [_imgUp setFrame: CGRectMake((_imgUp.frame.origin.x), (_imgUp.frame.origin.y + MO_SHAKE_SUBVIEW_OFFSET), _imgUp.frame.size.width, _imgUp.frame.size.height)];
        [_imgDown setFrame:CGRectMake((_imgDown.frame.origin.x), (_imgDown.frame.origin.y - MO_SHAKE_SUBVIEW_OFFSET), _imgDown.frame.size.width, _imgDown.frame.size.height)];
        [_indicatorView stopAnimating];
     }];
    
    if(result)
    {
        MO_SHOW_FAIL(result);
    }
    
    if([self isOrdered])
    {
        //todo: set ordered in data ctrl
        
        [self showDetailView];
    }

}
- (void)sendRequest
{
    sleep(5);
     NSString* result = nil;
    if(![self isOrdered])
    {
        if(![MODataOperation orderRandom:_ordered])
        {
            result = @"网络错误...";
        }
    
        [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
    }else
    {
        if(![MODataOperation cancel:[_ordered index]])
        {
            result = @"网络错误...";
        }else
        {
            [self clearOrdered];
        }
        
        [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
    }
}
- (void)sendHttpRequestByThread
{
    [NSThread detachNewThreadSelector:@selector(sendRequest) toTarget:self withObject:nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
