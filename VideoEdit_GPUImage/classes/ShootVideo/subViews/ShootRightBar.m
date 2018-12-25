//
//  ShootRightBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "ShootRightBar.h"

@interface ShootRightBar ()
{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    CGFloat _itemMargin;
}
@property(nonatomic,strong)UIButton * backFrontBtn;
@property(nonatomic,strong)UIButton * fastSlowBtn;
@property(nonatomic,strong)UIButton * beautifyBtn;
@property(nonatomic,strong)UIButton * timerBtn;
@property(nonatomic,strong)UIButton * crapMusicBtn;
@property(nonatomic,strong)UIButton * touchModeBtn;

@property(nonatomic,assign)BOOL isTakePhotoState;//是否是拍照模式
@property(nonatomic,assign)AVCaptureDevicePosition devicePosition;//前后摄像头
@property(nonatomic,assign)AVCaptureTorchMode torchMode;//闪光灯模式
@property(nonatomic,assign)BOOL showCrapMusic;//是否显示裁剪音乐按钮

@end

@implementation ShootRightBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _itemWidth = self.frame.size.width;
        _itemHeight = Width(50);
        _itemMargin = Width(10);
        
        self.isTakePhotoState = NO;
        self.devicePosition = AVCaptureDevicePositionBack;
        self.torchMode = AVCaptureTorchModeOff;
        self.showCrapMusic = NO;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    self.backFrontBtn = [self buildBtnTitle:@"翻转" imgName:@"shoot_device_on" index:0];
    [self.backFrontBtn addTarget:self action:@selector(backFrontBtn_click) forControlEvents:UIControlEventTouchUpInside];
    self.fastSlowBtn = [self buildBtnTitle:@"快慢速" imgName:@"shoot_fast_off" index:1];
    [self.fastSlowBtn addTarget:self action:@selector(fastSlowBtn_click) forControlEvents:UIControlEventTouchUpInside];
    self.beautifyBtn = [self buildBtnTitle:@"美化" imgName:@"shoot_beautify" index:2];
    [self.beautifyBtn addTarget:self action:@selector(beautifyBtn_click) forControlEvents:UIControlEventTouchUpInside];
    self.timerBtn = [self buildBtnTitle:@"倒计时" imgName:@"shoot_countDown" index:3];
    [self.timerBtn addTarget:self action:@selector(timerBtn_click) forControlEvents:UIControlEventTouchUpInside];
    self.crapMusicBtn = [self buildBtnTitle:@"剪音乐" imgName:@"shoot_crapbgm" index:4];
    [self.crapMusicBtn addTarget:self action:@selector(crapMusicBtn_click) forControlEvents:UIControlEventTouchUpInside];
    self.touchModeBtn = [self buildBtnTitle:@"闪光灯" imgName:@"shoot_flash_off" index:5];
    [self.touchModeBtn addTarget:self action:@selector(touchModeBtnBtn_click) forControlEvents:UIControlEventTouchUpInside];
    
    //默认不显示裁剪音乐按钮
    CGRect moreBtnFrame = CGRectMake(0, (_itemHeight + _itemMargin)*4, _itemWidth, _itemHeight);
    self.touchModeBtn.frame = moreBtnFrame;
    self.crapMusicBtn.alpha = 0.0;
}
#pragma mark - 裁剪音乐按钮显示状态变更
- (void)updateCrapMusicItemShow:(BOOL)show
{
    self.showCrapMusic = show;
    [self updateItemsState];
}
-(void)updateItemsState
{
    if (self.isTakePhotoState) {
        //拍照模式 只显示翻转 美化 闪光灯（q后置）
        CGRect beautifuBtnFrame = CGRectMake(0, (_itemHeight + _itemMargin)*1, _itemWidth, _itemHeight);
        CGRect touchModeBtnFrame = CGRectMake(0, (_itemHeight + _itemMargin)*2, _itemWidth, _itemHeight);
        CGFloat touchBtnAlpha = self.devicePosition == AVCaptureDevicePositionBack ? 1.0 : 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.fastSlowBtn.alpha = 0.0;
            self.beautifyBtn.frame = beautifuBtnFrame;
            self.beautifyBtn.alpha = 1.0;
            self.timerBtn.alpha = 0.0;
            self.crapMusicBtn.alpha = 0.0;
            self.touchModeBtn.frame = touchModeBtnFrame;
            self.touchModeBtn.alpha = touchBtnAlpha;
        }];
    }else{
        //拍视频模式
        CGRect beautifuBtnFrame = CGRectMake(0, (_itemHeight + _itemMargin)*2, _itemWidth, _itemHeight);
        CGFloat crapAlpha = self.showCrapMusic ? 1.0 : 0.0;
        CGRect touchModeBtnFrame = CGRectMake(0, (_itemHeight + _itemMargin)*(self.showCrapMusic ? 5 : 4), _itemWidth, _itemHeight);
        CGFloat touchBtnAlpha = self.devicePosition == AVCaptureDevicePositionBack ? 1.0 : 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.fastSlowBtn.alpha = 1.0;
            self.beautifyBtn.alpha = 1.0;
            self.beautifyBtn.frame = beautifuBtnFrame;
            self.timerBtn.alpha = 1.0;
            self.crapMusicBtn.alpha = crapAlpha;
            self.touchModeBtn.frame = touchModeBtnFrame;
            self.touchModeBtn.alpha = touchBtnAlpha;
        }];
    }
}
-(void)updateIsTakePhotoState:(BOOL)isTakePhoto
{
    self.isTakePhotoState = isTakePhoto;
    [self updateItemsState];
}
#pragma mark - 外界摄像头 前置/后置
-(void)updateVaptureDivicePosition:(AVCaptureDevicePosition)position
{
    self.devicePosition = position;
    if (position == AVCaptureDevicePositionBack) {
        [self.backFrontBtn setImage:[UIImage imageNamed:@"shoot_device_on"] forState:0];
    }else{
        [self.backFrontBtn setImage:[UIImage imageNamed:@"shoot_device_off"] forState:0];
    }
    [self updateItemsState];
}
#pragma mark - 更新闪光灯状态 是否开启
- (void)updateTouchModeState:(AVCaptureTorchMode)torchMode
{
    self.torchMode = torchMode;
    if (torchMode == AVCaptureTorchModeAuto) {
        [self.touchModeBtn setImage:[UIImage imageNamed:@"shoot_flash_auto"] forState:0];
    }else if (torchMode == AVCaptureTorchModeOn){
        [self.touchModeBtn setImage:[UIImage imageNamed:@"shoot_flash_on"] forState:0];
    }else{
        [self.touchModeBtn setImage:[UIImage imageNamed:@"shoot_flash_off"] forState:0];
    }
}
-(UIButton *)buildBtnTitle:(NSString *)title imgName:(NSString *)imgName index:(NSInteger)index
{
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, (_itemHeight + _itemMargin)*index, _itemWidth, _itemHeight);
    [btn setTitle:title forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = FONT(15);
    [btn setImage:[UIImage imageNamed:imgName] forState:0];
    [btn mh_fixImageTop];
    [self addSubview:btn];
    return btn;
}
-(void)backFrontBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_changeBackFront)]) {
        [self.delegate shootRightBarHandle_changeBackFront];
    }
}
-(void)fastSlowBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_showFastSlow)]) {
        [self.delegate shootRightBarHandle_showFastSlow];
    }
}
-(void)beautifyBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_showBeautify)]) {
        [self.delegate shootRightBarHandle_showBeautify];
    }
}
-(void)timerBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_showTimer)]) {
        [self.delegate shootRightBarHandle_showTimer];
    }
}
-(void)crapMusicBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_showCripMusic)]) {
        [self.delegate shootRightBarHandle_showCripMusic];
    }
}
-(void)touchModeBtnBtn_click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootRightBarHandle_torchMode)]) {
        [self.delegate shootRightBarHandle_torchMode];
    }
}
@end
