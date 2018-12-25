//
//  NSObject+MHSafe.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface NSObject (MHSafe)

/**
 runtime 方法交换
 
 @param cls 类
 @param origSEL 原方法
 @param newSEL 替换的方法
 */
void MHSwizzlingMethod(Class cls, SEL origSEL, SEL newSEL);

/**
 获取当前时间戳
 @return 当前时间戳
 */
+(CGFloat )getCurentTimestamp;


/**
 获取当前时间字符串
 @return 当前时间str类型
 */
+(NSString *)getCurentTimeStr;

/** 判断给定对象是否为空
 *
 * @param string 对象
 * @return 是否为空
 *
 */
+ (BOOL)isNilOrEmpty:(id)string;

+(NSString *)numToStr:(NSInteger)num;
@end
