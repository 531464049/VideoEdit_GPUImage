//
//  ShootProgressBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShootProgressBar : UIView

@property(nonatomic,assign,readonly)CGFloat shootProgress;//当前进度

/** 更新进度 */
-(void)updateShootPregress:(CGFloat)progress;

/** w暂停/停止拍摄时 添加一个分割点 */
-(void)addSpecItem;
/** 删除上一个分割点 */
-(void)removeLastSpecItem;

@end

