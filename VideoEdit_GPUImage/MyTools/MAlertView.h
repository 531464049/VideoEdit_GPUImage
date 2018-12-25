//
//  MAlertView.h
//  GPUImage_mh
//
//  Created by 马浩 on 2018/10/29.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MAlertView : NSObject

+(void)showAlertIn:(UIViewController *)vc msg:(NSString *)msg callBack:(void(^)(BOOL sure))callBack;

+(void)showMsgIn:(UIViewController *)vc msg:(NSString *)msg;

@end

