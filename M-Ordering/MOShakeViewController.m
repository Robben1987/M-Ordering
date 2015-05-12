//
//  MOShakeViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <stdlib.h>
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

    BOOL        _isMove;
}
@end

@implementation MOShakeViewController

-(MOShakeViewController*)initWithDataCtrl:(MODataController*)ctrl
{
    self = [super init];
    if (self)
    {
        self.dataCtrl = ctrl;
    }
    return self;
}

-(void)initView
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    _isMove = FALSE;
    
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
-(void)moveImageView
{
    _isMove = TRUE;
    [UIView animateWithDuration:MO_SHAKE_ANIMATE_DURATION animations:^{
            [_imgUp setFrame: CGRectMake((_imgUp.frame.origin.x), (_imgUp.frame.origin.y - MO_SHAKE_SUBVIEW_OFFSET), _imgUp.frame.size.width, _imgUp.frame.size.height)];
            [_imgDown setFrame:CGRectMake((_imgDown.frame.origin.x), (_imgDown.frame.origin.y + MO_SHAKE_SUBVIEW_OFFSET), _imgDown.frame.size.width, _imgDown.frame.size.height)];
        }];
}
-(void)backImageView
{
    _isMove = FALSE;
    [UIView animateWithDuration:MO_SHAKE_ANIMATE_DURATION animations:^{
        [_imgUp setFrame: CGRectMake((_imgUp.frame.origin.x), (_imgUp.frame.origin.y + MO_SHAKE_SUBVIEW_OFFSET), _imgUp.frame.size.width, _imgUp.frame.size.height)];
        [_imgDown setFrame:CGRectMake((_imgDown.frame.origin.x), (_imgDown.frame.origin.y - MO_SHAKE_SUBVIEW_OFFSET), _imgDown.frame.size.width, _imgDown.frame.size.height)];
     }];
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"start shark");
        if(!_isMove)
        {
            [self moveImageView];
        }
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"finish shark");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self showDetailView: [[self.dataCtrl getMenuList] objectAtIndex:[self getRandomIndex]]];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel shark");
    if(_isMove)
    {
        [self backImageView];
    }
}


-(unsigned)getRandomIndex
{
    return (unsigned)(arc4random() % [[self.dataCtrl getMenuList] count]);
}

-(void)showDetailView:(MOMenuEntry*)entry
{
    //320 * 0.85 = 272
    UIView* infoView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width * 0.85, MO_SHAKE_SUBVIEW_OFFSET*2)];
    [infoView setCenter:self.view.center];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 272, MO_SHAKE_SUBVIEW_OFFSET)];
    infoLabel.text = @"您摇到了。。。。。。";
    
    UIButton* sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MO_SHAKE_SUBVIEW_OFFSET, 136, MO_SHAKE_SUBVIEW_OFFSET)];
    [sendButton setBackgroundColor: [UIColor grayColor]];
    [sendButton setTitle:@"就订它" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(136, MO_SHAKE_SUBVIEW_OFFSET, 136, MO_SHAKE_SUBVIEW_OFFSET)];
    [cancelButton setBackgroundColor: [UIColor grayColor]];
    [cancelButton setTitle:@"继续摇一摇" forState:UIControlStateNormal];
    
    [infoView addSubview:infoLabel];
    [infoView addSubview:sendButton];
    [infoView addSubview:cancelButton];
    
    [self.view addSubview:infoView];
}

#pragma mark - 发送异步请求
-(void)showResult:(NSString*)result
{
    [self backImageView];   
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        MO_SHOW_SUCC(@"恭喜您,订餐成功!");
    }
}
- (void)sendOrder:(UIButton*)btn
{
    sleep(5);
    NSString* result = nil;
    if(![self.dataCtrl sendOrder: (unsigned)btn.tag])
    {
        result = @"网络错误...";
    }
    
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}

-(void)clickButton:(UIButton*)btn
{
    [_indicatorView startAnimating];
    [NSThread detachNewThreadSelector:@selector(sendOrder:) toTarget:self withObject:btn];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
