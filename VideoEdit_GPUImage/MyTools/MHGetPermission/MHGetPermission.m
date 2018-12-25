//
//  MHGetPermission.m
//  NHZGame
//
//  Created by MH on 2017/7/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "MHGetPermission.h"
#import <Photos/Photos.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation MHGetPermission

#pragma mark - 相册权限
+(void)getPhotosPermission:(void(^)(BOOL has))callBack
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined://未决定
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {//用户拒绝
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(NO);
                    });
                }else{//用户同意
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(YES);
                    });
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted://这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(NO);
            });
        }
            break;
        case AVAuthorizationStatusAuthorized://已经授权过
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(YES);
            });
        }
            break;
        case AVAuthorizationStatusDenied://用户已经明确否认了这个应用程序访问图片数据
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(NO);
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark - 相机权限
+(void)getCaptureDevicePermission:(void(^)(BOOL has))callBack
{
    AVAuthorizationStatus  authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined://未决定状态
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {//同意？？
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(YES);
                    });
                }else{//拒绝
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(NO);
                    });
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted://这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(NO);
            });
        }
            break;
        case AVAuthorizationStatusAuthorized://已经授权过
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(YES);
            });
        }
            break;
        case AVAuthorizationStatusDenied://用户已经明确否认了这个应用程序访问图片数据
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(NO);
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark - 麦克风权限
+(void)getAudioRecordPermission:(void(^)(BOOL has))callBack
{
    AVAudioSessionRecordPermission status = [[AVAudioSession sharedInstance]recordPermission];
    switch (status) {
        case AVAudioSessionRecordPermissionUndetermined://未决定状态
        {
            [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack(NO);
                    });
                }
            }];
        }
            break;
        case AVAudioSessionRecordPermissionDenied://用户已经拒绝过了
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(NO);
            });
        }
            break;
        case AVAudioSessionRecordPermissionGranted://已经授权过了
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(YES);
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark - 同时获取相机+录音权限
+(void)getCaptureAndRecodPermission:(void (^)(BOOL, BOOL))callBack
{
    [MHGetPermission getCaptureDevicePermission:^(BOOL has) {
        if (has) {
            [MHGetPermission getAudioRecordPermission:^(BOOL has) {
                callBack(YES,has);
            }];
        }else{
            callBack(NO,NO);
        }
    }];
}
#pragma mark - 获取通讯录权限
+(void)getAddressBookPermission:(void (^)(BOOL))callBack
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        //未决定状态
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(granted);
            });
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(status == kABAuthorizationStatusAuthorized);
        });
    }
}
@end
