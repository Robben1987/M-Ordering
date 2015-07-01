//
//  MOLoginViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-20.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOLoginViewController.h"
#import "MOMainController.h"
#import "MOCommon.h"

@interface MOLoginViewController () <UITextFieldDelegate>
{
    UITextField* _txtUserName;
    UITextField* _txtPassword;
}
@end

@implementation MOLoginViewController

+(MOLoginViewController*)initWithDataCtrl:(MODataController*)ctrl
{
    return [[MOLoginViewController alloc] initWithDataCtrl: ctrl];
}

-(MOLoginViewController*)initWithDataCtrl:(MODataController*)ctrl
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
    
    [self addOtherViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addOtherViews
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIImageView* backgroundImg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [backgroundImg setImage:[UIImage imageNamed:@"login_bg@2x.jpg"]];
    //[backgroundImg setAlpha:1.0];
    [self.view addSubview:backgroundImg];
    
    // 67.5 185 67.5
    //1. Top Img
    UIImageView* topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(67.5, 60, 185, 60)];
    [topImgView setImage:[UIImage imageNamed:@"logo001.jpg"]];
    [self.view addSubview:topImgView];

    //2. txt UserName
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(30, 160, 260, 40)];
    [_txtUserName setBorderStyle:UITextBorderStyleRoundedRect];
    [_txtUserName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_txtUserName setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [_txtUserName setClearsOnBeginEditing:YES];
    [_txtUserName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_txtUserName setKeyboardType:UIKeyboardTypeDefault];
    [_txtUserName setReturnKeyType:UIReturnKeyDefault];
    //[_txtUserName becomeFirstResponder];
    [_txtUserName setPlaceholder:@"账号"];
    [_txtUserName setDelegate:self];
    [_txtUserName setBackgroundColor: [UIColor whiteColor]];
    [_txtUserName setTag:1];
    //NSString* name = ((self.dataCtrl.userName) ? self.dataCtrl.userName: @"李志兴");
    [_txtUserName setText:self.dataCtrl.userName];
    [self.view addSubview:_txtUserName];
    
    //3. txt Password
    _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 260, 40)];
    [_txtPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [_txtPassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_txtPassword setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [_txtPassword setClearsOnBeginEditing:YES];
    [_txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_txtPassword setReturnKeyType:UIReturnKeyDone];
    [_txtPassword setPlaceholder:@"密码"];
    [_txtPassword setBackgroundColor: [UIColor whiteColor]];
    [_txtPassword setSecureTextEntry:YES];
    [_txtPassword setDelegate:self];
    [_txtPassword setTag:2];
    //NSString* password = ((self.dataCtrl.password) ? self.dataCtrl.password: @"123456");
    [_txtPassword setText:self.dataCtrl.password];
    [self.view addSubview:_txtPassword];
    
    //4. btnLogin
    UIButton* btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [btnLogin setFrame:CGRectMake(30, 255, 260, 44)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press"] forState:UIControlStateSelected];
    //[btnLogin setBackgroundColor:[UIColor whiteColor]];
    [btnLogin addTarget:self action:@selector(touchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    //50 80 28 4 28 80 50
    //5. labels
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 500, 80, 20)];
    [label1 setText:@"忘记密码"];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setFont: [UIFont systemFontOfSize:14]];
    [self.view addSubview:label1];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(190, 500, 80, 20)];
    [label2 setText:@"马上注册"];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setFont: [UIFont systemFontOfSize:14]];
    [self.view addSubview:label2];
    
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(158, 500, 4, 20)];
    [label3 setText:@"|"];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label3];

    
}

#pragma mark - UIButton touch event
-(void)touchLogin:(UIButton*)button
{
    if([_txtUserName.text length] == 0)
    {
        MO_SHOW_FAIL(@"请输入用户名");
        return;
    }
    
    if([_txtPassword.text length] == 0)
    {
        MO_SHOW_FAIL(@"请输入密码");
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(getLogin) toTarget:self withObject:nil];
    MO_SHOW_INFO(@"正在玩命加载中....");
    
    return;
}

#pragma mark - http handle
-(void)showResult:(NSString*)result
{
    MO_SHOW_HIDE;
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        MO_SHOW_SUCC(@"恭喜您,登陆成功!");
        MOMainController* rootViewCtrl = (MOMainController*)[self presentingViewController];
        [rootViewCtrl loadViewControllers];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getLogin
{
    NSString* result = [self.dataCtrl getLogin:[_txtUserName text] andPassWord:[_txtPassword text]];
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    return;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    return;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
