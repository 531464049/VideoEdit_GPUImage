//
//  NSString+MHCommon.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSString+MHCommon.h"

@implementation NSString (MHCommon)

+(NSString *)dataDecode:(NSData *)data
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSArray *arrEncoding = @[@(NSUTF8StringEncoding),@(gbkEncoding)];
    
    for (int i = 0 ; i < [arrEncoding count]; i++) {
        unsigned long encodingCode = [arrEncoding[i] unsignedLongValue];
        NSString *results = [[NSString alloc] initWithData:data encoding:encodingCode];
        if (results) {
            return results;
        }
    }
    return nil;
}

#pragma mark - 将B装换为kb、mb、gb
+(NSString *)changeSaveOnNum:(long long)num
{
    if (num < 1024) {//少于1kb
        return @"0KB";
    }else if (num/1024.0 < 1024) {//少于MB
        CGFloat kbnum = num / 1024.0;
        return [NSString stringWithFormat:@"%.1fKB",kbnum];
    }else if (num/1024.0/1024.0 < 1024) {//少于GB
        CGFloat mbnum = num / 1024.0 / 1024.0;
        return [NSString stringWithFormat:@"%.1fMB",mbnum];
    }else{
        CGFloat gbnum = num / 1024.0 / 1024.0 / 1024.0;
        return [NSString stringWithFormat:@"%.1fGB",gbnum];
    }
}
#pragma mark - urlEncode
-(NSString *)urlEncode
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString *) md5 {
    const char *fooData = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    NSMutableString *saveResult = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}
#pragma mark - 检查字符串是否包含emoji
- (BOOL)containsEmoji
{
    __block BOOL contain = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if ([substring isEmoji]) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    return contain;
}
#pragma mark - 检查一个‘字符’是否是emoji表情
- (BOOL)isEmoji
{
    if (self.length <= 0) {
        return NO;
    }
    unichar first = [self characterAtIndex:0];
    switch (self.length) {
        case 1:
        {
            if (first == 0xa9 || first == 0xae || first == 0x2122 ||
                first == 0x3030 || (first >= 0x25b6 && first <= 0x27bf) ||
                first == 0x2328 || (first >= 0x23e9 && first <= 0x23fa)) {
                return YES;
            }
        }
            break;
            
        case 2:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x203c && first <= 0x3299) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        }
            break;
            
        case 3:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x23 && first <= 0x39) {
                    return YES;
                }
            }
            else if (c == 0xd83c) {
                if (first == 0x26f9 || first == 0x261d || (first >= 0x270a && first <= 0x270d)) {
                    return YES;
                }
            }
            if (first == 0xd83c) {
                return YES;
            }
        }
            break;
            
        case 4:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xd83c) {
                if (first == 0x261d || first == 0x270c) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        }
            break;
            
        case 5:
        {
            if (first == 0xd83d) {
                return YES;
            }
        }
            break;
            
        case 8:
        case 11:
        {
            if (first == 0xd83d) {
                return YES;
            }
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}
#pragma mark - 根据字体及宽度计算文字高度 无行间距字间距
-(CGFloat)textForLabHeightWithTextWidth:(CGFloat)width font:(UIFont *)textFont
{
    NSDictionary *attrs = @{NSFontAttributeName : textFont};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return rect.size.height;
}
#pragma mark - 根据字体及高度计算文字宽度 无行间距字间距
-(CGFloat)textForLabWidthWithTextHeight:(CGFloat)height font:(UIFont *)textFont
{
    NSDictionary *attrs = @{NSFontAttributeName : textFont};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return rect.size.width;
}
#pragma mark - 根据字体及宽度计算文字宽度 行间距字间距
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming
{
    return [self textHeight:textFont width:width lineSpace:lineSpace keming:keming aligent:NSTextAlignmentLeft];
}
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent
{
    if (self.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = aligent;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(keming)};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGFloat height = size.height;
    if (height == textFont.lineHeight + lineSpace) {
        height = textFont.lineHeight;
    }
    
    return size.height;
}
#pragma mark - 转化为带行间距 字间距的attbutedStr
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming
{
    return [self attributedStr:textFont textColor:textColor lineSpace:lineSpace keming:keming aligent:NSTextAlignmentLeft];
}
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.alignment = aligent;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(keming)};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    
    return attributeStr;
}
#pragma mark - 将16进制转化为二进制
+(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic;
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSString *binaryString=[[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        NSString * strLast =[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,strLast];
        
    }
    return binaryString;
    
}
@end
