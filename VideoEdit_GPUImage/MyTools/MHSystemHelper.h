//
//  MHSystemHelper.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/7.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface MHSystemHelper : NSObject

/**
 获取主window
 @return 主window
 */
+(UIWindow *)getKeyWindow;

/**
 获取设备名称
 @return 设备名称
 */
+ (NSString *)getDeviceName;

/**
 获取系统版本号
 @return 系统版本号
 */
+ (NSString *)getSysVersion;

/**
 获取app版本号
 @return app版本号
 */
+(NSString *)getAppVersion;


/**
 获取设备分辨率
 @return 设备分辨率
 */
+(NSString *)getDeviceSize;

/**
 获取设备UUID
 @return 设备UUID
 */
+ (NSString *)getDeviceUUID;

/**
 获取运营商信息
 @return 运营商信息
 */
+ (NSString *)getTelephonyInfo;

/**
 获取当前网络类型

 @return 当前网络类型
 */
+ (NSString *)getNetworkType;
@end
