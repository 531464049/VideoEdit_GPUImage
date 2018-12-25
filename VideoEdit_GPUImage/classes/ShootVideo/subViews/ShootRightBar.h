//
//  ShootRightBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShootRightBarSelTypeBackFront,      /** 切换前后摄像头 */
    ShootRightBarSelTypeFastSlow,       /** 快慢速 */
    ShootRightBarSelTypeShowBeautify,   /** 美化 */
    ShootRightBarSelTypeTimer,          /** 倒计时 */
    ShootRightBarSelTypeCripMusic,      /** 裁剪音乐 */
    ShootRightBarSelTypeTorchMode       /** 闪光灯 */
}ShootRightBarSelType;

@protocol ShootRightBarDelegate;

@interface ShootRightBar : UIView

@property(nonatomic,weak)id <ShootRightBarDelegate> delegate;

/** 设置裁剪音乐按钮显示状态 */
-(void)updateCrapMusicItemShow:(BOOL)show;
/** 更新前后置摄像头状态 */
-(void)updateVaptureDivicePosition:(AVCaptureDevicePosition)position;
/** 更新闪光灯状态*/
-(void)updateTouchModeState:(AVCaptureTorchMode)torchMode;
/** 更新是否是拍摄照片模式 */
-(void)updateIsTakePhotoState:(BOOL)isTakePhoto;


@end

@protocol ShootRightBarDelegate <NSObject>

@optional
-(void)shootRightBarHandle_changeBackFront;
-(void)shootRightBarHandle_showFastSlow;
-(void)shootRightBarHandle_showBeautify;
-(void)shootRightBarHandle_showTimer;
-(void)shootRightBarHandle_showCripMusic;
-(void)shootRightBarHandle_torchMode;

@end
