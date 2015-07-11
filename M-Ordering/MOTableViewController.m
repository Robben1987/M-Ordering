//
//  MOTableViewController.m
//  M-Ordering
//
//  Created by Li Robben on 15-3-16.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "MOTableViewController.h"
#import "MOCommon.h"
#import "MOAccount.h"
#import "UIImagePickerController+MO.h"
#import "VPImageCropperViewController.h"

#define MO_TABLEVIEW_IMAGE_CELL_HEIGHT (70.0f)
#define MO_PORTRAIT_IMAGE_LEN (60.0f)
#define MO_PORTRAIT_PADDING (30.0f)


@interface MOTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate>
{
    NSMutableArray*     _groups;
    NSIndexPath*        _selectedIndexPath;
    
    UIImageView*        _portraitImageView;

}

@end

@implementation MOTableViewController

+(instancetype)initWithTitle:(NSString*)title type:(MOTableViewType)type dataCtrl:(MODataController*)dataCtrl
{
	UITableViewStyle style = UITableViewStyleGrouped;    
    
    MOTableViewController* viewCtrl = [[MOTableViewController alloc] initWithStyle:style];
    [viewCtrl setTitle:title];
    [viewCtrl setDataCtrl:dataCtrl];
    
    return viewCtrl;
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
    
    [self initTablesData];
}

-(void)initTablesData
{
    //1. table data
    _groups = [NSMutableArray array];
    [self.dataCtrl.account toArray:_groups];
    
    //2. portraitImageView
    //[self portraitImageView];
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView:(UIImage *)image;
{
    if (!_portraitImageView)
    {
        CGFloat w = MO_PORTRAIT_IMAGE_LEN, h = MO_PORTRAIT_IMAGE_LEN;
        CGFloat x = (self.view.frame.size.width - (MO_PORTRAIT_PADDING + w));
        CGFloat y = (MO_TABLEVIEW_IMAGE_CELL_HEIGHT - h)/2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView setImage:image];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        //_portraitImageView.layer.borderColor = [[UIColor blueColor] CGColor];
        //_portraitImageView.layer.borderWidth = 0.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        
        //UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        //[_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groups count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_groups[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return MO_TABLEVIEW_IMAGE_CELL_HEIGHT;
    }
    
    return MO_TABLEVIEW_CELL_HEIGHT;
}


#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MOTableCellIdentifier";
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if(indexPath.section == 0)
    {
        NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString* key = [entry.allKeys objectAtIndex:0];
        [cell.textLabel setText: key];
        [cell.contentView addSubview:[self portraitImageView: [entry objectForKey:key]]];
    }else
    {
        NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString* key = [entry.allKeys objectAtIndex:0];
        [cell.textLabel setText: key];
        [cell.detailTextLabel setText: [entry valueForKey:key]];
    }

    return cell;
}

-(CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.2f;
}

#pragma mark 点击行进入新页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath=indexPath;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UIActionSheet* Sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"拍照", @"从相册中选取", nil];
            [Sheet showInView:self.view];
        }
    }else
    {
		NSDictionary* entry = [[_groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		NSString* key = [entry.allKeys objectAtIndex:0];

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:key
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK", nil];
	    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	    UITextField* textField = [alert textFieldAtIndex:0];
	    [textField setText:[entry valueForKey:key]];
	    [alert show]; 
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
		NSMutableDictionary* entry = [[_groups objectAtIndex:_selectedIndexPath.section] objectAtIndex:_selectedIndexPath.row];
		NSString* key = [entry.allKeys objectAtIndex:0];

		UITextField *textField= [alertView textFieldAtIndex:0];
        [entry setValue:textField.text forKey:key];
        [self.dataCtrl.account updateInfo: entry];
        
        NSArray* indexPaths = @[_selectedIndexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if([UIImagePickerController isCameraAvailable] && [UIImagePickerController doesCameraSupportTakingPhotos])
        {
            UIImagePickerController* picker = [UIImagePickerController initWithSourceType:UIImagePickerControllerSourceTypeCamera andDelegate:self];
            if([UIImagePickerController isFrontCameraAvailable])
                [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            
            [self presentViewController:picker animated:YES completion:^(void){
                                 NSLog(@"Picker View Controller is presented");}];
        }
        
    } else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isPhotoLibraryAvailable])
        {
            UIImagePickerController* picker = [UIImagePickerController initWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary andDelegate:self];
            
            [self presentViewController:picker animated:YES completion:^(void){
                                 NSLog(@"Picker View Controller is presented");}];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage* original = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //_portraitImageView.image = original;
        original = [UIImagePickerController imageScalingToMaxSize:original];

        CGRect frame = CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width);
        VPImageCropperViewController* cropper = [[VPImageCropperViewController alloc]
                                                 initWithImage:original cropFrame:frame
                                                 limitScaleRatio:3.0];
        cropper.delegate = self;
        [self presentViewController:cropper animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark VPImageCropperDelegate
-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    _portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

-(void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

