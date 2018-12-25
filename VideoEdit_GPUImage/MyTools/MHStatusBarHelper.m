//
//  MHStatusBarHelper.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "MHStatusBarHelper.h"

@implementation MHStatusBarHelper

+(void)updateStatuesBarHiden:(BOOL)hiden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hiden withAnimation:UIStatusBarAnimationFade];
}
+ (void)updateStatuesBarStyleLight:(BOOL)light
{
    if (light) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}
@end
