//
//  EditChooseCoverView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditChooseCoverView.h"

@interface EditChooseCoverView ()

@property(nonatomic,copy)NSString * videoPath;
@property(nonatomic,assign)CGFloat curentCoverlocation;
@property(nonatomic,copy)VideoCoverChooseCallBack callBack;

@property(strong, nonatomic)AVPlayer * videoPlayer;//视频播放
@property(nonatomic, strong)id timeObserve;//播放进度time观察者
@property (nonatomic,strong)GPUImageMovie * gpuMovie;//滤镜效果展示movie
@property (nonatomic,strong)GPUImageView * gpuView;//视频预览图层
@property(nonatomic,strong)UIImageView * coverPreView;//封面预览图-滑动时显示

@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * commonFilter;//新添加的普通滤镜
@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * specialFilter;//新添加的特效滤镜

@property(nonatomic,strong)UIView * coverContent;//封面容器 滑动封面容器
@property(nonatomic,assign)CGFloat videolength;//视频总时长

@property(nonatomic,strong)UIView * touchContent;//跟随手指滑动的view
@property(nonatomic,strong)UIImageView * curentCoverImg;//当前时间点 封面
@property(nonatomic,assign)BOOL handleTouch;//是否响应手指滑动

@end

@implementation EditChooseCoverView

