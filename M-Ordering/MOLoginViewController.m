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

#define MO_LOGO_WIDTH  (180)
#define MO_LOGO_HEIGHT (60)

#define MO_TEXTVIEW_HEIGHT (40)
#define MO_BUTTON_HEIGHT (44)
#define MO_LABEL_HEIGHT (20)
#define MO_LABEL_WIDTH (4)



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
    
    CGFloat x = (self.view.frame.size.width - MO_LOGO_WIDTH) / 2;
    CGFloat y = self.view.frame.size.height / 8;

    //1. Top Img
    UIImageView* topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, MO_LOGO_WIDTH, MO_LOGO_HEIGHT)];
    [topImgView setImage:[UIImage imageNamed:@"logo001.jpg"]];
    [self.view addSubview:topImgView];

    //2. txt UserName
    x = self.view.frame.size.width / 8;
    y = self.view.frame.size.height / 3;
    CGFloat w = self.view.frame.size.width - x * 2;
    CGFloat h = MO_TEXTVIEW_HEIGHT;
    
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
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
    [_txtUserName setText:[self.dataCtrl userName]];
    [self.view addSubview:_txtUserName];
    
    //3. txt Password
    y += h;
    _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
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
    [_txtPassword setText:[self.dataCtrl password]];
    [self.view addSubview:_txtPassword];
    
    //4. btnLogin
    y = self.view.frame.size.height * 0.55f;
    h = MO_BUTTON_HEIGHT;
    UIButton* btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setFrame:CGRectMake(x, y, w, h)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press"] forState:UIControlStateSelected];
    //[btnLogin setBackgroundColor:[UIColor whiteColor]];
    [btnLogin addTarget:self action:@selector(touchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    //50 80 28 4 28 80 50
    //5. labels
    x = self.view.frame.size.width * 0.2f;
    y = self.view.frame.size.height * 0.9f;
    w = self.view.frame.size.width * 0.2f;
    h = MO_LABEL_HEIGHT;
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [label1 setText:@"忘记密码"];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setFont: [UIFont systemFontOfSize:14]];
    [self.view addSubview:label1];
    
    x = self.view.frame.size.width * 0.6f;
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [label2 setText:@"马上注册"];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setFont: [UIFont systemFontOfSize:14]];
    [self.view addSubview:label2];
    
    x = (self.view.frame.size.width - MO_LABEL_WIDTH) * 0.5f;
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, MO_LABEL_WIDTH, MO_LABEL_HEIGHT)];
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
