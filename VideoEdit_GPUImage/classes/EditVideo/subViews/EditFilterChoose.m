//
//  EditFilterChoose.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/27.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditFilterChoose.h"
#import "FilterChooseView.h"

@interface EditFilterChoose ()<FilterChooseViewDelegate>

@property(nonatomic,strong)MHFilterInfo * curentFilter;
@property(nonatomic,copy)EditFilterChooseCallBack callBack;
@property(nonatomic,copy)EditFilterChooseHidenHandle hidenHandle;

@property(nonatomic,strong)FilterChooseView * filterListview;

@end

@implementation EditFilterChoose
-(instancetype)initWithFrame:(CGRect)frame CurentFilter:(MHFilterInfo *)curentfilter callBack:(EditFilterChooseCallBack)callBack hidenHanlde:(EditFilterChooseHidenHandle)hidenHandle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curentFilter = curentfilter;
        self.callBack = callBack;
        self.hidenHandle = hidenHandle;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    UIControl * hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    [hidenControl addTarget:self action:@selector(hidenhidenhiden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hidenControl];
    
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - (Width(155) + k_bottom_margin), Screen_WIDTH, Width(155) + k_bottom_margin)];
    [self addSubview:contentView];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = contentView.bounds;
    [contentView addSubview:effectView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    
    self.filterListview = [[FilterChooseView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(155))];
    self.filterListview.delegate = self;
    [self.filterListview updateCurentFIlterInfo:self.curentFilter];
    [contentView addSubview:self.filterListview];
}
#pragma mark - 滤镜选择回调
- (void)filterChooseViewChoosedFilter:(MHFilterInfo *)choosedFilterInfo
{
    self.curentFilter = choosedFilterInfo;
    self.callBack(choosedFilterInfo);
}
-(void)hidenhidenhiden
{
    self.hidenHandle();
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showWithCurentFilter:(MHFilterInfo *)curentfilter callBack:(EditFilterChooseCallBack)callBack hidenHanlde:(EditFilterChooseHidenHandle)hidenHandle
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[EditFilterChoose class]]) {
            [subView removeFromSuperview];
        }
    }
    
    EditFilterChoose * view = [[EditFilterChoose alloc] initWithFrame:keywindow.bounds CurentFilter:curentfilter callBack:callBack hidenHanlde:hidenHandle];
    [keywindow addSubview:view];
}

@end
