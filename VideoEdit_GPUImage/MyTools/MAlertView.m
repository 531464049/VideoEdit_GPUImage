//
//  MAlertView.m
//  GPUImage_mh
//
//  Created by 马浩 on 2018/10/29.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "MAlertView.h"

@implementation MAlertView

+(void)showAlertIn:(UIViewController *)vc msg:(NSString *)msg callBack:(void (^)(BOOL))callBack
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        callBack(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        callBack(YES);
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
+(void)showMsgIn:(UIViewController *)vc msg:(NSString *)msg
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end
