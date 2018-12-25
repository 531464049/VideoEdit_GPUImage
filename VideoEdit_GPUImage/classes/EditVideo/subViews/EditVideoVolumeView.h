//
//  EditVideoVolumeView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoVolumeEditCallBack)(CGFloat originalVolume,CGFloat bgmVolume);

@interface EditVideoVolumeView : UIView

+(void)showHasBGM:(BOOL)hasBGM originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume callBack:(VideoVolumeEditCallBack)callBack;

@end

