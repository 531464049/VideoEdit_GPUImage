//
//  GPUImageVideoCameraEx.h
//  aikan
//
//  Created by lihejun on 14-1-13.
//  Copyright (c) 2014年 taobao. All rights reserved.
//
#import "GPUImage.h"
#import "GPUImageVideoCamera.h"

typedef enum {
    GPUImageVideoCaptureNone,
    GPUImageVideoCapturing,
    GPUImageVideoCapturePaused,
    GPUImageVideoCaptureStopped
}GPUImageVideoStatus;

/**
 支持闪关灯开启和关闭.
 */
@interface GPUImageVideoCameraEx : GPUImageVideoCamera
@property (nonatomic, assign, getter = isFlash)BOOL flash;
@property (nonatomic)GPUImageVideoStatus status;
@end
