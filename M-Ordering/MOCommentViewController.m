//
//  MOCommentViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-12.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOCommentViewController.h"
#import "MOCommon.h"

@interface MOCommentViewController () <UITextViewDelegate>
{
    UITextView* _commentView;
    UIButton*   _publishButton;
    UINavigationBar* _naviBar;
}
@end

@implementation MOCommentViewController

-(MOCommentViewController*)initWithComment:(MOCommentEntry*)commentEntry andDataCtrl:(MODataController*)ctrl
{
    self = [super init];
    if(self)
    {
        self.commentEntry = commentEntry;
        self.dataCtrl   = ctrl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

- (void)initSubView
{
    //get statusbar rect
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect barFrame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, 44);
    CGRect textFrame = CGRectMake(5, (rectStatus.size.height + barFrame.size.height + 10), (self.view.frame.size.width - 10), 200);
        
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:@"我的评论"];
    UIBarButtonItem*  barCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(touchCancel)]; 
    UIBarButtonItem*  barPublish = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(touchPublish)]; 
    [naviItem setLeftBarButtonItem:barCancel];
    [naviItem setRightBarButtonItem:barPublish];
    
    _naviBar = [[UINavigationBar alloc] initWithFrame:barFrame]; 
    [_naviBar pushNavigationItem:naviItem animated:NO];  
    [self.view addSubview:_naviBar];
    
    _commentView = [[UITextView alloc] initWithFrame:textFrame];
    [_commentView setBackgroundColor:[UIColor yellowColor]];
    [_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDone];
    [_commentView setKeyboardType:UIKeyboardTypeDefault];
    [_commentView setScrollEnabled:YES];
    [_commentView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [_commentView setTextColor:[UIColor blackColor]];
    [_commentView setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    [_commentView.layer setCornerRadius:10];
    //[_commentView]
    [self.view addSubview:_commentView];
    
    //UIMenuController 
    UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"分享到新浪微博" action:@selector(shareSina:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[menuItem]];

}

#pragma mark - Button TouchUpInside event
-(void)touchPublish
{
    [_commentView resignFirstResponder];
    
    //todo MOCommentEntry
    [self.commentEntry setContent: [_commentView text]];
    //[self.commentEntry setLevel: [_commentView text]];
    [NSThread detachNewThreadSelector:@selector(sendComment:) toTarget:self withObject:self.commentEntry];
    MO_SHOW_INFO(@"正在为您发送...");
}
-(void)touchCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - http methord
-(void)showResult:(NSString*)result
{
    MO_SHOW_HIDE;
    if(result)
    {
        MO_SHOW_FAIL(result);
    }else
    {
        MO_SHOW_SUCC(@"感谢您的评论!");
    }
}
-(void)sendComment:(MOCommentEntry*)entry
{
    NSString* result = nil;
    if(![self.dataCtrl sendComment: entry])
    {
        result = @"网络错误...";
    }
    
    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
}

#pragma mark - Rewrite UIResponder methord
-(void)shareSina:(id)sender
{

}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //UIResponderStandardEditActions
    if(action == @selector(shareSina:))
    {
        if(_commentView.selectedRange.length > 0)
            return YES;
    }
    
    return NO;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    return;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    return;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    static int i = 1;
    NSLog(@"....i=%d",i++);
    NSLog(@"range:(%lu, %lu)",range.location,range.length);
    if([text isEqualToString:@"\n"])
    {
        [_commentView resignFirstResponder];
        return NO;
    }
    
    if(range.location >= 10)
    {
        MO_SHOW_FAIL(@"最多只能输入140个字!");
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"已输入:%lu", textView.text.length);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[_commentView resignFirstResponder];
    [self.view endEditing:YES];
}

@end
