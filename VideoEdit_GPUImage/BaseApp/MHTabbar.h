//
//  MHTabbar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTabbarView;

@interface MHTabbar : UITabBar

@property(nonatomic,strong)MHTabbarView * tabbarView;

@end

@protocol MHTabbarViewDelegate;
@interface MHTabbarView : UIView

@property(nonatomic,weak)id <MHTabbarViewDelegate> delegate;

/** 更新选中下标 item 状态 */
-(void)update_selectedIndex:(NSInteger)index;

@end

@protocol MHTabbarViewDelegate <NSObject>

@optional
-(void)mhTabBarView:(MHTabbarView *)tabbarView selectedIndex:(NSInteger)index;
-(void)mhTabBarViewCenterItemClick;

@end
