//
//  MHTabbar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "MHTabbar.h"

@implementation MHTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tabbarView];
        
        self.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(Screen_WIDTH, TabBarHeight)];
        [self setShadowImage:[UIImage imageWithColor:[UIColor lightTextColor] size:CGSizeMake(Screen_WIDTH, 0.5)]];

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置 tabBarView 的 frame
    self.tabbarView.frame = self.bounds;
    // 把 tabBarView 带到最前面，覆盖 tabBar 的内容
    [self bringSubviewToFront:self.tabbarView];
}
- (MHTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[MHTabbarView alloc] initWithFrame:self.bounds];
    }
    return _tabbarView;
}

@end


@implementation MHTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor base_color];
        [self buildSubViews];
    }
    return self;
}
-(void)buildSubViews
{
    CGFloat itemWidth = Screen_WIDTH/5;
    CGFloat itemHeight = TabBarHeight - k_bottom_margin;
    CGFloat lineWidth = Width(36);
    NSArray * titleArr = @[@"首页",@"关注",@"",@"消息",@"我"];
    for (int i = 0; i < 5; i ++) {
        UIView * item = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, itemHeight)];
        [self addSubview:item];
        
        //毛玻璃
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = item.bounds;
//        [item addSubview:effectView];
        
        
        UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentCenter];
        lab.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        lab.text = titleArr[i];
        lab.tag = 1000 + i;
        [item addSubview:lab];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(itemWidth/2 - lineWidth/2, itemHeight-2, lineWidth, 2)];
        line.backgroundColor = [UIColor whiteColor];
        line.layer.cornerRadius = 1;
        line.layer.masksToBounds = YES;
        line.tag = 2000 + i;
        [item addSubview:line];
        line.hidden = YES;
        
        if (i == 2) {
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(40), Width(28))];
            img.center = CGPointMake(itemWidth/2, itemHeight/2);
            img.image = [UIImage imageNamed:@"tabbar_post"];
            [item addSubview:img];
        }
        
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        btn.tag = 3000 + i;
        [btn addTarget:self action:@selector(item_click:) forControlEvents:UIControlEventTouchUpInside];
        [item addSubview:btn];
    }

}
- (void)update_selectedIndex:(NSInteger)index
{
    for (int i = 0; i < 5; i ++) {
        UILabel * lab = (UILabel *)[self viewWithTag:1000 + i];
        UIView * line = (UIView *)[self viewWithTag:2000 + i];
        if (i == 2) {
            //中心 点
            line.hidden = YES;
        }else{
            //其他
            if (i == index) {
                lab.textColor = [UIColor whiteColor];
                lab.font = FONT(16);
                line.hidden = NO;
            }else{
                lab.textColor = [UIColor grayColor];
                lab.font = FONT(14);
                line.hidden = YES;
            }
        }
        
    }
}
-(void)item_click:(UIButton *)sender
{
    NSInteger tag = sender.tag - 3000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mhTabBarView:selectedIndex:)]) {
        [self.delegate mhTabBarView:self selectedIndex:tag];
    }

}
@end
