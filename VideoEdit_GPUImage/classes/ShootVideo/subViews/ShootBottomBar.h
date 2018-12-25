//
//  ShootBottomBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MHShootTypeTakePhoto              = -1,   //拍照模式
    MHShootTypeSingTapTakeVideo       = 0,    //单击 拍摄视频模式
    MHShootTypeLongPressTakeVideo     = 1     //长按 拍摄视频模式
}MHShootType;//拍摄类型

@class ShootTypeBar;
@protocol ShootTypeBarDelegate;
@protocol ShootBottomBarDelegate;

#pragma mark - 底部按钮集合
@interface ShootBottomBar : UIView
/** 当前拍摄类型 只读 */
@property(nonatomic,assign,readonly)MHShootType shootType;
/** delegate */
@property(nonatomic,weak)id <ShootBottomBarDelegate> delegate;

/** 是否在拍摄视频过程 当在拍摄过程,不能切换到拍照模式 */
@property(nonatomic,assign)BOOL isRecodVideoProgress;

/** 开始录制动画 */
- (void)startShootBtnAnimation;

/** 结束录制动画 */
- (void)stopShootBtnAnimation;

/** 更新拍摄视频状态 是否在拍摄 */
- (void)updateRecodeState:(BOOL)isRecoding;

/** 更新删除 完成 按钮可用/显示状态 */
-(void)updateDeleteFinisheCanUse:(BOOL)canUse;

@end

#pragma mark - 底部按钮集合 回调
@protocol ShootBottomBarDelegate <NSObject>

@optional
/** 拍摄方式变更 */
-(void)shootBottomBarHandle_takeTypeChange:(MHShootType)shootType;
/** 拍照 */
-(void)shootBottomBarHandle_takePhoto;
/** 开始视频录制 */
-(void)shootBottomBarHandle_startRecode;
/** 结束视频录制 */
-(void)shootBottomBarHandle_endRecode;
/** 删除上一段视频 */
-(void)shootBottomBarHandle_deleateLastVideo;
/** 确认使用视频 */
-(void)shootBottomBarHandle_sureUseVideo;
/** 从相册选择 */
-(void)shootBottomBarHandle_chooseFromAlbum;

@end



#pragma mark - 底部拍摄类型bar
@interface ShootTypeBar : UIView

@property(nonatomic,weak)id <ShootTypeBarDelegate> delegate;
/** 是否可以选择拍照模式 */
@property(nonatomic,assign)BOOL canChangeToTakePhoto;

@end

#pragma mark - 拍摄类型代理方法
@protocol ShootTypeBarDelegate <NSObject>

/** 拍摄类型bar 切换类型回调代理 */
-(void)shootTypeBar:(ShootTypeBar *)bar selectedIndex:(NSInteger)index;

@end
