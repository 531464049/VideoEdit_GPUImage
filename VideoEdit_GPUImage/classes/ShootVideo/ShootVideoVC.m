//
//  ShootVideoVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "ShootVideoVC.h"
#import "MyFilter.h"
#import "PostVideoModel.h"
#import "ShootProgressBar.h"
#import "ShootMusicBar.h"
#import "ShootRightBar.h"
#import "ShootBottomBar.h"
#import "FastSlowChooseView.h"
#import "ShootFilterChooseView.h"
#import "ChooseBGMusicVC.h"
#import "MusicCrapView.h"
#import "CountDownBar.h"

#import "EditVideoVC.h"

#import "PostViewController.h"

#define TIMER_INTERVAL  0.05    //定时器时间间隔
#define MAX_VIDEOTIME  15.f     //视频最大录制时长

@interface ShootVideoVC ()<ShootRightBarDelegate,ShootBottomBarDelegate,FastSlowChooseDelegate,ChooseBGMusicDelegate>
{
    GPUImageMovieWriterEx * _movieWriter;//输出控制
}
@property(nonatomic,strong)PostVideoModel * videoModel;//保存视频信息的模型
@property(strong, nonatomic)UIImageView * imgView;//相机layer
@property(nonatomic, strong)GPUImageVideoCameraEx * videoCamera;//拍视频-相机
@property(nonatomic,strong)GPUImageStillCamera * photoCamera;//拍照-相机
@property(nonatomic, strong)GPUImageView * videoPreView; //相机预览图层
@property(nonatomic,strong)GPUImageOutput<GPUImageInput> * filter;//当前选择滤镜
@property(nonatomic, strong)FSKGPUImageBeautyFilter * beautifyFilter;//BeautifyFace美颜滤镜

@property(nonatomic,strong)MHFilterInfo * curentFilterInfo;//当前滤镜信息(默认空白滤镜)
@property(nonatomic,strong)MHBeautifyInfo * curentBeautifyInfo;//当前美颜参数(默认参数)

@property(nonatomic,assign)MHShootSpeedType videoSpeedType;//当前选择拍摄速度 默认标准速度

@property(nonatomic,strong)UIButton * quit_Btn;//退出 按钮
@property(nonatomic,strong)ShootProgressBar * progressBar;//拍摄进度bar
@property(nonatomic,strong)ShootMusicBar * musicBar;//顶部背景音乐bar
@property(nonatomic,strong)ShootRightBar * rightBar;//右侧功能按钮集合
@property(nonatomic,strong)ShootBottomBar * bottomBar;//底部功能按钮集合
@property(nonatomic,strong)FastSlowChooseView * fastSlowBar;//快慢速bar
@property(nonatomic,strong)UIImageView * focusView;//聚焦图层(动画)

@property(nonatomic,assign)BOOL isTakePhotoType;//是否是拍照模式
@property(nonatomic,assign)BOOL isRecoding;//是否在录制
@property(nonatomic,strong)NSTimer * timer;//录制定时器
@property(nonatomic,assign)CGFloat curentRecodlength;//当前录制长度（时间）

@property(nonatomic,assign)CGFloat counrDownPauseTime;//倒计时暂停时间 默认15秒（不需要处理）

@end

