//
//  MOCommentViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-12.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MOCommentViewController.h"
#import "MOCommon.h"
#import "MOStarRateView.h"
#import "MOCommentEntry.h"

#define MO_TEXT_VIEW_PLACEHOLDER (@"把您的点评分享给小伙伴们吧!")
#define MO_STAR_NUM (5)
#define MAX_LIMIT_NUMS (10)

#define MO_ORDER_LABEL_HEIGHT    (50)
#define MO_STAR_LABEL_HEIGHT     (30)
#define MO_STAR_VIEW_HEIGHT      (40)
#define MO_COMMENT_VIEW_HEIGHT   (200)
#define MO_COMMENT_LABEL_WIDTH   (70)
#define MO_COMMENT_LABEL_HEIGHT  (30)

#define MO_DEFAULT_OFFSET        (10)



@interface MOCommentViewController () <UITextViewDelegate>
{
    UILabel*         _orderLabel;
    
    UILabel*         _starLabel;
    MOStarRateView*  _starView;
    
    UITextView*      _commentView;
    UILabel*         _commentLabel;
    
    UINavigationItem* _naviItem;
    UINavigationBar* _naviBar;
}
@end

@implementation MOCommentViewController

-(MOCommentViewController*)initWithComment:(MOOrderEntry*)order andDataCtrl:(MODataController*)ctrl
{
    self = [super init];
    if(self)
    {
        self.orderEntry = order;
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
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    
    //init navi bar
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect barFrame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, 44);
    //MO_SHOW_RECT(@"barFrame", barFrame);
    _naviItem = [[UINavigationItem alloc] initWithTitle:@"我的评论"];
    UIBarButtonItem*  barCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(touchCancel)];
    UIBarButtonItem*  barPublish = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(touchPublish)];
    [barPublish setEnabled:NO];
    [_naviItem setLeftBarButtonItem:barCancel];
    [_naviItem setRightBarButtonItem:barPublish];
    
    _naviBar = [[UINavigationBar alloc] initWithFrame:barFrame];
    [_naviBar pushNavigationItem:_naviItem animated:NO];
    [self.view addSubview:_naviBar];
    
    //init order label
    CGRect orderLabelRect = CGRectMake(0,
                                       (barFrame.origin.y + barFrame.size.height),
                                       self.view.frame.size.width,
                                       MO_ORDER_LABEL_HEIGHT);
    //MO_SHOW_RECT(@"orderLabelRect", orderLabelRect);
    _orderLabel = [[UILabel alloc] initWithFrame:orderLabelRect];
    [_orderLabel setAdjustsFontSizeToFitWidth:YES];
    //[_orderLabel setBackgroundColor:[UIColor blueColor]];
    //[_orderLabel setFont:[UIFont systemFontOfSize: 24.0f]];
    [_orderLabel setNumberOfLines:2];
    [_orderLabel setText: [NSString stringWithFormat:@"%@ (%@)",
                           [self.orderEntry.menuEntry entryName],
                           [self.orderEntry.menuEntry restaurant]]];
    [self.view addSubview:_orderLabel];
    
    //init comment text view
    CGRect commentViewRect = CGRectMake(0,
                        (orderLabelRect.origin.y + orderLabelRect.size.height),
                        self.view.frame.size.width,
                        MO_COMMENT_VIEW_HEIGHT);
    //MO_SHOW_RECT(@"commentViewRect", commentViewRect);
    _commentView = [[UITextView alloc] initWithFrame:commentViewRect];
    //[_commentView setBackgroundColor:[UIColor yellowColor]];
    [_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDone];
    [_commentView setKeyboardType:UIKeyboardTypeDefault];
    [_commentView setScrollEnabled:YES];
    [_commentView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [_commentView setTextColor:[UIColor lightGrayColor]];
    [_commentView setText:MO_TEXT_VIEW_PLACEHOLDER];
    [_commentView setFont:[UIFont fontWithName:@"Arial" size:18.0]];

    //[_commentView.layer setCornerRadius:10];//设置圆角
    [self.view addSubview:_commentView];
    
    //init comment label
    CGRect commentLabelRect = CGRectMake((commentViewRect.size.width - MO_COMMENT_LABEL_WIDTH),
                                         (MO_COMMENT_VIEW_HEIGHT - MO_COMMENT_LABEL_HEIGHT),
                                         MO_COMMENT_LABEL_WIDTH,
                                         MO_COMMENT_LABEL_HEIGHT);
    //MO_SHOW_RECT(@"commentLabelRect", commentLabelRect);
    _commentLabel = [[UILabel alloc] initWithFrame:commentLabelRect];
    [_commentLabel setText:[NSString stringWithFormat:@"%u/%u", MAX_LIMIT_NUMS, MAX_LIMIT_NUMS]];
    [_commentView addSubview:_commentLabel];
    
    //init star label
    CGRect starLabelRect = CGRectMake(0,
                                      (commentViewRect.origin.y + commentViewRect.size.height),
                                      self.view.frame.size.width,
                                      MO_STAR_LABEL_HEIGHT);
    //MO_SHOW_RECT(@"starLabelRect", starLabelRect);
    _starLabel = [[UILabel alloc] initWithFrame:starLabelRect];
    [_orderLabel setAdjustsFontSizeToFitWidth:YES];
    //[_starLabel setBackgroundColor:[UIColor brownColor]];
    //[_starLabel setText:@"口味："];
    [self.view addSubview:_starLabel];
    
    //init star view
    CGRect starViewRect = CGRectMake(0,
                                     (starLabelRect.origin.y + starLabelRect.size.height),
                                     self.view.frame.size.width,
                                     MO_STAR_VIEW_HEIGHT);
    //MO_SHOW_RECT(@"starViewRect", starViewRect);
    _starView = [[MOStarRateView alloc] initWithFrame:starViewRect numberOfStars:MO_STAR_NUM];
    [_starView setAllowIncompleteStar:YES];
    [_starView setHasAnimation:YES];
    [self.view addSubview:_starView];
    
    //init UIMenuController
    UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"分享到新浪微博" action:@selector(shareSina:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[menuItem]];
    
}

