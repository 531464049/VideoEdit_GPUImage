//
//  ShootFilterChooseView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFilter.h"

typedef void(^ShootFilterChooseCallBack)(MHFilterInfo * filterinfo,MHBeautifyInfo * beautifyInfo);
typedef void(^ShootFilterChooseHidenHandle)(void);

@interface ShootFilterChooseView : UIView

/**
 弹出滤镜选择窗口
 @param filterInfo 当前滤镜
 @param beautifyInfo 当前美颜信息
 @param callBack callback(滤镜信息+美颜信息)
 @param hidenHadle 退出回调
 */
+(void)showFilterWithFilterInfo:(MHFilterInfo *)filterInfo beautifyInfo:(MHBeautifyInfo *)beautifyInfo callBack:(ShootFilterChooseCallBack)callBack hidenHandle:(ShootFilterChooseHidenHandle)hidenHadle;

@end

