//
//  ShootMusicBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShootMusicBar : UIView
/* 不想写代理或者block了，直接把点击按钮暴露出去，外界添加点击事件 */
@property(nonatomic,strong)UIButton * chooseMusicBtn;
/** 是否可用 */
@property(nonatomic,assign)BOOL barCanUse;

/** 更新选中的音乐名 */
-(void)updateChooseMusicName:(NSString *)musicName;

@end
