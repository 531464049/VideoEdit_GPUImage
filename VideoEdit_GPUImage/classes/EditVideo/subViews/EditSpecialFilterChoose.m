//
//  EditSpecialFilterChoose.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/27.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditSpecialFilterChoose.h"
#import "FilterChooseView.h"

@interface EditSpecialFilterChoose()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,copy)NSString * videoPath;
@property(nonatomic,strong)MHFilterInfo * commonFilterInfo;
@property(nonatomic,strong)MHFilterInfo * specialFilterInfo;
@property(nonatomic,copy)SpecialFilterChooseCallBack callBack;


@property(strong, nonatomic)AVPlayer * videoPlayer;//视频播放
@property (nonatomic,strong)GPUImageMovie * gpuMovie;//滤镜效果展示movie
@property (nonatomic,strong)GPUImageView * gpuView;//视频预览图层

@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * commonFilter;//新添加的普通滤镜
@property (nonatomic,strong)GPUImageOutput<GPUImageInput> * specialFilter;//新添加的特效滤镜


//滤镜展示collectionView
@property(nonatomic,strong)UICollectionView * filterCollectionView;
@property(nonatomic,strong)NSArray * dataArr;//展示数据

@end

@implementation EditSpecialFilterChoose

-(instancetype)initWithFrame:(CGRect)frame VideoPath:(NSString *)videoPath commonFilter:(MHFilterInfo *)commonFilterInfo specialfilter:(MHFilterInfo *)specialFilterInfo callBack:(SpecialFilterChooseCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoPath = videoPath;
        self.commonFilterInfo = commonFilterInfo;
        self.specialFilterInfo = specialFilterInfo;
        self.callBack = callBack;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self commit_movieView];
            [self commit_subViews];
        });
    }
    return self;
}
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
    
    GPUImageOutput<GPUImageInput> * commonfilter = [[NSClassFromString(self.commonFilterInfo.filterClassName) alloc] init];
    GPUImageOutput<GPUImageInput> * specialfilter = [[NSClassFromString(self.specialFilterInfo.filterClassName) alloc] init];
    self.commonFilter = commonfilter;
    self.specialFilter = specialfilter;
    
    [self.gpuMovie addTarget:self.commonFilter];
    [self.commonFilter addTarget:self.specialFilter];
    [self.specialFilter addTarget:self.gpuView];
    
    [self.videoPlayer play];
    [self.gpuMovie startProcessing];
    
    //计算预览图层缩放比例
    CGFloat transHeight = Screen_HEIGTH - Width(50) - Width(145) - k_bottom_margin;
    CGFloat transformScale = transHeight / Screen_HEIGTH;
    //计算缩放后需要平移的量
    CGFloat offY = Screen_HEIGTH/2 - transHeight/2 - Width(50);
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transformScale, transformScale);
    CGAffineTransform offYTransform = CGAffineTransformMakeTranslation(0, -offY);
    CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, offYTransform);
    self.gpuView.transform = transform;
    
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
    [self.gpuMovie startProcessing];
}
#pragma mark - 初始化UI
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
    
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - (Width(145) + k_bottom_margin), Screen_WIDTH, Width(145) + k_bottom_margin)];
    [self addSubview:contentView];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = contentView.bounds;
    [contentView addSubview:effectView];
    
    UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.frame = CGRectMake(Width(15), 0, 120, Width(45));
    lab.text = @"滤镜特效";
    [contentView addSubview:lab];
    
    //读取数据
    self.dataArr = [FilterHelper readAllSpecialFiltersArr];
    //collection
    CGFloat itemWidth = Width(70);
    CGFloat itemHeight = contentView.frame.size.height - Width(45);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Width(45), contentView.frame.size.width, itemHeight) collectionViewLayout:layout];
    self.filterCollectionView.backgroundColor = [UIColor clearColor];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.showsVerticalScrollIndicator = NO;
    self.filterCollectionView.showsHorizontalScrollIndicator = NO;
    [self.filterCollectionView registerClass:[FilterPreCell class] forCellWithReuseIdentifier:@"nmjhyfgdvhfdhmkko"];
    [contentView addSubview:self.filterCollectionView];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterPreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nmjhyfgdvhfdhmkko" forIndexPath:indexPath];
    MHFilterInfo * model = (MHFilterInfo *)self.dataArr[indexPath.row];
    BOOL isS = [self.specialFilterInfo.filterClassName isEqualToString:model.filterClassName];
    cell.model = model;
    cell.is_Selected = isS;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHFilterInfo * filterInfo = (MHFilterInfo *)self.dataArr[indexPath.row];
    self.specialFilterInfo = filterInfo;
    [self.filterCollectionView reloadData];
    
    
    [self.gpuMovie removeAllTargets];
    [self.commonFilter removeAllTargets];
    [self.specialFilter removeAllTargets];
    
    GPUImageOutput<GPUImageInput> * specialfilter = [[NSClassFromString(self.specialFilterInfo.filterClassName) alloc] init];
    self.specialFilter = specialfilter;
    
    [self.gpuMovie addTarget:self.commonFilter];
    [self.commonFilter addTarget:self.specialFilter];
    [self.specialFilter addTarget:self.gpuView];
}
#pragma mark - 取消
-(void)cancleItemClick
{
    self.callBack(NO, nil);
    [self removeAll];
}
#pragma mark - 确认
-(void)sureItemClick
{
    self.callBack(YES, self.specialFilterInfo);
    [self removeAll];
}
-(void)removeAll
{
    [self.gpuMovie endProcessing];
    [self.gpuView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    if (self.videoPlayer) {//暂停
        [self.videoPlayer pause];
        self.videoPlayer = nil;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showWithVideoPath:(NSString *)videoPath commonFilter:(MHFilterInfo *)commonFilterInfo specialfilter:(MHFilterInfo *)specialFilterInfo callBack:(SpecialFilterChooseCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    for (UIView * subView in keywindow.subviews) {
        if ([subView isKindOfClass:[EditSpecialFilterChoose class]]) {
            [subView removeFromSuperview];
        }
    }
    
    EditSpecialFilterChoose * view = [[EditSpecialFilterChoose alloc] initWithFrame:keywindow.bounds VideoPath:videoPath commonFilter:commonFilterInfo specialfilter:specialFilterInfo callBack:callBack];
    [keywindow addSubview:view];
}

@end
