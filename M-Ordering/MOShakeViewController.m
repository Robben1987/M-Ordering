//
//  MOShakeViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-9.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MOShakeViewController.h"
#import "MOCommon.h"
#import "MODataOperation.h"
#import "MOMenuEntry.h"

#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180)

#define MO_SHAKE_SUBVIEW_OFFSET (50)
#define MO_SHAKE_ANIMATE_DURATION (0.5)

@interface MOShakeViewController ()
{
    float        _angle;
    float        _timeInter;
    BOOL         _isMove;
    CALayer*     _ballLayer;
}
@end

@implementation MOShakeViewController

+(MOShakeViewController*)initWithDataCtrl:(MODataController*)ctrl
{
    MOShakeViewController* viewCtrl = [[MOShakeViewController alloc] initWithDataCtrl: ctrl];
    return viewCtrl;
}

-(MOShakeViewController*)initWithDataCtrl:(MODataController*)ctrl
{
    self = [super init];
    if (self)
    {
        self.dataCtrl = ctrl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];
    
}
-(void)initView
{
    //设置默认参数
    _angle =30.0;
    _timeInter = 0.02;
    _isMove = FALSE;
    
    UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"bg.jpeg"]];
    [self.view addSubview:bg];
    
    [self initLayer];
}

-(void)initLayer
{
    _ballLayer=[CALayer layer];
    _ballLayer.bounds = CGRectMake(0, 0, 106, 365);
    _ballLayer.position = CGPointMake(self.view.frame.size.width/2, 480);
    _ballLayer.contents = (id)[UIImage imageNamed:@"balloon"].CGImage;
    _ballLayer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view.layer addSublayer:_ballLayer];
}

#pragma mark - UIResponder
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(_isMove) return;
    _isMove = TRUE;
    
    if (motion == UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //[self showDetailView: [[self.dataCtrl menuArray] objectAtIndex:[self getRandomIndex]]];
        
        //左右摇摆时间是定义的时间的2倍
        [NSTimer scheduledTimerWithTimeInterval:_timeInter*2
                                         target:self
                                       selector:@selector(ballAnmation:)
                                       userInfo:nil
                                        repeats:YES];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}


-(void)ballAnmation:(NSTimer *)theTimer
{
    //设置左右摇摆
    _angle = -_angle;
    if (_angle > 0) _angle--;
    else _angle++;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(_angle))];
    rotationAnimation.duration = _timeInter;
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_ballLayer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
    if (_angle == 0)
    {
        [theTimer invalidate];
        
        unsigned index = [self getRandomIndex];
        MOMenuEntry* entry = [[self.dataCtrl menuArray] objectAtIndex:index];
        NSString* info = [NSString stringWithFormat:@"%@(%@)", entry.entryName, entry.restaurant];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"恭喜您,摇到了" message:info delegate:self cancelButtonTitle:@"再摇一次" otherButtonTitles:@"就点这个", nil];
        [alert setTag: entry.index];
        [alert show];
        
        _angle = 30.0;
        _timeInter = 0.02;
        _isMove = FALSE;
    }
}

#pragma mark get the random index
-(unsigned)getRandomIndex
{
    return (unsigned)(arc4random() % [[self.dataCtrl menuArray] count]);
}

#pragma mark the alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [NSThread detachNewThreadSelector:@selector(sendOrder:) toTarget:self withObject:alertView];

        MO_SHOW_INFO(@"正在为您订餐...");
    }
    
    return;
}

#pragma mark - http method
-(void)showResult:(NSString*)result
{
    MO_SHOW_HIDE;
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        MO_SHOW_SUCC(@"恭喜您,订餐成功!");
    }
}

-(void)sendOrder:(UIAlertView *)alertView
{
    NSString* result = [self.dataCtrl sendOrder: (unsigned)alertView.tag];
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
}
-(void)viewWillDisappear:(BOOL)animated
{
}
@end
