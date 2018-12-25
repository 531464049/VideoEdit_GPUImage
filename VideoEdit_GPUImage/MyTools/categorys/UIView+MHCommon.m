//
//  UIView+MHCommon.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "UIView+MHCommon.h"

@implementation UIView (MHCommon)
#pragma mark - 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}
-(void)mh_alertShowAnimation
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}
-(void)mh_alertHidenAnimation
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)]];
    popAnimation.keyTimes = @[@0.0f, @.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}
#pragma mark - 改变图层的AnchorPoint（中心点），位置不变
-(void)mh_setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}



- (UIImage*)captureViewframe:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float originX = frame.origin.x * image.scale;
    float originy = frame.origin.y * image.scale;
    float width = frame.size.width * image.scale;
    float height = frame.size.height * image.scale;
    //你需要的区域起点,宽,高;
    CGRect rect1 = CGRectMake(originX , originy , width , height);
    UIImage * imgeee = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect1)];
    
    return imgeee;
}


#pragma mark - view当前控制器
- (UIViewController*)curentViewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)mh_zoomAnimationFrom:(CGFloat)from to:(CGFloat)to
{
    [self mh_zoomAnimationFrom:from to:to time:0.2];
}
-(void)mh_zoomAnimationFrom:(CGFloat)from to:(CGFloat)to time:(CGFloat)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:from];
    animation.toValue=[NSNumber numberWithFloat:to];
    animation.duration=time;
    animation.autoreverses=NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"zoom"];
}

@end



@implementation UILabel (MHCommon)

+(UILabel *)labTextColor:(UIColor *)textColor font:(UIFont *)font aligent:(NSTextAlignment)aligent
{
    UILabel * lab = [[UILabel alloc] init];
    lab.textColor = textColor;
    lab.font = font;
    lab.textAlignment = aligent;
    lab.numberOfLines = 1;
    return lab;
}

@end


@implementation UIImage (MHCommon)

#pragma mark - 通过颜色值生产一张图片
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end


@implementation UIScrollView (MHCommon)

+ (void)load {
    if (@available(iOS 11.0, *)){
        //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
        [[self appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}
#pragma mark - iOS 11 开启/关闭contentInsetAdjustmentBehavior
+(void)mh_scrollOpenAdjustment:(BOOL)open
{
    if (@available(iOS 11.0, *)){
        if (open) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        } else {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}
-(void)mh_fixIphoneXBottomMargin
{
    BOOL isIphoneX = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
    if (isIphoneX) {
        UIEdgeInsets insets = self.contentInset;
        self.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + k_bottom_margin, insets.right);
    }
}
@end


@implementation UITextField (MHMH)

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range  // 备注：UITextField必须为第一响应者才有效
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}
@end
