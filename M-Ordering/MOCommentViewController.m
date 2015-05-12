//
//  MOCommentViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-5-12.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOCommentViewController.h"

@interface MOCommentViewController ()
{
    UITextView* _commentView;
    UIButton*   _publishButton;
}
@end

@implementation MOCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}

- (void)initSubView
{
    CGRect textFrame = CGRectMake(5, 75, (self.view.frame.size.width - 10), 200);
    CGRect buttonFrame = CGRectMake(5, 285, (self.view.frame.size.width - 10), 30);

    _commentView = [[UITextView alloc] initWithFrame:textFrame];
    [_commentView setBackgroundColor:[UIColor yellowColor]];
    //[_commentView setDelegate:self];
    [_commentView setReturnKeyType:UIReturnKeyDefault];
    [_commentView setKeyboardType:UIKeyboardTypeDefault];
    [_commentView setScrollEnabled:YES];
    [_commentView setAutoresizingMask: UIViewAutoresizingFlexibleHeight];
    //[_commentView]
    [self.view addSubview:_commentView];
    
    _publishButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [_publishButton setBackgroundColor:[UIColor blueColor]];
    [_publishButton setTitle:@"发布评论" forState:UIControlStateNormal];
    [self.view addSubview:_publishButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
