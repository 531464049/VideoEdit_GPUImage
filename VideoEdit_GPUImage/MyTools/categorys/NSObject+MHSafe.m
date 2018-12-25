//
//  NSObject+MHSafe.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSObject+MHSafe.h"

void MHSwizzlingMethod(Class cls, SEL origSEL, SEL newSEL)
{
    Method originMethod = class_getInstanceMethod(cls, origSEL);
    Method swizzledMethod = nil;
    
    if (!originMethod) {
        originMethod = class_getClassMethod(cls, origSEL);
        if (!originMethod) {
            return;
        }
        swizzledMethod = class_getClassMethod(cls, newSEL);
        if (!swizzledMethod) {
            return;
        }
    } else {
        swizzledMethod = class_getInstanceMethod(cls, newSEL);
        if (!swizzledMethod){
            return;
        }
    }
    
    if(class_addMethod(cls, origSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(cls, newSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

@implementation NSObject (MHSafe)

+(CGFloat )getCurentTimestamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    CGFloat curenttime = [[NSString stringWithFormat:@"%f", time] floatValue];
    return curenttime;
}
+(NSString *)getCurentTimeStr
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}
+ (BOOL)isNilOrEmpty:(id)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] && ([string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])) {
        return YES;
    }
    return NO;
}
+(NSString *)numToStr:(NSInteger)num
{
    if (num > 10000) {
        CGFloat wanNum = num/10000.0;
        return [NSString stringWithFormat:@"%.1fw",wanNum];
    }
    return [NSString stringWithFormat:@"%ld",num];
}
@end
