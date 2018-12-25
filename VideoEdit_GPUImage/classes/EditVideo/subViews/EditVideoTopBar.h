//
//  EditVideoTopBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditVideoTopBarDelelate;
@interface EditVideoTopBar : UIView

@property(nonatomic,weak)id <EditVideoTopBarDelelate> delegate;

/** 更新剪音乐按钮是否可用 */
-(void)updateCrapBGMItemCanUse:(BOOL)canUse;

@end


@protocol EditVideoTopBarDelelate <NSObject>

@optional
/** 返回按钮点击 回调 */
-(void)editVideoTopBarBackItemHandle;
/** 剪音乐 按钮回调 */
-(void)editVideoTopBarCrapBGMHandle;
/** 音量调整 按钮回调 */
-(void)editVideoTopBarVolumeHandle;
/** 选音乐 按钮回调 */
-(void)editVideoTopBarChooseBGMHandle;

@end
