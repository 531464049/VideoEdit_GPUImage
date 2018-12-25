//
//  UIColor+MHMH.m
//  HzWeather
//
//  Created by 马浩 on 2018/8/28.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "UIColor+MHMH.h"

@implementation UIColor (MHMH)

+(UIColor *)random_Color
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+(UIColor *)base_color
{
    return [UIColor colorWithRed:20/255.0 green:20/255.0 blue:30/255.0 alpha:1.0];
}
+(UIColor *)base_yellow_color
{
    return [UIColor colorWithRed:242/255.0 green:194/255.0 blue:20/255.0 alpha:1.0];
}
@end
