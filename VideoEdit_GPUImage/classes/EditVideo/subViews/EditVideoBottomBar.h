//
//  EditVideoBottomBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditVideoBottomBar;

@interface EditVideoBottomBar : UIView

@property(nonatomic,weak)id <EditVideoBottomBar> delegate;

@end


@protocol EditVideoBottomBar <NSObject>

@optional
/** 下一步 回调 */
-(void)editVideoBottomBarHandleNextStep;
/** 特效 回调 */
-(void)editVideoBottomBarHandleSpecialFilter;
/** 选封面 回调 */
-(void)editVideoBottomBarHandleChooseCover;
/** 滤镜 回调 */
-(void)editVideoBottomBarHandleCommonFilter;

@end
