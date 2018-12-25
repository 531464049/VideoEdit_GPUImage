//
//  NSArray+MHSafe.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/10.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+MHSafe.h"
@interface NSArray (MHSafe)

@end


@interface NSMutableArray (MHSafe)

-(void)safe_addObject:(id)obj;

@end
