//
//  MHHUD.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHHUD.h"

@implementation MHHUD

+(UIWindow *)theKeyWindow
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    return keywindow;
}

+(void)showTips:(NSString *)tips
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[self theKeyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[self theKeyWindow] animated:YES];
    }
    
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.text = tips;
    hud.contentColor = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:1.5];
}
+(void)showLoading
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[self theKeyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[self theKeyWindow] animated:YES];
    }
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor redColor];
}
+(void)finishedLoading
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[self theKeyWindow]];
    if (hud) {
        [hud hideAnimated:YES];
    }
}
+(void)showError:(NSString *)errorMsg
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[self theKeyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[self theKeyWindow] animated:YES];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.label.text = errorMsg;
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}
+(void)showSuccess
{
    [self showSuccessWithMsg:nil];
}
+(void)showSuccessWithMsg:(NSString *)msg
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[self theKeyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[self theKeyWindow] animated:YES];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.square = YES;
    
    if (msg && msg.length > 0) {
        hud.label.text = msg;
    }
    
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:1.5];
}

@end
