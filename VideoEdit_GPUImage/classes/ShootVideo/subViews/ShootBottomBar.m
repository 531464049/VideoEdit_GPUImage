//
//  ShootBottomBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "ShootBottomBar.h"

@interface ShootBottomBar ()<ShootTypeBarDelegate>

@property(nonatomic,strong)UIButton * uploadBtn;//上传 按钮

@property(nonatomic,strong)UIButton * shootBtn;//拍摄 按钮
@property(nonatomic,strong)UIView * longPressView;//长按模式 长按区域
@property(nonatomic,strong)CAShapeLayer * shootAniLayer;

@property(nonatomic,strong)UIButton * delBtn;//删除当前拍摄内容
@property(nonatomic,strong)UIButton * finishedBtn;//完成拍摄按钮

@property(nonatomic,strong)ShootTypeBar * typeBar;//拍摄类型bar

@property(nonatomic,assign)BOOL deleteFinishBtnShow;//删除 完成 按钮显示状态

@end

@implementation ShootBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _shootType = MHShootTypeSingTapTakeVideo;//默认单击拍摄视频类型
        self.isRecodVideoProgress = NO;//默认未开始拍摄过程
        self.deleteFinishBtnShow = NO;//默认不显示删除和完成按钮
        
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    //拍摄按钮区域
    UIView * shootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(100), Width(100))];
    shootView.center = CGPointMake(self.frame.size.width/2, Width(50));
    [self addSubview:shootView];
    
    //拍摄按钮
    self.shootBtn = [UIButton buttonWithType:0];
    self.shootBtn.frame = CGRectMake(0, 0, Width(80), Width(80));
    self.shootBtn.center = CGPointMake(Width(50), Width(50));
    self.shootBtn.layer.cornerRadius = Width(40);
    self.shootBtn.layer.masksToBounds = YES;
    self.shootBtn.backgroundColor = [UIColor redColor];
    [self.shootBtn addTarget:self action:@selector(shootItemClick) forControlEvents:UIControlEventTouchUpInside];
    [shootView addSubview:self.shootBtn];
    
    //长按view
    self.longPressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(80), Width(80))];
    self.longPressView.center = CGPointMake(Width(50), Width(50));
    self.longPressView.layer.cornerRadius = Width(40);
    self.longPressView.layer.masksToBounds = YES;
    self.longPressView.backgroundColor = [UIColor clearColor];
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress_Handle:)];
    longPressGesture.minimumPressDuration = 1.0;
    [self.longPressView addGestureRecognizer:longPressGesture];
    [shootView addSubview:self.longPressView];
    self.longPressView.hidden = YES;
    
    //拍摄动画layer
    self.shootAniLayer = [CAShapeLayer layer];
    _shootAniLayer.frame = CGRectMake(0, 0, Width(100), Width(100));
    _shootAniLayer.fillColor = [[UIColor clearColor] CGColor];
    _shootAniLayer.strokeColor = [[UIColor purpleColor] CGColor];
    _shootAniLayer.opacity = 1;
    _shootAniLayer.lineCap = kCALineCapButt;
    _shootAniLayer.lineWidth = Width(8);
    _shootAniLayer.strokeEnd =  1.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width(50), Width(50)) radius:Width(50) startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2 clockwise:YES];
    _shootAniLayer.path =path.CGPath;
    [shootView.layer addSublayer:_shootAniLayer];
    
    //上传按钮
    self.uploadBtn = [UIButton buttonWithType:0];
    self.uploadBtn.frame = CGRectMake(0, 0, Width(50), Width(50));
    self.uploadBtn.center = CGPointMake(self.frame.size.width - Width(45) - Width(50)/2, Width(30) + Width(50)/2);
    [self.uploadBtn setImage:[UIImage imageNamed:@"shoot_upload"] forState:UIControlStateNormal];
    [self.uploadBtn setTitle:@"上传" forState:0];
    [self.uploadBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.uploadBtn addTarget:self action:@selector(uploadItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadBtn mh_fixImageTop];
    [self addSubview:self.uploadBtn];
    
    //底部 拍摄类型bar
    self.typeBar = [[ShootTypeBar alloc] initWithFrame:CGRectMake(0, Width(100), self.frame.size.width, Width(50))];
    self.typeBar.delegate = self;
    [self addSubview:self.typeBar];
    
    //删除 完成按钮 默认隐藏
    self.delBtn = [UIButton buttonWithType:0];
    self.delBtn.frame = CGRectMake(0, 0, 40, 40);
    self.delBtn.center = CGPointMake(self.frame.size.width/2 + Width(50) + 20 + 20, Width(50));
    [self.delBtn setTitle:@"删除" forState:0];
    self.delBtn.backgroundColor = [UIColor redColor];
    [self.delBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.delBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.delBtn.hidden = YES;
    [self.delBtn addTarget:self action:@selector(deleteItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delBtn];
    
    self.finishedBtn = [UIButton buttonWithType:0];
    self.finishedBtn.frame = CGRectMake(0, 0, 40, 40);
    self.finishedBtn.center = CGPointMake(self.frame.size.width/2 + Width(50) + 20 + 40 + 20 + 20, Width(50));
    [self.finishedBtn setTitle:@"完成" forState:0];
    self.finishedBtn.backgroundColor = [UIColor redColor];
    [self.finishedBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.finishedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.finishedBtn.hidden = YES;
    [self.finishedBtn addTarget:self action:@selector(finishedItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishedBtn];
}
#pragma mark - 拍摄/拍照按钮点击
-(void)shootItemClick
{
    if (self.shootType == MHShootTypeTakePhoto) {
        //拍照
        if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_takePhoto)]) {
            [self.delegate shootBottomBarHandle_takePhoto];
        }
    }else{
        //拍视频
        if ([_shootAniLayer animationForKey:@"zooming"]) {
            [self handleEndRecode];
        }else{
            [self handleSatrtRecode];
        }
    }
    
}
#pragma mark - 开始拍摄视频
-(void)handleSatrtRecode
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_startRecode)]) {
        [self.delegate shootBottomBarHandle_startRecode];
    }
}
#pragma mark - 结束视频拍摄
-(void)handleEndRecode
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_endRecode)]) {
        [self.delegate shootBottomBarHandle_endRecode];
    }
}
#pragma mark - 长按手势响应
-(void)longPress_Handle:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            DLog(@"长按手势开启");
            [self handleSatrtRecode];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            DLog(@"长按手势结束");
            [self handleEndRecode];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 拍摄类型按钮切换回调
