//
//  EditSpecialFilterChoose.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/27.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SpecialFilterChooseCallBack)(BOOL selected,MHFilterInfo * filterInfo);

@interface EditSpecialFilterChoose : UIView

/**
 特效滤镜选择
 @param videoPath 视频路径
 @param commonFilterInfo 已选 普通滤镜信息
 @param specialFilterInfo 已选 特效滤镜信息
 @param callBack 回调-是否选择，特效滤镜信息
 */
+(void)showWithVideoPath:(NSString *)videoPath commonFilter:(MHFilterInfo *)commonFilterInfo specialfilter:(MHFilterInfo *)specialFilterInfo callBack:(SpecialFilterChooseCallBack)callBack;

@end

