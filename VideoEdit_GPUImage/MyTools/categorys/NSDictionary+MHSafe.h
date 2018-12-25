//
//  NSDictionary+MHSafe.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+MHSafe.h"

@interface NSDictionary (MHSafe)

/**
 是否存在kay
 @param key key
 @return key是否存在
 */
-(BOOL)containsKey:(NSString *)key;

@end


@interface NSMutableDictionary (MHSafe)

@end