-(instancetype)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath curentCoverLocation:(CGFloat)curentCoverlocation commonFilter:(GPUImageOutput<GPUImageInput> *)commonFilter specialfilter:(GPUImageOutput<GPUImageInput> *)specialFilter callBacl:(VideoCoverChooseCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.videoPath = videoPath;
        self.curentCoverlocation = curentCoverlocation;
        self.commonFilter = commonFilter;
        self.specialFilter = specialFilter;
        self.callBack = callBack;
        self.videolength = [MHVideoTool mh_getVideolength:[NSURL fileURLWithPath:self.videoPath]];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self commit_movieView];
            [self commit_subViews];
        });
    }
    return self;
}
#pragma mark - 初始化movie
-(void)commit_movieView
{
    //初始化一个player
    NSURL * videoUrl = [NSURL fileURLWithPath:self.videoPath];
    self.videoPlayer = [[AVPlayer alloc] init];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    
    //初始化 gpuMovie
    self.gpuMovie = [[GPUImageMovie alloc] initWithPlayerItem:playerItem];
    self.gpuMovie.runBenchmark = YES;
    self.gpuMovie.playAtActualSpeed = YES;//滤镜渲染方式
    self.gpuMovie.shouldRepeat = YES;//是否循环播放
    //初始化视频预览图层
    self.gpuView = [[GPUImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.gpuView];
    
    //初始化封面预览图-默认隐藏
    self.coverPreView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.coverPreView.contentMode = UIViewContentModeScaleAspectFit;
    self.coverPreView.clipsToBounds = YES;
    [self addSubview:self.coverPreView];
    self.coverPreView.hidden = YES;
    
    [self.gpuMovie addTarget:self.commonFilter];
    [self.commonFilter addTarget:self.specialFilter];
    [self.specialFilter addTarget:self.gpuView];
    
    //添加播放时间监听
    [self addTimeObserve];
    [self.videoPlayer play];
    [self.gpuMovie startProcessing];
    
    
    //计算预览图层缩放比例
    CGFloat transHeight = Screen_HEIGTH - Width(50) - Width(140) - k_bottom_margin;
    CGFloat transformScale = transHeight / Screen_HEIGTH;
    //计算缩放后需要平移的量
    CGFloat offY = Screen_HEIGTH/2 - transHeight/2 - Width(50);
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transformScale, transformScale);
    CGAffineTransform offYTransform = CGAffineTransformMakeTranslation(0, -offY);
    CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, offYTransform);
    self.gpuView.transform = transform;
    self.coverPreView.transform = transform;
}
#pragma mark - 添加播放进度时间观察
-(void)addTimeObserve
{
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.videoPlayer.currentItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            CGFloat currentTime = CMTimeGetSeconds([currentItem currentTime]);
            [weakSelf handlePlayerTime:currentTime];
        }
    }];
}
#pragma mark - 初始化页面UI
-(void)commit_subViews
{
    UIButton * cancleItem = [UIButton buttonWithType:0];
    cancleItem.frame = CGRectMake(0, 0, Width(75), Width(50));
    [cancleItem setTitle:@"取消" forState:0];
    [cancleItem setTitleColor:[UIColor whiteColor] forState:0];
    cancleItem.titleLabel.font = FONT(16);
    [cancleItem addTarget:self action:@selector(cancleItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleItem];
    
    UIButton * sureItem = [UIButton buttonWithType:0];
    sureItem.frame = CGRectMake(Screen_WIDTH - Width(75), 0, Width(75), Width(50));
    [sureItem setTitle:@"完成" forState:0];
    [sureItem setTitleColor:[UIColor whiteColor] forState:0];
    sureItem.titleLabel.font = FONT(16);
    [sureItem addTarget:self action:@selector(sureItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureItem];
    
    //底部整体容器
    UIView * listContent = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - (Width(140) + k_bottom_margin), Screen_WIDTH, Width(140) + k_bottom_margin)];
    [self addSubview:listContent];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = listContent.bounds;
    [listContent addSubview:effectView];
    
    //已选封面
    UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.frame = CGRectMake(Width(15), 0, 100, Width(50));
    lab.text = @"已选封面";
    [listContent addSubview:lab];
    
    //封面所在的容器
    self.coverContent = [[UIView alloc] initWithFrame:CGRectMake(Width(15), Width(50), Screen_WIDTH - Width(30), Width(65))];
    [listContent addSubview:self.coverContent];
    
    //获取封面
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 7; i ++) {
            CGFloat time = self.videolength/6 * i;
            UIImage * img = [MHVideoTool mh_getVideoTempImageFromVideo:[NSURL fileURLWithPath:self.videoPath] withTime:time];
            if (img) {
                [arr addObject:img];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self commit_coverListView:arr];
        });
    });
}
#pragma mark - 初始化封面列表
-(void)commit_coverListView:(NSArray *)imgArr
{
    //7个封面图
    CGFloat itemWidth = self.coverContent.frame.size.width / 7;
    CGFloat itemHeight = self.coverContent.frame.size.height;
    for (int i = 0; i < 7; i ++) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
        imgView.image = imgArr[i];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.coverContent addSubview:imgView];
    }
    //灰色遮罩
    UIView * grayCover = [[UIView alloc] initWithFrame:self.coverContent.bounds];
    grayCover.backgroundColor = [UIColor grayColor];
    grayCover.alpha = 0.6;
    [self.coverContent addSubview:grayCover];
    
    //跟随手指滑动的view
    self.touchContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
    self.touchContent.backgroundColor = [UIColor blackColor];
    self.touchContent.layer.cornerRadius = 4;
    self.touchContent.layer.masksToBounds = YES;
    self.touchContent.layer.borderColor = [UIColor whiteColor].CGColor;
    self.touchContent.layer.borderWidth = 3;
    [self.coverContent addSubview:self.touchContent];
    
    //当前封面
    self.curentCoverImg = [[UIImageView alloc] initWithFrame:self.touchContent.bounds];
    self.curentCoverImg.contentMode = UIViewContentModeScaleAspectFit;
    self.curentCoverImg.clipsToBounds = YES;
    [self.touchContent addSubview:self.curentCoverImg];
    
    [self updateCurentCover:self.curentCoverlocation];
}
#pragma mark - 响应视频播放时间变更
-(void)handlePlayerTime:(CGFloat)time
{
    DLog(@"%f",time);
    if (time >= self.curentCoverlocation + self.videolength/6 || time >= self.videolength) {
        [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(self.curentCoverlocation, NSEC_PER_SEC)];
//        [self.videoPlayer play];
    }
}
#pragma mark - 更新当前封面位置 封面图
-(void)updateCurentCover:(CGFloat)coverLocation
{
    DLog(@"---%f",coverLocation);
    if (self.curentCoverImg.image && self.curentCoverlocation == coverLocation) {
        return;
    }
    self.curentCoverlocation = coverLocation;
    
    CGFloat totleWidth = self.coverContent.frame.size.width / 7 * 6;
    CGFloat oroginX = totleWidth * (self.curentCoverlocation / self.videolength);
    
    CGRect touchFrame = self.touchContent.frame;
    touchFrame.origin.x = oroginX;
    self.touchContent.frame = touchFrame;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * img = [MHVideoTool mh_getVideoTempImageFromVideo:[NSURL fileURLWithPath:self.videoPath] withTime:coverLocation];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (img) {
                self.curentCoverImg.image = img;
                self.coverPreView.image = img;
            }
        });
    });
}
#pragma mark - 触摸滑动 结束
-(void)handleTouchEnd
{
    self.coverPreView.hidden = YES;
    [self.videoPlayer play];
    [self.gpuMovie startProcessing];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([touches anyObject].view == self.touchContent) {
        self.handleTouch = YES;
        [self.videoPlayer pause];
        [self.gpuMovie endProcessing];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.handleTouch) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self.coverContent];
    DLog(@"%f    %f",point.x,point.y);
    if (point.y < 0 || point.y > self.coverContent.frame.size.height) {
        self.handleTouch = NO;
        [self handleTouchEnd];
        return;
    }
    //判断左右边界
    if (point.x <= self.touchContent.frame.size.width/2) {
        point.x = self.touchContent.frame.size.width/2;
    }else if (point.x > self.coverContent.frame.size.width - self.touchContent.frame.size.width/2) {
        point.x = self.coverContent.frame.size.width - self.touchContent.frame.size.width/2;
    }
    
    //计算当前时间点
    CGFloat originX = point.x - self.touchContent.frame.size.width/2;
    CGFloat curentLocation = originX / (self.coverContent.frame.size.width / 7 * 6) * self.videolength;
    
    self.coverPreView.hidden = NO;
    [self updateCurentCover:curentLocation];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self handleTouchEnd];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self handleTouchEnd];
}
-(void)removeAll
{
    [self.gpuMovie endProcessing];
    [self.gpuView removeFromSuperview];
    // 移除time观察者
    if (self.timeObserve) {
        [self.videoPlayer removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    if (self.videoPlayer) {//暂停
        [self.videoPlayer pause];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - 取消
-(void)cancleItemClick
{
    self.callBack(NO, self.curentCoverlocation);
    [self removeAll];
}
#pragma mark - 完成
-(void)sureItemClick
{
    self.callBack(YES, self.curentCoverlocation);
    [self removeAll];
}
+(void)showCoverWithVideoPath:(NSString *)videoPath curentCoverLocation:(CGFloat)curentCoverlocation commonFilter:(GPUImageOutput<GPUImageInput> *)commonFilter specialfilter:(GPUImageOutput<GPUImageInput> *)specialFilter callBacl:(VideoCoverChooseCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[EditChooseCoverView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    EditChooseCoverView * viv = [[EditChooseCoverView alloc] initWithFrame:keywindow.bounds videoPath:videoPath curentCoverLocation:curentCoverlocation commonFilter:commonFilter specialfilter:specialFilter callBacl:callBack];
    [keywindow addSubview:viv];
}
@end
