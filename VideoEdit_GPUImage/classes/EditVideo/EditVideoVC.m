//
//  EditVideoVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditVideoVC.h"
#import "EditVideoTopBar.h"
#import "EditVideoBottomBar.h"
#import "EditVideoVolumeView.h"
#import "EditChooseCoverView.h"
#import "ChooseBGMusicVC.h"
#import "MusicCrapView.h"
#import "EditFilterChoose.h"
#import "EditSpecialFilterChoose.h"
#import "PostViewController.h"

@interface EditVideoVC ()<EditVideoTopBarDelelate,EditVideoBottomBar,ChooseBGMusicDelegate>

@property(strong, nonatomic)AVPlayer * videoPlayer;//视频播放
@property(strong, nonatomic)AVPlayer * musicPlayer;//音乐播放

@property (nonatomic,strong)GPUImageMovie * gpuMovie;//滤镜效果展示movie
@property (nonatomic,strong)GPUImageView * gpuView;//视频预览图层

@property(nonatomic,strong)MHFilterInfo * commonFilterInfo;//当前选中普通滤镜信息(默认为空滤镜)
@property(nonatomic,strong)MHFilterInfo * speticalFilterInfo;//当前选中特效滤镜信息(默认为空滤镜)

@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * commonFilter;//新添加的普通滤镜
@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * specialFilter;//新添加的特效滤镜

@property(nonatomic,strong)UIButton * quit_Btn;//退出 按钮
@property(nonatomic,strong)EditVideoTopBar * topBar;//顶部 剪音乐 音量 选音乐
@property(nonatomic,strong)EditVideoBottomBar * bottomBar;//底部 特效 选封面 滤镜

@end