#pragma mark - Button TouchUpInside event
-(void)touchPublish
{
    [_commentView resignFirstResponder];
    
    MOCommentEntry* comment = [[MOCommentEntry alloc] initWithIndex:[self.orderEntry.menuEntry index]];
    [comment setContent: [_commentView text]];
    [comment setLevel: ceilf((_starView.scorePercent) * MO_STAR_NUM)];
    NSLog(@"commentEntry: index:%u, level:%u, content:%@",
          comment.index,
          comment.level,
          comment.content);
    [NSThread detachNewThreadSelector:@selector(sendComment:) toTarget:self withObject:comment];
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
    MO_SHOW_FAIL(@"正在开发中...");
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
    if ([_commentView.text isEqualToString:MO_TEXT_VIEW_PLACEHOLDER])
    {
        _commentView.text = @"";
        _commentView.textColor = [UIColor blackColor]; //optional
        [_naviItem.rightBarButtonItem setEnabled:YES];
    }
    return;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_commentView.text isEqualToString:@""])
    {
        _commentView.text = MO_TEXT_VIEW_PLACEHOLDER;
        _commentView.textColor = [UIColor lightGrayColor]; //optional
        [_naviItem.rightBarButtonItem setEnabled:NO];
    }
    return;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if([text isEqualToString:@"\n"])
    {
        [_commentView resignFirstResponder];
        return NO;
    }
    
    UITextRange* selectedRange = [textView markedTextRange];
    NSInteger existLen = 0;
    
    //if marked exist
    if(selectedRange)
    {
        existLen = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        if(existLen < MAX_LIMIT_NUMS)
        {
            return YES;
        }else
        {
            MO_SHOW_FAIL(([NSString stringWithFormat:@"最多只能输入%u个字!", MAX_LIMIT_NUMS]));
            return NO;
        }
    }
    
    existLen = [_commentView.text length];
    if((existLen + text.length) <= MAX_LIMIT_NUMS)
    {
        return YES;
    }else
    {
        //if text is emoji or other symbols, don't cut
        if(![text canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            MO_SHOW_FAIL(@"表情占两个字符哦!");
            return NO;
        }
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"已输入:%lu", textView.text.length);
    
    UITextRange* selectedRange = [textView markedTextRange];
    if (selectedRange)
    {
        return;
    }
    
    if([textView.text length] > MAX_LIMIT_NUMS)
    {
        [textView setText:[textView.text substringToIndex:MAX_LIMIT_NUMS]];
        MO_SHOW_FAIL(([NSString stringWithFormat:@"最多只能输入%u个字!", MAX_LIMIT_NUMS]));
    }
    
    [_commentLabel setText:[NSString stringWithFormat:@"%lu/%u", MAX(0,(MAX_LIMIT_NUMS - [textView.text length])),MAX_LIMIT_NUMS]];
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

#if 0
// this version cut the emoji symbols rightly
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    NSLog(@"input: range(%lu,%lu), text(%lu)", range.location, range.length, text.length);
    
    if([text isEqualToString:@"\n"])
    {
        [_commentView resignFirstResponder];
        return NO;
    }
    
    UITextRange* selectedRange = [textView markedTextRange];
    NSInteger existLen = 0;
    
    //if marked exist
    if(selectedRange)
    {
        existLen = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        if(existLen < MAX_LIMIT_NUMS)
        {
            return YES;
        }else
        {
            return NO;
        }
    }
    
    existLen = [_commentView.text length];
    if((existLen + text.length) <= MAX_LIMIT_NUMS)
    {
        return YES;
    }else
    {
        NSString* cutString = @"";
        NSRange cutRange = {0, (MAX_LIMIT_NUMS - existLen)};
        
        //if text is ASC
        if([text canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            cutString = [text substringWithRange:cutRange];
        }else //it text is emoji or other symbols
        {
            __block NSInteger idx = 0;
            __block NSString* trimString = @"";
            
            //Ergodic the composed character(emoji/chinese character) in the string
            [text enumerateSubstringsInRange:NSMakeRange(0, text.length)
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:
             ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
             {
                 NSInteger steplen = substring.length;
                 if (idx >= cutRange.length)
                 {
                     *stop = YES;
                     return ;
                 }
                 
                 trimString = [trimString stringByAppendingString:substring];
                 
                 idx += steplen;
             }
             ];
            cutString = trimString;
        }
        NSLog(@"cutString:%@", cutString);
        
        [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:cutString]];
        [_countLabel setText:[NSString stringWithFormat:@"%u/%u", 0, MAX_LIMIT_NUMS]];
        
        MO_SHOW_FAIL(([NSString stringWithFormat:@"最多只能输入%u个字!", MAX_LIMIT_NUMS]));
        //return no here for that,the input should be cuted, so textViewDidChange will not be called
        return NO;
    }
    
    return YES;
}
#endif
