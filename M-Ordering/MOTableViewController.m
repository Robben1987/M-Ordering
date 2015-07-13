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
    //table data
    _groups = [NSMutableArray array];
    [self.dataCtrl.account toArray:_groups];
}

-(void)updateData:(id)data atRowIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* entry = [[_groups objectAtIndex:_selectedIndexPath.section] objectAtIndex:_selectedIndexPath.row];
    NSString* key = [entry.allKeys objectAtIndex:0];
    
    [entry setValue:data forKey:key];
    [self.dataCtrl.account updateInfo: entry];
    
    NSArray* indexPaths = @[_selectedIndexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark portraitImageView getter
-(UIImageView *)portraitImageView:(UIImage *)image;
{
    CGFloat w = MO_PORTRAIT_IMAGE_LEN, h = MO_PORTRAIT_IMAGE_LEN;
    CGFloat x = (self.view.frame.size.width - (MO_PORTRAIT_PADDING + w));
    CGFloat y = (MO_TABLEVIEW_IMAGE_CELL_HEIGHT - h)/2;
    UIImageView* portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [portraitImageView.layer setCornerRadius:(portraitImageView.frame.size.height/2)];
    [portraitImageView.layer setMasksToBounds:YES];
    [portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [portraitImageView setClipsToBounds:YES];
    portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    portraitImageView.layer.shadowOpacity = 0.5;
    portraitImageView.layer.shadowRadius = 2.0;
    //portraitImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    //portraitImageView.layer.borderWidth = 0.0f;
    portraitImageView.userInteractionEnabled = YES;
    portraitImageView.backgroundColor = [UIColor whiteColor];
    
    //UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    //[portraitImageView addGestureRecognizer:portraitTap];
    
    [portraitImageView setImage:image];
    
    return portraitImageView;
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
    static NSString* cellIdentifier = @"MOTableViewCellIdentifier";
    
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
    _selectedIndexPath = indexPath;
    
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
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
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
        UITextField *textField= [alertView textFieldAtIndex:0];

        [self updateData:textField.text atRowIndexPath:_selectedIndexPath];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isCameraAvailable]
           && [UIImagePickerController doesCameraSupportTakingPhotos])
        {
            UIImagePickerController* picker = [UIImagePickerController initWithSourceType:UIImagePickerControllerSourceTypeCamera andDelegate:self];
            if([UIImagePickerController isFrontCameraAvailable])
                [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            
            [self presentViewController:picker animated:YES completion:^(void){
                                 NSLog(@"Picker View Controller is presented");}];
        }
        
    }else if(buttonIndex == 1)
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
    UIImage* original = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    original = [UIImagePickerController imageScalingToMaxSize:original];
    
    CGRect frame = CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width);
    VPImageCropperViewController* cropper = [[VPImageCropperViewController alloc]
                                             initWithImage:original cropFrame:frame
                                             limitScaleRatio:3.0];
    cropper.delegate = self;
    [picker presentViewController:cropper animated:YES completion:^{
        // TO DO
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark VPImageCropperDelegate
-(void)imageCropper:(VPImageCropperViewController *)cropper didFinished:(UIImage *)editedImage
{
    [self updateData:editedImage atRowIndexPath:_selectedIndexPath];

    [cropper dismissViewControllerAnimated:NO completion: nil];
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
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

