//
//  UIView+MHCommon.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (MHCommon)

/**
 判断View是否显示在屏幕上
 @return view是否显示在屏幕上
 */
- (BOOL)isDisplayedInScreen;
/**
 模拟系统alert弹出动画
 */
-(void)mh_alertShowAnimation;
-(void)mh_alertHidenAnimation;

/** 改变图层的AnchorPoint（中心点），位置不变 */
-(void)mh_setAnchorPoint:(CGPoint)anchorPoint;

- (UIImage*)captureViewframe:(CGRect)frame;

/**
 获取view当前的控制器
 @return vc
 */
- (UIViewController*)curentViewController;
/**
 view缩放动画
 
 @param from from
 @param to to
 */
-(void)mh_zoomAnimationFrom:(CGFloat)from to:(CGFloat)to;

/**
 view缩放动画
 
 @param from from
 @param to to
 @param time time
 */
-(void)mh_zoomAnimationFrom:(CGFloat)from to:(CGFloat)to time:(CGFloat)time;

@end


@interface UILabel (MHCommon)

+(UILabel *)labTextColor:(UIColor *)textColor font:(UIFont *)font aligent:(NSTextAlignment)aligent;

@end


@interface UIImage (MHCommon)
/**
 通过尺寸及颜色生成图片
 @param color 颜色
 @param size 尺寸
 @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@interface UIScrollView (MHCommon)

/**
 iOS 11 开启/关闭contentInsetAdjustmentBehavior
 
 @param open 开启/关闭contentInsetAdjustmentBehavior
 */
+(void)mh_scrollOpenAdjustment:(BOOL)open;
-(void)mh_fixIphoneXBottomMargin;
@end


@interface UITextField (MHMH)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;
@end
