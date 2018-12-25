//
//  MHSystemHelper.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/7.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "MHSystemHelper.h"

@implementation MHSystemHelper
#pragma mark - 获取主window
+ (UIWindow *)getKeyWindow
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    return keywindow;
}
#pragma mark - 获取设备名称
+ (NSString *)getDeviceName
{
    //    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])
        return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])
        return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])
        return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])
        return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])
        return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])
        return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])
        return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])
        return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])
        return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])
        return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])
        return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])
        return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])
        return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])
        return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])
        return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])
        return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])
        return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])
        return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])
        return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])
        return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])
        return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"])
        return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"])
        return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"])
        return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])
        return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"])
        return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])
        return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])
        return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])
        return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])
        return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])
        return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])
        return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])
        return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])
        return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])
        return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])
        return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])
        return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])
        return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])
        return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])
        return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])
        return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])
        return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])
        return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])
        return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])
        return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])
        return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])
        return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])
        return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])
        return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])
        return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])
        return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])
        return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])
        return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])
        return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])
        return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])
        return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])
        return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])
        return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])
        return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])
        return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])
        return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])
        return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])
        return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])
        return@"iPhone Simulator";
    
    return platform;
}
#pragma mark - 获取系统版本号
+ (NSString *)getSysVersion
{
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    return strSysVersion;
}
#pragma mark - app版本号
+(NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
#pragma mark - 获取设备UUID
+ (NSString *)getDeviceUUID
{
    //获取uuid，这个值每次从系统获取都会返回一个新的
    NSString * uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"k_user_phone_uuuuuuuuuid"];
    if (uuid && uuid.length > 0) {
        return uuid;
    }else{
        //uuid
        NSString * uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"k_user_phone_uuuuuuuuuid"];
        return uuid;
    }
}
#pragma mark - 获取设备分辨率
+(NSString *)getDeviceSize
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGSize size = rect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = size.width*scale;
    CGFloat height = size.height*scale;
    return [NSString stringWithFormat:@"%.f*%.f",width,height];
}
#pragma mark - 获取运营商信息
+ (NSString *)getTelephonyInfo
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobileCarrier;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobileCarrier = @"无运营商";
    }else{
        mobileCarrier = [carrier carrierName];
    }
    return mobileCarrier;
}
#pragma mark - 获取当前网络类型
+ (NSString *)getNetworkType
{
    NSString *network = @"";
    @try {
        UIApplication *app = [UIApplication sharedApplication];
        id statusBar = [app valueForKeyPath:@"statusBar"];
        
        BOOL isIphoneX = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
        if (isIphoneX) {
            //        iPhone X
            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
            
            NSArray *subviews = [[foregroundView subviews][2] subviews];
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    network = @"WIFI";
                }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                    network = [subview valueForKeyPath:@"originalText"];
                }
            }
        }else {
            //        非 iPhone X
            UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
            NSArray *subviews = [foregroundView subviews];
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                    int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                    switch (networkType) {
                        case 0:
                            network = @"";
                            break;
                        case 1:
                            network = @"2G";
                            break;
                        case 2:
                            network = @"3G";
                            break;
                        case 3:
                            network = @"4G";
                            break;
                        case 5:
                            network = @"WIFI";
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"cacheError=%@",exception);
    } @finally {
        
    }
    
    return network;
}
@end