- (void)shootTypeBar:(ShootTypeBar *)bar selectedIndex:(NSInteger)index
{
    //长按手势view默认隐藏
    self.longPressView.hidden = YES;
    
    MHShootType lastType = _shootType;
    
    if (index == 0) {
        _shootType = MHShootTypeTakePhoto;
    }else if (index == 1) {
        _shootType = MHShootTypeSingTapTakeVideo;
    }else if (index == 2) {
        _shootType = MHShootTypeLongPressTakeVideo;
        self.longPressView.hidden = NO;
    }
    //只有当切换拍照和拍视频时 才需要回调控制器切换拍照/拍视频模式
    if (lastType == MHShootTypeTakePhoto || _shootType == MHShootTypeTakePhoto) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_takeTypeChange:)]) {
            [self.delegate shootBottomBarHandle_takeTypeChange:_shootType];
        }
    }
    
}
#pragma mark - 删除按钮点击
-(void)deleteItemClick
{
    DLog(@"删除按钮点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_deleateLastVideo)]) {
        [self.delegate shootBottomBarHandle_deleateLastVideo];
    }
}
#pragma mark - 确认按钮点击
-(void)finishedItemClick
{
    DLog(@"确认按钮点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_sureUseVideo)]) {
        [self.delegate shootBottomBarHandle_sureUseVideo];
    }
}
#pragma mark - 更新是否在拍摄视频过程中 更新底部类型选择是否可选择拍照
- (void)setIsRecodVideoProgress:(BOOL)isRecodVideoProgress
{
    _isRecodVideoProgress = isRecodVideoProgress;
    self.typeBar.canChangeToTakePhoto = !isRecodVideoProgress;
}
#pragma mark - 更新拍摄视频状态 是否在拍摄
- (void)updateRecodeState:(BOOL)isRecoding
{
    if (isRecoding) {
        //在拍摄状态 所有全部隐藏
        self.typeBar.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.delBtn.hidden = YES;
        self.finishedBtn.hidden = YES;
    }else{
        //非拍摄状态
        if (self.isRecodVideoProgress) {
            self.typeBar.hidden = YES;
            self.uploadBtn.hidden = YES;
        }else{
            self.typeBar.hidden = NO;
            self.uploadBtn.hidden = NO;
        }
        
        self.delBtn.hidden = !self.deleteFinishBtnShow;
        self.finishedBtn.hidden = !self.deleteFinishBtnShow;
    }
}
#pragma mark - 更新删除 完成 按钮可用/显示状态
- (void)updateDeleteFinisheCanUse:(BOOL)show
{
    self.deleteFinishBtnShow = show;
    self.delBtn.hidden = !show;
    self.finishedBtn.hidden = !show;
}
#pragma mark - 上传 相册选择
-(void)uploadItemClick
{
    DLog(@"上传 相册选择");
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootBottomBarHandle_chooseFromAlbum)]) {
        [self.delegate shootBottomBarHandle_chooseFromAlbum];
    }
}
#pragma mark - 开始拍摄动画
- (void)startShootBtnAnimation
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSNumber numberWithFloat:1.0],
                            [NSNumber numberWithFloat:1.1],
                            [NSNumber numberWithFloat:1.0]];
    popAnimation.keyTimes = @[@0.0f, @0.5f,@1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    popAnimation.autoreverses=NO;
    popAnimation.repeatCount=MAXFLOAT;
    popAnimation.removedOnCompletion=YES;
    popAnimation.fillMode=kCAFillModeForwards;
    [_shootAniLayer addAnimation:popAnimation forKey:@"zooming"];
    
    [self updateRecodeState:YES];
}
#pragma mark - 结束拍摄动画
- (void)stopShootBtnAnimation
{
    [_shootAniLayer removeAllAnimations];
    
    [self updateRecodeState:NO];
}
@end


