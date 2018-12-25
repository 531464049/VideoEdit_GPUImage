//
//  EditVideoVolumeView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditVideoVolumeView.h"

@interface EditVideoVolumeView ()

@property(nonatomic,assign)BOOL hasBGM;
@property(nonatomic,assign)CGFloat originalVolume;
@property(nonatomic,assign)CGFloat bgmVolume;
@property(nonatomic,copy)VideoVolumeEditCallBack callBack;


@property(nonatomic,strong)UISlider * originalSlider;//原生音量滑竿
@property(nonatomic,strong)UISlider * bgmSlider;//配乐滑竿

@end

@implementation EditVideoVolumeView

-(instancetype)initWithFrame:(CGRect)frame hasBGM:(BOOL)hasBGM originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume callBack:(VideoVolumeEditCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasBGM = hasBGM;
        self.originalVolume = originalVolume;
        self.bgmVolume = bgmVolume;
        self.callBack = callBack;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    CGFloat contentHeight = (Width(48) + Width(145) + k_bottom_margin);
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - contentHeight, self.frame.size.width, contentHeight)];
    [self addSubview:contentView];
    
    //确认按钮
    UIButton * surebtn = [UIButton buttonWithType:0];
    [surebtn setTitle:@"确认" forState:0];
    [surebtn setTitleColor:[UIColor whiteColor] forState:0];
    surebtn.backgroundColor = [UIColor redColor];
    surebtn.titleLabel.font = FONT(14);
    surebtn.layer.cornerRadius = 4;
    surebtn.layer.masksToBounds = YES;
    [surebtn addTarget:self action:@selector(sureItemClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:surebtn];
    surebtn.sd_layout.rightSpaceToView(contentView, Width(20)).topSpaceToView(contentView, 0).widthIs(Width(52)).heightIs(Width(32));
    
    UILabel * titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentCenter];
    titleLab.text = @"音量";
    [contentView addSubview:titleLab];
    titleLab.sd_layout.centerXEqualToView(contentView).centerYEqualToView(surebtn).widthIs(100).heightRatioToView(surebtn, 1.0);
    
    //黑色容器
    UIView * sliderContent = [[UIView alloc] initWithFrame:CGRectMake(0, Width(48), self.frame.size.width, contentView.frame.size.height - Width(48))];
    [contentView addSubview:sliderContent];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = sliderContent.bounds;
    [sliderContent addSubview:effectView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sliderContent.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = sliderContent.bounds;
    maskLayer.path = maskPath.CGPath;
    sliderContent.layer.mask = maskLayer;
    
    NSArray * arr = @[@"原生",@"配乐"];
    for (int i = 0; i < 2; i ++) {
        UIView * item = [[UIView alloc] initWithFrame:CGRectMake(0, sliderContent.frame.size.height/2*i, sliderContent.frame.size.width, sliderContent.frame.size.height/2 - Width(10))];
        [sliderContent addSubview:item];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, item.frame.size.height)];
        lab.text = arr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        [item addSubview:lab];
        
        // 滑动条slider
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10+60, 0, self.frame.size.width - (10+60) - 30, item.frame.size.height)];
        slider.minimumValue = 0;// 设置最小值
        slider.maximumValue = 2;// 设置最大值
        slider.continuous = YES;// 设置可连续变化
        slider.minimumTrackTintColor = [UIColor yellowColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
        slider.maximumTrackTintColor = [UIColor grayColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
        slider.thumbTintColor = [UIColor whiteColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [item addSubview:slider];
        
        if (i == 0) {
            self.originalSlider = slider;
        }else{
            self.bgmSlider = slider;
            self.bgmSlider.enabled = self.hasBGM;
        }
    }
    self.originalSlider.value = self.originalVolume;
    self.bgmSlider.value = self.bgmVolume;
}
-(void)sliderValueChanged:(UISlider *)slider
{
    if (slider == self.originalSlider) {
        self.originalVolume = slider.value;
    }else{
        self.bgmVolume = slider.value;
    }
}
#pragma mark - 确认 退出
-(void)sureItemClick
{
    if (self.callBack) {
        self.callBack(self.originalVolume, self.bgmVolume);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showHasBGM:(BOOL)hasBGM originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume callBack:(VideoVolumeEditCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[EditVideoVolumeView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    EditVideoVolumeView * vvv = [[EditVideoVolumeView alloc] initWithFrame:keywindow.bounds hasBGM:hasBGM originalVolume:originalVolume bgmVolume:bgmVolume callBack:callBack];
    [keywindow addSubview:vvv];
}

@end
