//
//  MusicCrapView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MusicCrapView.h"

@interface MusicCrapView ()<UIScrollViewDelegate>

@property(nonatomic,copy)NSString * musicName;
@property(nonatomic,assign)NSInteger startTime;
@property(nonatomic,copy)CrapBGMStartTimeCallBack callBack;

@property(nonatomic,strong)UIView * contentView;//包含全部子元素的容器
@property(nonatomic,strong)UILabel * curentTimeLab;//当前开始时间lab
@property(nonatomic,strong)UILabel * tipLab;//提示lab
@property(nonatomic,strong)UIButton * sureBtn;//确认按钮

@property(nonatomic,strong)UIScrollView * scrollView;//声谱滑动容器
@property(nonatomic,strong)AVPlayer * musicPlayer;//音频播放器

@property(nonatomic,assign)CGFloat perSecondWidth;//每秒 长度
@property(nonatomic,assign)CGFloat itemWidth;//音频频谱 每个item宽度
@property(nonatomic,assign)CGFloat itemMargin;//音频频谱 item间隔
@property(nonatomic,strong)NSTimer * timer;//频谱状态变更定时器

@end

@implementation MusicCrapView
{
    NSInteger _perSecondItem;//每秒频谱数量
    NSInteger _totlePinPuNum;//全部频谱数量
    NSInteger _curentPinPuIndex;//当前频谱增加数量 每1/3秒+1
    
    NSInteger _lastStartTime;//上一次开始时间
}
-(instancetype)initWithFrame:(CGRect)frame bgmName:(NSString *)bgmName startTime:(NSInteger)startTime callBack:(CrapBGMStartTimeCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.musicName = bgmName;
        self.startTime = startTime;
        self.callBack = callBack;
        
        _lastStartTime = self.startTime;
        _perSecondItem = 3;
        _totlePinPuNum = 0;
        _curentPinPuIndex = 0;
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    // 130 + 90
    //整体容器
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-Width(130)-Width(90)-k_bottom_margin, self.frame.size.width, Width(130) + Width(90))];
    [self addSubview:self.contentView];
    
    //提示lab
    self.tipLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentCenter];
    self.tipLab.frame = CGRectMake(0, 0, self.contentView.frame.size.width, Width(32));
    self.tipLab.text = @"左右拖动声谱以剪取音乐";
    [self.contentView addSubview:self.tipLab];
    
    //确认按钮
    self.sureBtn = [UIButton buttonWithType:0];
    self.sureBtn.frame = CGRectMake(self.contentView.frame.size.width - Width(55) - Width(15), 0, Width(55), Width(32));
    self.sureBtn.backgroundColor = [UIColor redColor];
    [self.sureBtn setTitle:@"确认" forState:0];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.sureBtn.titleLabel.font = FONT(15);
    self.sureBtn.layer.cornerRadius = 2;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn addTarget:self action:@selector(sureItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    
    //当前开始时间
    self.curentTimeLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentCenter];
    self.curentTimeLab.frame = CGRectMake(Width(20), self.contentView.frame.size.height-Width(130)-Width(25), 0, Width(20));
    self.curentTimeLab.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.curentTimeLab];
    [self update_curentTimeLab];
    
    //初始化音频频谱
    [self commit_scrollView];
}
#pragma mark - 根据当前开始时间 更新lab
-(void)update_curentTimeLab
{
    NSString * str = [NSString stringWithFormat:@"当前从%@开始",[self curentStartTimeStr]];
    CGFloat strWidth = [str textForLabWidthWithTextHeight:30 font:self.curentTimeLab.font] + 16;
    CGRect rect = self.curentTimeLab.frame;
    rect.size.width = strWidth;
    self.curentTimeLab.frame = rect;
    self.curentTimeLab.text = str;
}
#pragma mark - 初始化音频频谱
-(void)commit_scrollView
{
    //滑动容器
    //一屏需要展示15秒内容 一秒需要4个频谱
    self.perSecondWidth = self.frame.size.width / 15.f;
    self.itemWidth = self.perSecondWidth / _perSecondItem / 3 * 2;
    self.itemMargin = self.itemWidth / 2;
    
    //初始化scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(90), self.frame.size.width, Width(130))];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.contentView addSubview:self.scrollView];
    
    //s初始化播放器
    NSString *path = [[NSBundle mainBundle] pathForResource:self.musicName ofType:@"mp3"];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    self.musicPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    [self.musicPlayer seekToTime:CMTimeMakeWithSeconds(self.startTime, NSEC_PER_SEC)];
    [self.musicPlayer play];
    //音频总时长
    NSInteger totleTime = (NSInteger)CMTimeGetSeconds(playerItem.asset.duration);
    //view总长度
    CGFloat totleWidth = totleTime * self.perSecondWidth;
    
    self.scrollView.contentSize = CGSizeMake(totleWidth, self.scrollView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(self.startTime * self.perSecondWidth, 0) animated:NO];
    
    //频谱总数
    _totlePinPuNum = totleTime * _perSecondItem;
    //频谱基础高度 1x  每个频谱随机1-5个基础高度
    CGFloat perPinPuHeight = (self.scrollView.frame.size.height - Width(30))/5;
    for (int i = 0; i < _totlePinPuNum; i ++) {
        //随机 1-5
        int x = arc4random() % 5 + 1;
        CGFloat itemHeight = perPinPuHeight * x;
        UIView * item = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemWidth, itemHeight)];
        item.center = CGPointMake((self.itemWidth + self.itemMargin)*i + self.itemWidth/2, self.scrollView.frame.size.height/2);
        item.backgroundColor = [UIColor grayColor];
        item.layer.cornerRadius = self.itemWidth/2;
        item.layer.masksToBounds = YES;
        item.tag = 10000 + i;
        [self.scrollView addSubview:item];
    }
    
    //更新当前开始时间频谱状态+定时器
    [self updateCurentStartTimePinPu];
}
#pragma mark - 更新当前开始时间频谱状态+定时器
-(void)updateCurentStartTimePinPu
{
    //如果有定时器 先销毁
    if (_timer) {
        [self dealloc_timer];
    }
    //先初始化全部频谱
    for (NSInteger i = _lastStartTime*_perSecondItem; i < 20*_perSecondItem; i ++) {
        UIView * item = (UIView *)[self viewWithTag:10000+i];
        item.backgroundColor = [UIColor grayColor];
    }
    _lastStartTime = self.startTime;
    //初始化当前频谱增加量
    _curentPinPuIndex = 0;
    //初始化第一个频谱状态
    [self updateCurentPinPuState];
    //开启定时器 更新频谱状态
    //定时器开启
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}
#pragma mark - 根据频谱增加量 更新当前频谱状态
-(void)updateCurentPinPuState
{
    //当前开始时间 第一个频谱下标
    NSInteger curentIndex = self.startTime * _perSecondItem + _curentPinPuIndex;
    UIView * item = (UIView *)[self viewWithTag:curentIndex + 10000];
    item.backgroundColor = [UIColor yellowColor];
}
#pragma mark - 定时器响应
-(void)timer_handle
{
    _curentPinPuIndex += 1;
    if (_curentPinPuIndex >= 15*_perSecondItem) {
        //15秒播放结束 重新播放 重置状态
        //player跳转
        [self.musicPlayer seekToTime:CMTimeMakeWithSeconds(self.startTime, NSEC_PER_SEC)];
        [self.musicPlayer play];
        //更新当前开始时间频谱状态+定时器
        [self updateCurentStartTimePinPu];
    }else{
        //更新频谱状态
        [self updateCurentPinPuState];
    }
}
#pragma mark - 创建定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/_perSecondItem target:self selector:@selector(timer_handle) userInfo:nil repeats:YES];
    }
    return _timer;
}
#pragma mark - 定时器销毁
-(void)dealloc_timer
{
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}
#pragma mark - 处理滑动后的结果
-(void)hanldeScerollEndOffx:(CGFloat)offx
{
    //计算当前开始时间
    NSInteger cSecond = ceil(offx/self.perSecondWidth);
    self.startTime = cSecond;
    //player跳转
    [self.musicPlayer seekToTime:CMTimeMakeWithSeconds(self.startTime, NSEC_PER_SEC)];
    [self.musicPlayer play];
    //更新时间显示
    [self update_curentTimeLab];
    //更新当前开始时间频谱状态+定时器
    [self updateCurentStartTimePinPu];
}
#pragma mark - scroll代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO){
        // scrollView已经完全静止
        [self hanldeScerollEndOffx:scrollView.contentOffset.x];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // scrollView已经完全静止
    [self hanldeScerollEndOffx:scrollView.contentOffset.x];
}
#pragma mark - 格式化当前时间
-(NSString *)curentStartTimeStr
{
    //背景音乐时间 一般也不会超过小时吧......
    NSInteger fen = self.startTime / 60;
    NSInteger miao = self.startTime % 60;
    NSString * str = [NSString stringWithFormat:@"%02ld:%02ld",fen,miao];
    return str;
}
#pragma mark - 确认按钮点击
-(void)sureItemClick
{
    if (self.callBack) {
        self.callBack(self.startTime);
    }
    if (_timer) {
        [self dealloc_timer];
    }
    [self.musicPlayer pause];
    self.musicPlayer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+ (void)showCrapBGMName:(NSString *)bgmName startTime:(NSInteger)startTime callBack:(CrapBGMStartTimeCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[MusicCrapView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    MusicCrapView * view = [[MusicCrapView alloc] initWithFrame:keywindow.bounds bgmName:bgmName startTime:startTime callBack:callBack];
    [keywindow addSubview:view];
}

@end
