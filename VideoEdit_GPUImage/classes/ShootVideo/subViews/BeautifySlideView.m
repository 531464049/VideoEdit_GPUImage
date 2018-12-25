//
//  BeautifySlideView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BeautifySlideView.h"

@interface BeautifySlideView ()

@property(nonatomic,strong)MHBeautifyInfo * beautifyInfo;//美颜参数信息

@property(nonatomic,strong)UISlider * beautySlider;//磨皮滑竿
@property(nonatomic,strong)UISlider * brightSlider;//提亮滑竿
@property(nonatomic,strong)UISlider * toneSlider;//色调滑竿

@end

@implementation BeautifySlideView

-(instancetype)initWithFrame:(CGRect)frame beautifyInfo:(MHBeautifyInfo *)beautifyInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.beautifyInfo = beautifyInfo;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    CGFloat topMrgin = Width(10);
    CGFloat slideHeight = (self.frame.size.height - topMrgin)/3;
    NSArray * titArr = @[@"磨皮",@"提亮",@"色调"];
    for (int i = 0; i < 3; i ++) {
        UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(0, topMrgin + slideHeight*i, self.frame.size.width, slideHeight)];
        [self addSubview:itemView];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, slideHeight)];
        lab.text = titArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        [itemView addSubview:lab];
        
        // 滑动条slider
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10+60, 0, self.frame.size.width - (10+60) - 30, slideHeight)];
        slider.minimumValue = 0;// 设置最小值
        slider.maximumValue = 1;// 设置最大值
        slider.continuous = YES;// 设置可连续变化
        slider.minimumTrackTintColor = [UIColor yellowColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
        slider.maximumTrackTintColor = [UIColor grayColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
        slider.thumbTintColor = [UIColor whiteColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [itemView addSubview:slider];
        if (i == 0) {
            slider.maximumValue = 2.0;
            self.beautySlider = slider;
        }else if (i == 1){
            self.brightSlider = slider;
        }else if (i == 2){
            self.toneSlider = slider;
        }
    }
    self.beautySlider.value = self.beautifyInfo.beautyLevel;
    self.brightSlider.value = self.beautifyInfo.brightLevel;
    self.toneSlider.value = self.beautifyInfo.toneLevel;
}
-(void)sliderValueChanged:(UISlider *)slider
{
    if (slider == self.beautySlider) {
        self.beautifyInfo.beautyLevel = slider.value;
    }else if (slider == self.brightSlider) {
        self.beautifyInfo.brightLevel = slider.value;
    }else if (slider == self.toneSlider) {
        self.beautifyInfo.toneLevel = slider.value;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautifySlideViewValueChanged:)]) {
        [self.delegate beautifySlideViewValueChanged:self.beautifyInfo];
    }
}
@end
