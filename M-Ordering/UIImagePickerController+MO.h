//
//  UIImagePickerController+MO.h
//  M-Ordering
//
//  Created by Li Robben on 15-7-11.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (MO)

+(instancetype)initWithSourceType:(UIImagePickerControllerSourceType)type andDelegate:(id)delegate;

#pragma mark camera utility
+(BOOL)isCameraAvailable;
+(BOOL)isRearCameraAvailable;
+(BOOL)isFrontCameraAvailable;
+(BOOL)doesCameraSupportTakingPhotos;
+(BOOL)isPhotoLibraryAvailable;
+(BOOL)canUserPickVideosFromPhotoLibrary;
+(BOOL)canUserPickPhotosFromPhotoLibrary;
+(BOOL)cameraSupportMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType) paramSourceType;

//pragma mark Scaling And Cropping 缩放和裁剪
+(UIImage*)imageScalingToMaxSize:(UIImage *)sourceImage;
+(UIImage*)imageScalingAndCropping:(UIImage *)sourceImage toSize:(CGSize)targetSize;

@end
