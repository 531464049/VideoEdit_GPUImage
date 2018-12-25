//
//  ShootFilterChooseView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ShootFilterChooseView.h"
#import "FilterChooseView.h"//滤镜选择view
#import "BeautifySlideView.h"//美颜参数view

@interface ShootFilterChooseView ()<FilterChooseViewDelegate,BeautifySlideDelegate>

@property(nonatomic,strong)MHFilterInfo * filterInfo;//当前滤镜信息
@property(nonatomic,strong)MHBeautifyInfo * beautifyInfo;//当前美颜信息
@property(nonatomic,copy)ShootFilterChooseCallBack callBack;//选中滤镜-美颜修改 回调
@property(nonatomic,copy)ShootFilterChooseHidenHandle hidenHandle;//退出 回调

@property(nonatomic,strong)UIView * contentView;//黑色容器
@property(nonatomic,assign)NSInteger curentBottomIndex;//当前底部切换选中下标
@property(nonatomic,strong)FilterChooseView * filterChooseView;//滤镜选择view
@property(nonatomic,strong)BeautifySlideView * beautifySlideView;//美颜参数view

@end

@implementation ShootFilterChooseView
- (instancetype)initWithFrame:(CGRect)frame filterInfo:(MHFilterInfo *)filterinfo beautiFy:(MHBeautifyInfo *)beautifyInfo callBack:(ShootFilterChooseCallBack)callback hidenHandle:(ShootFilterChooseHidenHandle)hidenHandle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.filterInfo = filterinfo;
        self.beautifyInfo = beautifyInfo;
        self.callBack = callback;
        self.hidenHandle = hidenHandle;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    //遮罩-点击退出
    UIControl * hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    hidenControl.backgroundColor = [UIColor clearColor];
    [hidenControl addTarget:self action:@selector(hiden_hiden_hidne) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hidenControl];
    
    //黑色毛玻璃 容器
    //45+110+50
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH, Screen_WIDTH, Width(205) + k_bottom_margin)];
    [self addSubview:self.contentView];
    
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.contentView.bounds;
    [self.contentView addSubview:effectView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    //底部切换按钮
    {
        UIView * bottomBar = [[UIView alloc] init];
        [self.contentView addSubview:bottomBar];
        bottomBar.sd_layout.leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, k_bottom_margin).rightSpaceToView(self.contentView, 0).heightIs(Width(50));
        
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [UIButton buttonWithType:0];
            [btn setTitle:i == 0 ? @"滤镜" : @"美颜" forState:0];
            btn.titleLabel.font = FONT(15);
            btn.tag = 4500 + i;
            [btn addTarget:self action:@selector(bottomItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomBar addSubview:btn];
            btn.sd_layout.leftSpaceToView(bottomBar, Screen_WIDTH/2*i).topSpaceToView(bottomBar, 0).widthIs(Screen_WIDTH/2).bottomSpaceToView(bottomBar, 0);
        }
        
        UIView * topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor whiteColor];
        [bottomBar addSubview:topLine];
        topLine.sd_layout.leftSpaceToView(bottomBar, 0).topSpaceToView(bottomBar, 0).rightSpaceToView(bottomBar, 0).heightIs(0.5);
        
        UIView * centerLine = [[UIView alloc] init];
        centerLine.backgroundColor = [UIColor whiteColor];
        [bottomBar addSubview:centerLine];
        centerLine.sd_layout.centerXEqualToView(bottomBar).centerYEqualToView(bottomBar).widthIs(0.5).heightRatioToView(bottomBar, 0.5);
    }

    //默认选择滤镜
    self.curentBottomIndex = 0;
    [self show_filterChooseView];
    [self updateBottomBarItemState:0];
    
    [self contentAnimationShow:YES];
}
-(void)contentAnimationShow:(BOOL)show
{
    CGRect rect = self.contentView.frame;
    if (show) {
        rect.origin.y = Screen_HEIGTH - (Width(205) + k_bottom_margin);
    }else{
        rect.origin.y = Screen_HEIGTH;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = rect;
    }];
}
#pragma amrk - 底部切换按钮点击
-(void)bottomItemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 4500;
    if (self.curentBottomIndex == tag) {
        return;
    }
    self.curentBottomIndex = tag;
    [self updateBottomBarItemState:tag];
    if (tag == 0) {
        [self show_filterChooseView];
    }else{
        [self show_beautifySlideview];
    }
}
#pragma mark - 更新底部切换条 选中项
-(void)updateBottomBarItemState:(NSInteger)selIndex
{
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = (UIButton *)[self viewWithTag:4500 + i];
        if (i == selIndex) {
            [btn setTitleColor:[UIColor whiteColor] forState:0];
        }else{
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        }
    }
}
#pragma mark - 切换到滤镜选择view
-(void)show_filterChooseView
{
    if (self.beautifySlideView) {
        self.beautifySlideView.hidden = YES;
    }
    if (!self.filterChooseView) {
        self.filterChooseView = [[FilterChooseView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - Width(50) - k_bottom_margin)];
        self.filterChooseView.delegate = self;
        [self.filterChooseView updateCurentFIlterInfo:self.filterInfo];
        [self.contentView addSubview:self.filterChooseView];
    }
    self.filterChooseView.hidden = NO;
}
#pragma mark - 切换到美颜参数view
-(void)show_beautifySlideview
{
    if (self.filterChooseView) {
        self.filterChooseView.hidden = YES;
    }
    if (!self.beautifySlideView) {
        self.beautifySlideView = [[BeautifySlideView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - Width(50) - k_bottom_margin) beautifyInfo:self.beautifyInfo];
        self.beautifySlideView.delegate = self;
        [self.contentView addSubview:self.beautifySlideView];
    }
    self.beautifySlideView.hidden = NO;
}
#pragma mark - 滤镜选择回调
- (void)filterChooseViewChoosedFilter:(MHFilterInfo *)choosedFilterInfo
{
    self.filterInfo = choosedFilterInfo;
    if (self.callBack) {
        self.callBack(self.filterInfo, self.beautifyInfo);
    }
}
#pragma mark - 美颜参数修改回调
- (void)beautifySlideViewValueChanged:(MHBeautifyInfo *)beautifyInfo
{
    self.beautifyInfo = beautifyInfo;
    if (self.callBack) {
        self.callBack(self.filterInfo, self.beautifyInfo);
    }
}
#pragma mark - 退出
-(void)hiden_hiden_hidne
{
    if (self.hidenHandle) {
        self.hidenHandle();
    }
    [self contentAnimationShow:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+ (void)showFilterWithFilterInfo:(MHFilterInfo *)filterInfo beautifyInfo:(MHBeautifyInfo *)beautifyInfo callBack:(ShootFilterChooseCallBack)callBack hidenHandle:(ShootFilterChooseHidenHandle)hidenHadle
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[ShootFilterChooseView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    ShootFilterChooseView * view = [[ShootFilterChooseView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) filterInfo:filterInfo beautiFy:beautifyInfo callBack:callBack hidenHandle:hidenHadle];
    [keywindow addSubview:view];
}
@end
