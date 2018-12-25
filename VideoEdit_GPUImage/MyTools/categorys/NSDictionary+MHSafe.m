//
//  NSDictionary+MHSafe.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSDictionary+MHSafe.h"

@implementation NSDictionary (MHSafe)

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        MHSwizzlingMethod(objc_getClass("__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), @selector(__mh__initWithObjects:forKeys:count:));
    });
}
//防止空值
- (instancetype)__mh__initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            rightCount++;
        }
    }
    return [self __mh__initWithObjects:objects forKeys:keys count:rightCount];
}
-(BOOL)containsKey:(NSString *)key
{
    if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0) {
        return NO;
    }
    return [self.allKeys containsObject:key];
}
@end





@implementation NSMutableDictionary (MHSafe)

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        MHSwizzlingMethod(objc_getClass("__NSDictionaryM"), @selector(removeObjectForKey:), @selector(__mh__Mutable_removeObjectForKey:));
        
        MHSwizzlingMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:), @selector(__mh__Mutable_setObject:forKey:));
    });
}
- (void)__mh__Mutable_removeObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    [self __mh__Mutable_removeObjectForKey:aKey];
}

- (void)__mh__Mutable_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || !aKey) {
        return;
    }
    return [self __mh__Mutable_setObject:anObject forKey:aKey];
}

@end
