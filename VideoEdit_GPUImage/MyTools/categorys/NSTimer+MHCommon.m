//
//  NSTimer+MHCommon.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSTimer+MHCommon.h"

@implementation NSTimer (MHCommon)

- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

+ (NSTimer *)wy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block {
    
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(timeFired:) userInfo:block repeats:yesOrNo];
}

+ (void)timeFired:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}

@end
