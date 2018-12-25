//
//  NSString+MHCommon.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import<CommonCrypto/CommonDigest.h>

@interface NSString (MHCommon)



- (NSString *) md5;

/**
 data转string
 @param data data
 @return str
 */
+(NSString *)dataDecode:(NSData *)data;

/**
 将数字转换为kb、mb、gb
 
 @param num num
 @return kb
 */
+(NSString *)changeSaveOnNum:(long long)num;

/**
 urlEncode
 @return urlEncode str
 */
-(NSString *)urlEncode;

/**
 是否包含emoji表情符号
 @return 是否包含emoji表情符号
 */
-(BOOL)containsEmoji;
/**
 根据字符串宽度及字体计算高度
 @param width 宽度
 @param textFont 字体
 @return height
 */
-(CGFloat)textForLabHeightWithTextWidth:(CGFloat)width font:(UIFont *)textFont;

/**
 根据字符串高度及字体计算宽度
 @param height 高度
 @param textFont 字体
 @return width
 */
-(CGFloat)textForLabWidthWithTextHeight:(CGFloat)height font:(UIFont *)textFont;

/**
 根据字体大小 宽度 字间距 行间距 计算文字所占高度
 @param textFont 字体
 @param width 宽度
 @param lineSpace 行间距
 @param keming 字间距
 @return 高度
 */
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming;
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent;

/**
 将字符串转化为带行间距字间距的attbutedStr
 @param textFont 字体
 @param textColor 字体颜色
 @param lineSpace 行间距
 @param keming 字间距
 @return attbutedStr
 */
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming;
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent;

/**
 将16进制转化为二进制
 @param hex 16进制字符
 @return 转换后的2进制字符
 */
+(NSString *)getBinaryByhex:(NSString *)hex;

@end
