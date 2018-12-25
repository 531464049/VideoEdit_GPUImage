//
//  EditChooseCoverView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoCoverChooseCallBack)(BOOL selectedCover,CGFloat coverLocation);

@interface EditChooseCoverView : UIView


/**
 封面选择
 @param videoPath 视频路径
 @param curentCoverlocation 当前封面位置
 @param commonFilter 视频添加的普通滤镜
 @param specialFilter 视频添加的特殊滤镜
 @param callBack 回调-是否选择封面位置，选择的位置
 */
+(void)showCoverWithVideoPath:(NSString *)videoPath curentCoverLocation:(CGFloat)curentCoverlocation commonFilter:(GPUImageOutput<GPUImageInput> *)commonFilter specialfilter:(GPUImageOutput<GPUImageInput> *)specialFilter callBacl:(VideoCoverChooseCallBack)callBack;

@end

