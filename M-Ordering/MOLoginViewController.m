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
    UITextField* txtUserName;
    UITextField* txtPassword;
}
@end

@implementation MOLoginViewController

- (void)loadView
{
    [super loadView];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    //[view release];
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
    txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(30, 160, 260, 40)];
    [txtUserName setBorderStyle:UITextBorderStyleRoundedRect];
    [txtUserName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [txtUserName setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [txtUserName setClearsOnBeginEditing:YES];
    [txtUserName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtUserName setKeyboardType:UIKeyboardTypeDefault];
    [txtUserName setReturnKeyType:UIReturnKeyDefault];
    //[txtUserName becomeFirstResponder];
    [txtUserName setPlaceholder:@"账号"];
    [txtUserName setDelegate:self];
    [txtUserName setBackgroundColor: [UIColor whiteColor]];
    [txtUserName setTag:1];
    [txtUserName setText:@"Robben"];
    [self.view addSubview:txtUserName];
    
    //3. txt Password
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 260, 40)];
    [txtPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [txtPassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [txtPassword setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [txtPassword setClearsOnBeginEditing:YES];
    [txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtPassword setReturnKeyType:UIReturnKeyDone];
    [txtPassword setPlaceholder:@"密码"];
    [txtPassword setBackgroundColor: [UIColor whiteColor]];
    [txtPassword setSecureTextEntry:YES];
    [txtPassword setDelegate:self];
    [txtPassword setTag:2];
    [txtPassword setText:@"123456"];
    [self.view addSubview:txtPassword];
    
    //4. btnLogin
    UIButton* btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [btnLogin setFrame:CGRectMake(30, 255, 260, 44)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press"] forState:UIControlStateSelected];
    //[btnLogin setBackgroundColor:[UIColor whiteColor]];
    [btnLogin addTarget:self action:@selector(btnLogin:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)btnLogin:(UIButton*)button
{

    if([txtUserName.text length] == 0)
    {
        MO_SHOW_FAIL(@"请输入用户名");
        return;
    }
    
    if([txtPassword.text length] == 0)
    {
        MO_SHOW_FAIL(@"请输入密码");
        return;
    }
    
    MO_SHOW_INFO(@"正在玩命加载中....");

    [self.dataCtrl getLogin:[txtUserName text] andPassWord:[txtPassword text] viewController:self];
    
    return;
}
-(void)backToMain
{
    MO_SHOW_HIDE;
    MOMainController* rootViewCtrl = (MOMainController*)[self presentingViewController];
    [rootViewCtrl loadViewControllers];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //MOMainController* rootViewCtrl = (MOMainController*)[[self.view superview] nextResponder];
    //[self.view removeFromSuperview];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