@implementation EditVideoVC
{
    GPUImageMovie * _movieComposition;//视频合成时的movie
    GPUImageMovieWriter * _movieWriter;//视频合成时的writer
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [MHStatusBarHelper updateStatuesBarHiden:YES];
    [self addMovieNoti];
    [self updateMovieMusicState_pause:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeNoti];
    [self updateMovieMusicState_pause:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_movie];
    [self commit_subViews];
}
#pragma mark - 初始化movie
-(void)commit_movie
{
    //初始化默认滤镜信息（空滤镜）
    self.commonFilterInfo = [MHFilterInfo customEmptyInfo];
    self.speticalFilterInfo = [MHFilterInfo customEmptyInfo];
    
    //初始化一个player
    NSURL * videoUrl = [NSURL fileURLWithPath:self.videoModel.shootFinishMergedVideoPath];
    self.videoPlayer = [[AVPlayer alloc] init];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    self.videoPlayer.volume = self.videoModel.videoVolume;
    
    //初始化 gpuMovie
    self.gpuMovie = [[GPUImageMovie alloc] initWithPlayerItem:playerItem];
    self.gpuMovie.runBenchmark = YES;
    self.gpuMovie.playAtActualSpeed = YES;//滤镜渲染方式
    self.gpuMovie.shouldRepeat = YES;//是否循环播放
    //初始化视频预览图层
    self.gpuView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.gpuView];
    
    GPUImageOutput<GPUImageInput> * commonfilter = [[NSClassFromString(self.commonFilterInfo.filterClassName) alloc] init];
    self.commonFilter = commonfilter;
    GPUImageOutput<GPUImageInput> * specialfilter = [[NSClassFromString(self.speticalFilterInfo.filterClassName) alloc] init];
    self.specialFilter = specialfilter;
    
    [self.gpuMovie addTarget:self.commonFilter];
    [self.commonFilter addTarget:self.specialFilter];
    [self.specialFilter addTarget:self.gpuView];
    
    [self update_bgm];
    [self.videoPlayer play];
    [self.gpuMovie startProcessing];
    
    [self addMovieNoti];
}
#pragma mark - 添加播放完成通知
-(void)addMovieNoti
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - 播放完成通知
-(void)playbackFinished:(NSNotification *)notification
{
    //DLog(@"视频播放完成,重新播放");
    // 跳到最新的时间点开始播放
    [self.videoPlayer seekToTime:kCMTimeZero];
    [self.videoPlayer play];
    if (self.musicPlayer) {
        [self.musicPlayer seekToTime:CMTimeMakeWithSeconds(self.videoModel.bgmStartTime, NSEC_PER_SEC)];
        [self.musicPlayer play];
    }
    [self.gpuMovie startProcessing];
}
#pragma mark - 暂停/继续播放
-(void)updateMovieMusicState_pause:(BOOL)pause
{
    if (pause) {
        [self.videoPlayer pause];
        if (self.musicPlayer) {
            [self.musicPlayer pause];
        }
        [self.gpuMovie endProcessing];
    }else{
        [self.videoPlayer seekToTime:kCMTimeZero];
        [self.videoPlayer play];
        if (self.musicPlayer) {
            [self.musicPlayer seekToTime:CMTimeMakeWithSeconds(self.videoModel.bgmStartTime, NSEC_PER_SEC)];
            [self.musicPlayer play];
        }
        [self.gpuMovie startProcessing];
    }
}
#pragma mark - 更新背景音乐
-(void)update_bgm
{
    if (self.videoModel.bgmName != nil || self.videoModel.bgmName.length > 0) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:self.videoModel.bgmName ofType:@"mp3"];
        AVPlayerItem * audioItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
        if (!self.musicPlayer) {
            self.musicPlayer = [[AVPlayer alloc] init];
        }
        [self.musicPlayer replaceCurrentItemWithPlayerItem:audioItem];
        [self.musicPlayer seekToTime:CMTimeAdd(CMTimeMakeWithSeconds(self.videoModel.bgmStartTime, NSEC_PER_SEC), self.videoPlayer.currentTime)];
        self.musicPlayer.volume = self.videoModel.bgmVolume;
        [self.musicPlayer play];
    }
}
#pragma mark - 剪音乐
-(void)editVideoTopBarCrapBGMHandle
{
    DLog(@"剪音乐");
    //隐藏界面UI
    [self hidenOrShowSubviews:NO];
    if (self.musicPlayer) {
        [self.musicPlayer pause];
    }
    [MusicCrapView showCrapBGMName:self.videoModel.bgmName startTime:self.videoModel.bgmStartTime callBack:^(NSInteger startTime) {
        //显示界面元素
        [self hidenOrShowSubviews:YES];
        self.videoModel.bgmStartTime = startTime;
        [self update_bgm];
    }];
}
#pragma mark - 更新视频/背景音乐音量
-(void)updateVideoAndBGMVolume
{
    self.videoPlayer.volume = self.videoModel.videoVolume;
    if (self.musicPlayer) {
        self.musicPlayer.volume = self.videoModel.bgmVolume;
    }
}
#pragma mark - 音量调整
-(void)editVideoTopBarVolumeHandle
{
    DLog(@"音量调整");
    //隐藏界面UI
    [self hidenOrShowSubviews:NO];
    
    [EditVideoVolumeView showHasBGM:YES originalVolume:self.videoModel.videoVolume bgmVolume:self.videoModel.bgmVolume callBack:^(CGFloat originalVolume, CGFloat bgmVolume) {
        //显示UI
        [self hidenOrShowSubviews:YES];
        self.videoModel.videoVolume = originalVolume;
        self.videoModel.bgmVolume = bgmVolume;
        //更新视频.音频音量
        [self updateVideoAndBGMVolume];
    }];
}
#pragma mark - 选音乐
-(void)editVideoTopBarChooseBGMHandle
{
    DLog(@"选音乐");
    ChooseBGMusicVC * vc = [[ChooseBGMusicVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 音乐选择回调
- (void)bgMusicChooseCallBack:(NSString *)choosedMusicName
{
    DLog(@"选中的背景音乐 %@",choosedMusicName);
    self.videoModel.bgmName = choosedMusicName;
    self.videoModel.bgmStartTime = 0.0;
    [self.topBar updateCrapBGMItemCanUse:YES];
    [self update_bgm];
}
#pragma mark - 特效
-(void)editVideoBottomBarHandleSpecialFilter
{
    DLog(@"特效");
    //隐藏界面UI
    [self hidenOrShowSubviews:NO];
    //暂停播放
    [self updateMovieMusicState_pause:YES];
    //计算预览图层缩放比例
    CGFloat transHeight = Screen_HEIGTH - Width(50) - Width(145) - k_bottom_margin;
    CGFloat transformScale = transHeight / Screen_HEIGTH;
    //计算缩放后需要平移的量
    CGFloat offY = Screen_HEIGTH/2 - transHeight/2 - Width(50);
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transformScale, transformScale);
    CGAffineTransform offYTransform = CGAffineTransformMakeTranslation(0, -offY);;
    CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, offYTransform);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.gpuView.transform = transform;
    }];
    [EditSpecialFilterChoose showWithVideoPath:self.videoModel.shootFinishMergedVideoPath commonFilter:self.commonFilterInfo specialfilter:self.speticalFilterInfo callBack:^(BOOL selected, MHFilterInfo *filterInfo) {
        
        if (selected) {
            self.speticalFilterInfo = filterInfo;
            [self handleFilterChange];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.gpuView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //显示界面UI
            [self hidenOrShowSubviews:YES];
            //重新播放
            [self updateMovieMusicState_pause:NO];
        }];
    }];
}
#pragma mark - 选封面
-(void)editVideoBottomBarHandleChooseCover
{
    DLog(@"选封面");
    //隐藏界面UI
    [self hidenOrShowSubviews:NO];
    //暂停播放
    [self updateMovieMusicState_pause:YES];
    //跳转到封面位置
    [self.gpuMovie.playerItem seekToTime:CMTimeMakeWithSeconds(self.videoModel.videoCaverLocation, NSEC_PER_SEC)];
    
    //计算预览图层缩放比例
    CGFloat transHeight = Screen_HEIGTH - Width(50) - Width(140) - k_bottom_margin;
    CGFloat transformScale = transHeight / Screen_HEIGTH;
    //计算缩放后需要平移的量
    CGFloat offY = Screen_HEIGTH/2 - transHeight/2 - Width(50);
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transformScale, transformScale);
    CGAffineTransform offYTransform = CGAffineTransformMakeTranslation(0, -offY);;
    CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, offYTransform);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.gpuView.transform = transform;
    }];
    [EditChooseCoverView showCoverWithVideoPath:self.videoModel.shootFinishMergedVideoPath curentCoverLocation:self.videoModel.videoCaverLocation commonFilter:self.commonFilter specialfilter:self.specialFilter callBacl:^(BOOL selectedCover, CGFloat coverLocation) {
        
        if (selectedCover) {
            self.videoModel.videoCaverLocation = coverLocation;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.gpuView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //显示界面UI
            [self hidenOrShowSubviews:YES];
            //重新播放
            [self updateMovieMusicState_pause:NO];
        }];
        
    }];
}
#pragma mark - 响应 滤镜变化
-(void)handleFilterChange
{
    [self.gpuMovie removeAllTargets];
    [self.commonFilter removeAllTargets];
    [self.specialFilter removeAllTargets];
    
    GPUImageOutput<GPUImageInput> * commonfilter = [[NSClassFromString(self.commonFilterInfo.filterClassName) alloc] init];
    self.commonFilter = commonfilter;
    GPUImageOutput<GPUImageInput> * specialfilter = [[NSClassFromString(self.speticalFilterInfo.filterClassName) alloc] init];
    self.specialFilter = specialfilter;
    
    [self.gpuMovie addTarget:self.commonFilter];
    [self.commonFilter addTarget:self.specialFilter];
    [self.specialFilter addTarget:self.gpuView];
}
#pragma mark - 滤镜
-(void)editVideoBottomBarHandleCommonFilter
{
    DLog(@"滤镜");
    //隐藏界面UI
    [self hidenOrShowSubviews:NO];
    
    [EditFilterChoose showWithCurentFilter:self.commonFilterInfo callBack:^(MHFilterInfo *filterInfo) {
        self.commonFilterInfo = filterInfo;
        [self handleFilterChange];
    } hidenHanlde:^{
        //显示界面UI
        [self hidenOrShowSubviews:YES];
    }];
}
#pragma mark - 下一步
-(void)editVideoBottomBarHandleNextStep
{
    DLog(@"下一步");
    [MHHUD showLoading];
    if ([self.commonFilterInfo.filterClassName isEqualToString:@"MHGPUImageEmptyFilter"] && [self.speticalFilterInfo.filterClassName isEqualToString:@"MHGPUImageEmptyFilter"]) {
        //两个都是空滤镜 不需要处理 直接添加背景音乐
        [PostVideoModel videoAddBGM_videoUrl:[NSURL fileURLWithPath:self.videoModel.shootFinishMergedVideoPath] originalInfo:self.videoModel callBack:^(BOOL success, NSString *outPurPath) {
            if (success) {
                [MHHUD showSuccess];
                DLog(@"完成！！！！");
                self.videoModel.finalVideoPath = outPurPath;
                [self jumpToPostVC];
                [MHVideoTool mh_writeVideoToPhotosAlbum:[NSURL fileURLWithPath:outPurPath] callBack:^(BOOL success) {
                    
                }];
            }else{
                [MHHUD showError:@"视频处理失败，请稍后再试"];
                DLog(@"失败！！！!");
            }
        }];
    }else{
        //添加滤镜 - 添加滤镜会丢失原始音频
        [self compositionFilterWithCallBack:^(BOOL success, NSURL *outUrl) {
            if (success) {
                [PostVideoModel videoAddBGM_videoUrl:outUrl originalInfo:self.videoModel callBack:^(BOOL success, NSString *outPurPath) {
                    if (success) {
                        [MHHUD showSuccess];
                        DLog(@"完成！！！！");
                        self.videoModel.finalVideoPath = outPurPath;
                        [self jumpToPostVC];
                        [MHVideoTool mh_writeVideoToPhotosAlbum:[NSURL fileURLWithPath:outPurPath] callBack:^(BOOL success) {
                            
                        }];
                    }else{
                        [MHHUD showError:@"视频处理失败，请稍后再试"];
                        DLog(@"失败！！！!");
                    }
                }];
            }else{
                [MHHUD showError:@"视频处理失败，请稍后再试"];
            }
        }];
    }
}
-(void)jumpToPostVC
{
    PostViewController * vc = [[PostViewController alloc] init];
    vc.videoModel = self.videoModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 滤镜合成
-(void)compositionFilterWithCallBack:(void(^)(BOOL success,NSURL * outUrl))callBack
{
    DLog(@"-----开始视频滤镜处理----");
    NSURL * videoUrl = [NSURL fileURLWithPath:self.videoModel.shootFinishMergedVideoPath];
    
    _movieComposition = [[GPUImageMovie alloc] initWithURL:videoUrl];
    _movieComposition.runBenchmark = YES;
    _movieComposition.playAtActualSpeed = NO;
    
    GPUImageOutput<GPUImageInput> * commonFilter = [[NSClassFromString(self.commonFilterInfo.filterClassName) alloc] init];
    GPUImageOutput<GPUImageInput> * specialFilter = [[NSClassFromString(self.speticalFilterInfo.filterClassName) alloc] init];
    
    [_movieComposition addTarget:commonFilter];
    [commonFilter addTarget:specialFilter];
    
    //合成后的视频路径
    NSString * outPath = [PostVideoModel creatAVideoTempPath];
    NSLog(@"添加滤镜后的保存路径：%@",outPath);
    NSURL * outPutUrl = [NSURL fileURLWithPath:outPath];
    
    //视频角度
    NSUInteger a = [MHVideoTool mh_getDegressFromVideoWithURL:videoUrl];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(a / 180.0 * M_PI );
    //获取视频尺寸
    CGSize videoSize = [MHVideoTool mh_getVideoSize:videoUrl];
    if (a == 90 || a == 270) {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    videoSize = [MHVideoTool mh_fixVideoOutPutSize:videoSize];
    NSLog(@"size:%f-%f",videoSize.width,videoSize.height);
    
    _movieWriter  = [[GPUImageMovieWriter alloc] initWithMovieURL:outPutUrl size:videoSize];
    _movieWriter.transform = rotate;
    _movieWriter.shouldPassthroughAudio = YES;
    //有时候会因为视频文件没有音频轨道报错.....不知道为啥
    _movieComposition.audioEncodingTarget = nil;
    
    [specialFilter addTarget:_movieWriter];
    
    [_movieComposition enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieComposition startProcessing];
    
    __weak GPUImageMovieWriter *weakmovieWriter = _movieWriter;
    [_movieWriter setCompletionBlock:^{
        DLog(@"滤镜添加成功");
        [specialFilter removeAllTargets];
        [commonFilter removeAllTargets];
        [weakmovieWriter finishRecording];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            callBack(YES,outPutUrl);
        });
    }];
    [_movieWriter setFailureBlock:^(NSError *error) {
        [specialFilter removeAllTargets];
        [commonFilter removeAllTargets];
        [weakmovieWriter finishRecording];
        DLog(@"滤镜添加失败 %@",error.description);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            callBack(NO,nil);
        });
    }];
}
#pragma mark - 子UI显示/隐藏
-(void)hidenOrShowSubviews:(BOOL)show
{
    CGFloat alpha = show ? 1.0 : 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.topBar.alpha = alpha;
        self.bottomBar.alpha = alpha;
    }];
}
#pragma mark - 初始化页面子UI
-(void)commit_subViews
{
    self.topBar = [[EditVideoTopBar alloc] initWithFrame:CGRectMake(0, K_StatusHeight, Screen_WIDTH, Width(60))];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    [self.topBar updateCrapBGMItemCanUse:self.videoModel.bgmName.length > 0 ? YES : NO];
    
    self.bottomBar = [[EditVideoBottomBar alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - k_bottom_margin - Width(75), Screen_WIDTH, Width(60))];
    self.bottomBar.delegate = self;
    [self.view addSubview:self.bottomBar];
}
#pragma mark - 返回按钮点击
-(void)editVideoTopBarBackItemHandle
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 移除通知
-(void)removeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
