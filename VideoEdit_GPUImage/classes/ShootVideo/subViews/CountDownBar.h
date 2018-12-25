//
//  CountDownBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/22.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 倒计时选择回调-是否开启倒计时 暂停时间 */
typedef void(^CountDownCallBack)(BOOL needCountDown, CGFloat pauseTime);
/** 倒计时结束回调 */
typedef void(^CountDownTimerCallBack)(void);

@interface CountDownBar : UIView

/**
 倒计时选择界面
 @param curentLength 当前已录制时长
 @param callBack 回调-是否倒计时 暂停时间
 */
+(void)showWithCurentLength:(CGFloat)curentLength callBack:(CountDownCallBack)callBack;

@end




@interface CountDownTimer : UIView

+(void)showCounrDownTimerWIthCallBack:(CountDownTimerCallBack)callBack;

@end
