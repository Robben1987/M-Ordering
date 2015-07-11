//
//  UIImagePickerController+MO.m
//  M-Ordering
//
//  Created by Li Robben on 15-7-11.
//  Copyright (c) 2015年 Li Robben. All rights reserved.
//

#import "UIImagePickerController+MO.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define MO_ORIGINAL_MAX_WIDTH (640.0f)

@implementation UIImagePickerController (MO)


+(instancetype)initWithSourceType:(UIImagePickerControllerSourceType)type andDelegate:(id)delegate
{
    UIImagePickerController* ctrl = [[UIImagePickerController alloc] init];
    [ctrl setSourceType:type];
    [ctrl setDelegate:delegate];
    [ctrl setMediaTypes:[NSMutableArray arrayWithObjects:(__bridge NSString *)kUTTypeImage, nil]];
    
    return ctrl;
}

#pragma mark camera utility
+(BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+(BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+(BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+(BOOL)doesCameraSupportTakingPhotos
{
    return [UIImagePickerController cameraSupportMedia:(__bridge NSString*)kUTTypeImage
                                            sourceType:UIImagePickerControllerSourceTypeCamera];
}

+(BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+(BOOL)canUserPickVideosFromPhotoLibrary
{
    return [UIImagePickerController cameraSupportMedia:(__bridge NSString*)kUTTypeMovie
                                            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+(BOOL)canUserPickPhotosFromPhotoLibrary
{
    return [UIImagePickerController cameraSupportMedia:(__bridge NSString*)kUTTypeImage
                                            sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+(BOOL)cameraSupportMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0)
    {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType])
        {
            result = YES;
            *stop= YES;
        }
    }];
    
    return result;
}

//pragma mark Scaling And Cropping 缩放和裁剪
+(UIImage*)imageScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < MO_ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if(sourceImage.size.width > sourceImage.size.height)
    {
        btHeight = MO_ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (MO_ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    }else
    {
        btWidth = MO_ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (MO_ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [UIImagePickerController imageScalingAndCropping:sourceImage toSize:targetSize];
}

+(UIImage*)imageScalingAndCropping:(UIImage *)sourceImage toSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if(widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