@implementation ShootVideoVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [MHStatusBarHelper updateStatuesBarHiden:YES];
    if (self.isTakePhotoType) {
        if (self.photoCamera) {
            [self.photoCamera startCameraCapture];
        }
    }else{
        if (self.videoCamera) {
            [self.videoCamera startCameraCapture];
        }
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isTakePhotoType) {
        if (self.photoCamera) {
            [self.photoCamera stopCameraCapture];
        }
    }else{
        if (self.videoCamera) {
            [self.videoCamera stopCameraCapture];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //清理视频缓存
    [PostVideoModel cleanShootTempCache];
    
    //先获取权限
    [MHGetPermission getCaptureAndRecodPermission:^(BOOL hasCapturePermiss, BOOL hasRecodPermiss) {
        if (hasCapturePermiss) {
            //只要有相机权限就可以了
            //初始化控制器信息
            [self commit_controlInfo];
            //初始化相机
            [self commit_videoCamera];
            //初始化界面UI
            [self commitSubViews];
            
        }else{
            //提示需要权限-设置-权限
            [self cancle_item_click];
            [MAlertView showAlertIn:self msg:@"请前往设置-允许**获取相机/麦克风权限" callBack:^(BOOL sure) {
                if (sure) {
                    //跳转 - 设置
                }else{
                    [self cancle_item_click];
                }
            }];
        }
    }];

}
#pragma mark - 初始化控制器信息
-(void)commit_controlInfo
{
    //暂时未考虑从其他页面传递过来的视频信息（ps：从草稿箱过来时，需要根据草稿箱内容赋值页面和数据）
    self.curentRecodlength = 0.f;
    self.counrDownPauseTime = 15.0;
    self.isTakePhotoType = NO;
    //默认拍摄速度
    self.videoSpeedType = MHShootSpeedTypeNomal;
    //初始化model
    self.videoModel = [[PostVideoModel alloc] init];
    
    //初始化默认滤镜信息
    self.curentFilterInfo = [MHFilterInfo customEmptyInfo];
    self.curentBeautifyInfo = [MHBeautifyInfo customBeautifyInfo];
    
    //初始化默认滤镜（空滤镜）
    self.filter = [[MHGPUImageEmptyFilter alloc] init];
    
    //初始化美颜滤镜(默认参数)
    self.beautifyFilter = [[FSKGPUImageBeautyFilter alloc] init];
    self.beautifyFilter.beautyLevel = self.curentBeautifyInfo.beautyLevel;//美颜程度
    self.beautifyFilter.brightLevel = self.curentBeautifyInfo.brightLevel;//美白程度
    self.beautifyFilter.toneLevel = self.curentBeautifyInfo.toneLevel;//色调强度
}
#pragma mark - 初始化界面UI
-(void)commitSubViews
{
    //退出按钮
    self.quit_Btn = [UIButton buttonWithType:0];
    [self.quit_Btn setImage:[UIImage imageNamed:@"common_close"] forState:0];
    [self.quit_Btn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateHighlighted];
    self.quit_Btn.frame = CGRectMake(Width(15), K_StatusHeight + Width(15), Width(40), Width(40));
    [self.quit_Btn addTarget:self action:@selector(cancle_item_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.quit_Btn];
    
    //拍摄进度bar
    self.progressBar = [[ShootProgressBar alloc] initWithFrame:CGRectMake(Width(10), Width(10), Screen_WIDTH - Width(20), Width(5))];
    [self.view addSubview:self.progressBar];
    
    //顶部背景音乐bar
    self.musicBar = [[ShootMusicBar alloc] initWithFrame:CGRectMake(0, 0, Width(40) + Width(80), Width(40))];
    self.musicBar.center = CGPointMake(Screen_WIDTH/2, K_StatusHeight + Width(15) + Width(20));
    [self.musicBar.chooseMusicBtn addTarget:self action:@selector(jumpToChooseMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.musicBar];
    
    //右侧按钮集合
    self.rightBar = [[ShootRightBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width - Width(50)-Width(15), K_StatusHeight + Width(15), Width(50), (Width(50) + Width(10))*6)];
    self.rightBar.delegate = self;
    [self.view addSubview:self.rightBar];
    //默认后置摄像头 显示闪光灯按钮 闪光灯默认关闭
    [self.rightBar updateIsTakePhotoState:NO];
    [self.rightBar updateVaptureDivicePosition:AVCaptureDevicePositionBack];
    [self.rightBar updateTouchModeState:AVCaptureTorchModeOff];
    
    //底部按钮集合
    self.bottomBar = [[ShootBottomBar alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - Width(150) - k_bottom_margin, Screen_WIDTH, Width(150))];
    self.bottomBar.delegate = self;
    [self.view addSubview:self.bottomBar];
}
#pragma mark - 初始化相机信息
-(void)commit_videoCamera
{
    //相机图层layer
    if (!self.imgView) {
        self.imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imgView.clipsToBounds = YES;
        [self.view addSubview:self.imgView];
        
        //添加聚焦手势
        self.imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * pinch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFocusAction:)];
        [self.imgView addGestureRecognizer:pinch];
    }
    
    //初始化相机 默认后置摄像头
    if (!self.videoCamera) {
        self.videoCamera = [[GPUImageVideoCameraEx alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        // 该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
        [self.videoCamera addAudioInputsAndOutputs];
    }
    
    //初始化相机预览图层
    if (!self.videoPreView) {
        self.videoPreView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.imgView.frame.size.width, self.imgView.frame.size.height)];
        self.videoPreView.backgroundColor = [UIColor blackColor];
        self.videoPreView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [self.imgView addSubview:self.videoPreView];
    }
    
    if (self.videoCamera) {
        [self.videoCamera startCameraCapture];
    }
    
    //更新滤镜
    [self updateCamareFilters];
}
#pragma mark - 更新滤镜
-(void)updateCamareFilters
{
    if (self.videoCamera) {
        [self.videoCamera removeAllTargets];
    }
    if (self.photoCamera) {
        [self.photoCamera removeAllTargets];
    }
    [self.filter removeAllTargets];
    [self.beautifyFilter removeAllTargets];
    
    GPUImageOutput<GPUImageInput> * afilter = [[NSClassFromString(self.curentFilterInfo.filterClassName) alloc] init];
    self.filter = afilter;
    
    self.beautifyFilter.beautyLevel = self.curentBeautifyInfo.beautyLevel;
    self.beautifyFilter.brightLevel = self.curentBeautifyInfo.brightLevel;
    self.beautifyFilter.toneLevel = self.curentBeautifyInfo.toneLevel;
    
    if (self.isTakePhotoType && self.photoCamera) {
        [self.photoCamera addTarget:self.beautifyFilter];
    }else if (self.videoCamera) {
        [self.videoCamera addTarget:self.beautifyFilter];
    }
    
    [self.beautifyFilter addTarget:self.filter];
    [self.filter addTarget:self.videoPreView];
}
#pragma mark - 初始化拍照相机
-(void)commit_photoCamare
{
    if (!self.photoCamera) {
        self.photoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        self.photoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.photoCamera.horizontallyMirrorFrontFacingCamera = YES;
    }
    if (self.photoCamera) {
        [self.photoCamera startCameraCapture];
    }
    [self updateCamareFilters];
}
#pragma mark - 拍摄方式变更
-(void)shootBottomBarHandle_takeTypeChange:(MHShootType)shootType
{
    if (shootType == MHShootTypeTakePhoto) {
        //切换到拍照模式
        self.isTakePhotoType = YES;
        if (self.videoCamera) {
            [self.videoCamera stopCameraCapture];
        }
        DLog(@"切换到拍照模式");
        [self commit_photoCamare];
        
        //更改页面UI-隐藏进度，音乐选择 改变右侧按钮状态
        self.progressBar.hidden = YES;
        self.musicBar.hidden = YES;
        [self.rightBar updateIsTakePhotoState:YES];
    }else{
        //切换到拍视频模式
        self.isTakePhotoType = NO;
        if (self.photoCamera) {
            [self.photoCamera stopCameraCapture];
        }
        DLog(@"切换到拍视频模式");
        [self commit_videoCamera];
        
        //更新页面UI
        self.progressBar.hidden = NO;
        self.musicBar.hidden = NO;
        [self.rightBar updateIsTakePhotoState:NO];
    }
}
#pragma mark - 快慢速选择回调
-(void)fastSlowChooseCallBack:(MHShootSpeedType)speedType
{
    DLog(@"快慢速选择回调");
    self.videoSpeedType = speedType;
}
#pragma mark - 开始/继续 视频录制
-(void)shootBottomBarHandle_startRecode
{
    DLog(@"开始视频录制");
    NSLog(@"当前已录制时间：%f",self.curentRecodlength);
    //判断已录制视频时长，超过最大时间
    if (self.curentRecodlength >= MAX_VIDEOTIME) {
        NSLog(@"到最大时间了......");
        self.counrDownPauseTime = MAX_VIDEOTIME;
        return;
    }
    //添加一个子视频模型
    ShootSubVideo * subModel = [self.videoModel addSubVideoInfoWithSpeedType:self.videoSpeedType];
    //本地保存视频地址
    NSURL *movieURL = [NSURL fileURLWithPath:subModel.subVideoPath];
    //视频尺寸
    CGSize movieSize = CGSizeMake(ceil([UIScreen mainScreen].bounds.size.width / 16) * 16, ceil([UIScreen mainScreen].bounds.size.height / 16) * 16);
    
    //初始化movieWriter
    _movieWriter = [[GPUImageMovieWriterEx alloc] initWithMovieURL:movieURL size:movieSize];
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;
    _movieWriter.hasAudioTrack = YES;
    _movieWriter.assetWriter.movieFragmentInterval = kCMTimeInvalid;
    
    [self.filter addTarget:_movieWriter];
    self.videoCamera.audioEncodingTarget = _movieWriter;
    [_movieWriter startRecording];
        
    
    //定时器开启
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //按钮动画开启
    [self.bottomBar startShootBtnAnimation];
    //通知底部bar 开始拍摄过程 禁用拍照模式
    self.bottomBar.isRecodVideoProgress = YES;
    //禁用选择音乐
    self.musicBar.barCanUse = NO;
    //隐藏（不可用）其他界面元素
    [UIView animateWithDuration:0.3 animations:^{
        self.quit_Btn.alpha = 0.0;
        self.musicBar.alpha = 0.0;
        self.rightBar.alpha = 0.0;
        self.fastSlowBar.alpha = 0.0;
    }];
}
#pragma mark - 暂停/结束 视频录制
-(void)shootBottomBarHandle_endRecode
{
    DLog(@"结束视频录制");
    //销毁定时器
    [self dealloc_timer];
    self.counrDownPauseTime = MAX_VIDEOTIME;
    
    [self.filter removeTarget:_movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [_movieWriter finishRecording];

    
    //按钮动画停止
    [self.bottomBar stopShootBtnAnimation];
    //进度条添加一个段落标记
    [self.progressBar addSpecItem];
    //恢复页面其他按钮状态
    [UIView animateWithDuration:0.3 animations:^{
        self.quit_Btn.alpha = 1.0;
        self.musicBar.alpha = 1.0;
        self.rightBar.alpha = 1.0;
        self.fastSlowBar.alpha = 1.0;
    }];
    //更新删除/完成按钮可用状态
    [self.bottomBar updateDeleteFinisheCanUse:YES];
}
#pragma mark - 删除上一段视频
- (void)shootBottomBarHandle_deleateLastVideo
{
    //删除上一段子视频信息
    [self.videoModel removeLastSubVideoInfo];
    //删除上一个节点
    [self.progressBar removeLastSpecItem];
    
    //重置当前录制时长
    self.curentRecodlength = self.progressBar.shootProgress * MAX_VIDEOTIME;
    
    if (self.curentRecodlength == 0.f) {
        //删完了
        //通知底部bar 可以选择拍照模式了
        self.bottomBar.isRecodVideoProgress = NO;
        [self.bottomBar updateRecodeState:NO];
        //启用选择音乐
        self.musicBar.barCanUse = YES;
        //更新删除/完成按钮可用状态
        [self.bottomBar updateDeleteFinisheCanUse:NO];
    }
}
#pragma mark - 确认使用当前拍摄视频
- (void)shootBottomBarHandle_sureUseVideo
{
    [MHHUD showLoading];
    //开始视频变速+合并
    [PostVideoModel compositionSubVideos:self.videoModel.subVideoInfos callBack:^(BOOL success, NSString *outPurPath) {
        [MHHUD finishedLoading];
        if (success) {
            DLog(@"成功======     %@",outPurPath);
            self.videoModel.shootFinishMergedVideoPath = outPurPath;
            /*
            [MHVideoTool mh_writeVideoToPhotosAlbum:[NSURL fileURLWithPath:outPurPath] callBack:^(BOOL success) {
                
            }];
             */
            
            EditVideoVC * vc = [[EditVideoVC alloc] init];
            vc.videoModel = self.videoModel;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            DLog(@"最终还是失败了额");
        }
    }];
}
#pragma mark - 拍摄进程定时器响应
-(void)timer_handle
{
    self.curentRecodlength += TIMER_INTERVAL;
    //更新进度条
    [self.progressBar updateShootPregress:self.curentRecodlength/MAX_VIDEOTIME];

    //更新顶部进度
    if (self.curentRecodlength >= MAX_VIDEOTIME) {
        //到达最大录制时长 结束录制
        [self shootBottomBarHandle_endRecode];
        
        //到最大长度时，默认使用视频
        [self shootBottomBarHandle_sureUseVideo];
    }else{
        
        if (self.counrDownPauseTime < MAX_VIDEOTIME) {
            //中间需要暂停
            NSInteger pauseTime = self.counrDownPauseTime * 10;
            NSInteger curentTime = self.curentRecodlength * 10;
            if (pauseTime == curentTime) {
                //暂停/结束
                [self shootBottomBarHandle_endRecode];
            }
        }
    }
}
#pragma mark - 创建定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timer_handle) userInfo:nil repeats:YES];
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
#pragma mark - 跳转 选择音乐
-(void)jumpToChooseMusic
{
    DLog(@"跳转 选择音乐");
    ChooseBGMusicVC * vc = [[ChooseBGMusicVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 音乐选择回调
- (void)bgMusicChooseCallBack:(NSString *)choosedMusicName
{
    DLog(@"选中的背景音乐 %@",choosedMusicName);
    self.videoModel.bgmName = choosedMusicName;
    [self.musicBar updateChooseMusicName:choosedMusicName];
    [self.rightBar updateCrapMusicItemShow:YES];
}
#pragma mark - 拍照
-(void)shootBottomBarHandle_takePhoto
{
    DLog(@"拍照");
    if (!self.photoCamera) {
        return;
    }
    [self.photoCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if (processedJPEG) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    DLog(@"以保存到相册");
                }else{
                    DLog(@"保存到相册-失败");
                }
            }];
        }
    }];
}
#pragma mark - 聚焦
- (void)onFocusAction:(UIPanGestureRecognizer *)sender
{
    DLog(@"聚焦");
    CGPoint point = [sender locationInView:self.view];
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake(point.y /size.height ,1-point.x/size.width);
    
    NSError *error;
    if([self.videoCamera.inputCamera lockForConfiguration:&error]){
        if ([self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.videoCamera.inputCamera setFocusPointOfInterest:focusPoint];
            [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
    else {
        NSLog(@"聚焦 ERROR = %@", error);
    }
    self.focusView.center = point;
    self.focusView.hidden = NO;
    self.focusView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    [UIView animateWithDuration:0.5 animations:^{
        self.focusView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusView.hidden = YES;
    }];
}
#pragma mark - 切换前后摄像头
-(void)shootRightBarHandle_changeBackFront
{
    DLog(@"切换前后摄像头");
    if (self.isTakePhotoType) {
        if (self.photoCamera) {
            [self.photoCamera rotateCamera];
            [self.rightBar updateVaptureDivicePosition:self.photoCamera.inputCamera.position];
            [self.rightBar updateTouchModeState:self.photoCamera.inputCamera.torchMode];
        }
    }else{
        if (self.videoCamera) {
            [self.videoCamera rotateCamera];
            [self.rightBar updateVaptureDivicePosition:self.videoCamera.inputCamera.position];
            [self.rightBar updateTouchModeState:self.videoCamera.inputCamera.torchMode];
        }
    }
}
#pragma mark - 显示快慢速
-(void)shootRightBarHandle_showFastSlow
{
    DLog(@"显示/隐藏快慢速");
    self.fastSlowBar.hidden = !self.fastSlowBar.hidden;
}
#pragma mark - 隐藏界面全部元素
-(void)handleAllElementHiden:(BOOL)hiden
{
    CGFloat alpha = hiden ? 0.0 : 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.quit_Btn.alpha = alpha;
        self.musicBar.alpha = alpha;
        self.rightBar.alpha = alpha;
        self.bottomBar.alpha = alpha;
        self.fastSlowBar.alpha = alpha;
    }];
}
#pragma mark - 显示美化列表
-(void)shootRightBarHandle_showBeautify
{
    DLog(@"显示美化列表");
    //隐藏界面全部元素
    [self handleAllElementHiden:YES];
    
    [ShootFilterChooseView showFilterWithFilterInfo:self.curentFilterInfo beautifyInfo:self.curentBeautifyInfo callBack:^(MHFilterInfo *filterinfo, MHBeautifyInfo *beautifyInfo) {
        //选择滤镜/修改美颜参数 回调
        self.curentFilterInfo = filterinfo;
        self.curentBeautifyInfo = beautifyInfo;
        [self updateCamareFilters];
        
    } hidenHandle:^{
        //退出回调
        //显示界面元素
        [self handleAllElementHiden:NO];
    }];
}
#pragma mark - 显示倒计时选择界面
-(void)shootRightBarHandle_showTimer
{
    DLog(@"显示倒计时选择界面");
    //隐藏界面元素
    [self handleAllElementHiden:YES];
    [CountDownBar showWithCurentLength:self.curentRecodlength callBack:^(BOOL needCountDown, CGFloat pauseTime) {
        
        if (needCountDown) {
            DLog(@"倒计时     暂停时间-%f",pauseTime);
            self.counrDownPauseTime = pauseTime;
            
            self.progressBar.alpha = 0.0;
            [CountDownTimer showCounrDownTimerWIthCallBack:^{
                DLog(@"开始拍摄");
                //显示界面元素
                self.progressBar.alpha = 1.0;
                [self handleAllElementHiden:NO];
                
                [self shootBottomBarHandle_startRecode];
                
            }];
            
        }else{
            //显示界面元素
            [self handleAllElementHiden:NO];
        }
        
    }];
}
#pragma mark - 显示音乐裁剪界面
-(void)shootRightBarHandle_showCripMusic
{
    DLog(@"显示音乐裁剪界面");
    //隐藏界面元素
    [self handleAllElementHiden:YES];
    
    [MusicCrapView showCrapBGMName:self.videoModel.bgmName startTime:self.videoModel.bgmStartTime callBack:^(NSInteger startTime) {
        //显示界面元素
        [self handleAllElementHiden:NO];
        self.videoModel.bgmStartTime = startTime;
    }];
}
#pragma mark - 闪光灯按钮点击
-(void)shootRightBarHandle_torchMode
{
    DLog(@"闪光灯按钮点击");
    if (self.isTakePhotoType) {
        AVCaptureDevice *captureDevice = self.photoCamera.inputCamera;
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            
            if (captureDevice.torchMode == AVCaptureTorchModeOff) {
                if ([captureDevice isTorchModeSupported:AVCaptureTorchModeAuto]){
                    [captureDevice setTorchMode:AVCaptureTorchModeAuto];
                }
            }else if (captureDevice.torchMode == AVCaptureTorchModeAuto) {
                if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]){
                    [captureDevice setTorchMode:AVCaptureTorchModeOn];
                }
            }else{
                if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOff]){
                    [captureDevice setTorchMode:AVCaptureTorchModeOff];
                }
            }
            
            [captureDevice unlockForConfiguration];
            
            //改变闪光灯按钮状态
            [self.rightBar updateTouchModeState:captureDevice.torchMode];
        }
    }else{
        AVCaptureDevice *captureDevice = self.videoCamera.inputCamera;
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            if (captureDevice.torchMode == AVCaptureTorchModeOn) {
                if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOff]){
                    [captureDevice setTorchMode:AVCaptureTorchModeOff];
                }
            }else{
                if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]){
                    [captureDevice setTorchMode:AVCaptureTorchModeOn];
                }
            }
            [captureDevice unlockForConfiguration];
            //改变闪光灯按钮状态
            [self.rightBar updateTouchModeState:captureDevice.torchMode];
        }
    }
}
#pragma mark - 从相册选择
-(void)shootBottomBarHandle_chooseFromAlbum
{
    DLog(@"从相册选择");
}
#pragma mark - 退出
-(void)cancle_item_click
{
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"testEditVideo" ofType:@"mp4"];
//    self.videoModel.finalVideoPath = path;
//
//    PostViewController * vc = [[PostViewController alloc] init];
//    vc.videoModel = self.videoModel;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark - get
#pragma mark - 聚焦图层 get
- (UIImageView *)focusView
{
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _focusView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.image = [UIImage imageNamed:@"video_focus"];
        [self.view addSubview:_focusView];
        _focusView.hidden = YES;
    }
    return _focusView;
}
#pragma mark - 快慢速 get
- (FastSlowChooseView *)fastSlowBar
{
    if (!_fastSlowBar) {
        _fastSlowBar = [[FastSlowChooseView alloc] initWithFrame:CGRectMake(Width(35), Screen_HEIGTH - k_bottom_margin - Width(150) - Width(20) - Width(36), Screen_WIDTH - Width(35)*2, Width(36))];
        _fastSlowBar.hidden = YES;
        _fastSlowBar.delegate = self;
        [self.view addSubview:_fastSlowBar];
    }
    return _fastSlowBar;
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
