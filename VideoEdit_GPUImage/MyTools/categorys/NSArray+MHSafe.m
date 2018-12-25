//
//  NSArray+MHSafe.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSArray+MHSafe.h"

@implementation NSArray (MHSafe)
+(void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        
        MHSwizzlingMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:), @selector(__mh__objectAtIndex:));
        MHSwizzlingMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:), @selector(__mh__singleObjectAtIndex:));
        MHSwizzlingMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(__mh__objectAtIndexedSubscript:));
        MHSwizzlingMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:), @selector(__mh__arr0ObjectAtIndex:));
        
    });
}
- (id)__mh__objectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__objectAtIndex:index];
}
- (id)__mh__singleObjectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__singleObjectAtIndex:index];
}
- (id)__mh__arr0ObjectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__arr0ObjectAtIndex:index];
}
- (id)__mh__objectAtIndexedSubscript:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__objectAtIndexedSubscript:index];
}
@end





@implementation NSMutableArray (MHSafe)
+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{  //方法交换只要一次就好
        MHSwizzlingMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:), @selector(__mh__objectAtIndex:));
        MHSwizzlingMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(__mh__objectAtIndexedSubscript:));
        
        MHSwizzlingMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:), @selector(__mh__Mutable_insertObject:atIndex:));
        
        MHSwizzlingMethod(objc_getClass("__NSArrayM"), @selector(removeObjectsInRange:), @selector(__mh__Mutable_removeObjectsInRange:));
        
        MHSwizzlingMethod(objc_getClass("__NSArrayM"), @selector(removeObject:inRange:), @selector(__mh__Mutable_removeObject:inRange:));
    });
}
- (void)__mh__Mutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count || range.length > self.count || (range.location + range.length) > self.count || !anObject) {
        return;
    }
    return [self __mh__Mutable_removeObject:anObject inRange:range];
}
- (void)__mh__Mutable_removeObjectsInRange:(NSRange)range {
    if (range.location > self.count || range.length > self.count || (range.location + range.length) > self.count) {
        return;
    }
    return [self __mh__Mutable_removeObjectsInRange:range];
}
- (void)__mh__Mutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count || !anObject) {
        return;
    }
    [self __mh__Mutable_insertObject:anObject atIndex:index];
}
- (id)__mh__objectAtIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__objectAtIndex:index];
}
- (id)__mh__objectAtIndexedSubscript:(NSUInteger)index{
    if (index > self.count - 1 || !self.count){
        return nil;
    }
    return [self __mh__objectAtIndexedSubscript:index];
}
-(void)safe_addObject:(id)obj
{
    if (obj && ![obj isKindOfClass:[NSNull class]]) {
        [self addObject:obj];
    }
}
@end