@interface ShootTypeBar ()

@property(nonatomic,strong)UIView * contentView;//包含三个类型按钮的容器，当点击时，改变容器中心点

@property(nonatomic,strong)UIView * bottomDian;//底部指示圆点

@property(nonatomic,assign)NSInteger curentSelectedIndex;//当前选中类型下标

@end

@implementation ShootTypeBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curentSelectedIndex = 1;//默认选中单击拍摄  1
        self.canChangeToTakePhoto = YES;//默认可以选择拍照模式 当开始拍摄视频后，不能再切换到拍照模式
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    //底部指示圆点
    self.bottomDian = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(6), Width(6))];
    self.bottomDian.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 10);
    self.bottomDian.backgroundColor = [UIColor whiteColor];
    self.bottomDian.layer.cornerRadius = Width(6)/2;
    self.bottomDian.layer.masksToBounds = YES;
    [self addSubview:self.bottomDian];
    
    //每个按钮长度
    CGFloat itemWidth = self.frame.size.width/5;
    CGFloat itemHeight = self.frame.size.height;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth * 3, itemHeight)];
    self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:self.contentView];
    
    NSArray * titleArr = @[@"拍照",@"单击拍",@"长按拍"];
    for (int i = 0; i < 3; i ++) {
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
        [btn setTitle:titleArr[i] forState:0];
        [btn setTitleColor:[UIColor grayColor] forState:0];
        btn.titleLabel.font = FONT(14);
        btn.tag = 6600 + i;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    [self updateSelectedIndex:self.curentSelectedIndex];
}
-(void)updateSelectedIndex:(NSInteger)index
{
    CGFloat itemWidth = self.frame.size.width/5;
    CGPoint contentCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (index == 0) {
        //向右偏移
        contentCenter = CGPointMake(self.frame.size.width/2 + itemWidth, self.frame.size.height/2);
    }else if (index == 2) {
        //向左偏移
        contentCenter = CGPointMake(self.frame.size.width/2 - itemWidth, self.frame.size.height/2);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = contentCenter;
    }];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * btn = (UIButton *)[self viewWithTag:i + 6600];
        if (i == index) {
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            btn.titleLabel.font = FONT(15);
        }else{
            [btn setTitleColor:[UIColor grayColor] forState:0];
            btn.titleLabel.font = FONT(14);
        }
    }
}
-(void)itemClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 6600;
    if (self.curentSelectedIndex == index) {
        return;
    }
    if (index == 0 && !self.canChangeToTakePhoto) {
        //禁止选择拍照模式
        return;
    }
    self.curentSelectedIndex = index;
    [self updateSelectedIndex:self.curentSelectedIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shootTypeBar:selectedIndex:)]) {
        [self.delegate shootTypeBar:self selectedIndex:index];
    }
}
@end
