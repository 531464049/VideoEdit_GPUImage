//
//  CommonAppKey.h
//  HzWeather
//
//  Created by 马浩 on 2018/8/28.
//  Copyright © 2018年 马浩. All rights reserved.
//

#ifndef CommonAppKey_h
#define CommonAppKey_h

typedef enum : NSInteger  {
    MHShootSpeedTypeMoreSlow       = 0, //极慢
    MHShootSpeedTypeaSlow          = 1, //慢
    MHShootSpeedTypeNomal          = 2, //标准
    MHShootSpeedTypeFast           = 3, //快
    MHShootSpeedTypeMorefast       = 4, //极快
}MHShootSpeedType;//视频拍摄速度类型

typedef enum : NSInteger  {
    MHPostVideoOpenTypeOpen          = 0, //公开
    MHPostVideoOpenTypeOnlyFriend    = 1, //仅好友可见
    MHPostVideoOpenTypeUnOpen        = 2, //不公开
}MHPostVideoOpenType;//视频发布 公开类型

#endif /* CommonAppKey_h */
