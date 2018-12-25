//
//  PostVideoModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "PostVideoModel.h"

/** 视频本地临时文件夹 */
static NSString * shortSubVideoTempDoc() {
    NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * docPath = [document stringByAppendingPathComponent:@"shootVideoTempDoc"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:docPath]){
            [fileManage createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return docPath;
}
/** 视频本地临时路径 */
static NSString * gatAVideoTempPath() {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"video_%f.mov",time];
    NSString *subPath = [shortSubVideoTempDoc() stringByAppendingPathComponent:fileName];
    if([fileManage fileExistsAtPath:subPath]){
        [fileManage removeItemAtPath:subPath error:nil];
    }
    return subPath;
}

@implementation PostVideoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoVolume = 1.0;
        self.bgmVolume = 1.0;
        self.videoCaverLocation = 0.0;
    }
    return self;
}
#pragma mark - 根据视频拍摄速度 添加一个子视频模型 同时再返回当前添加模型
- (ShootSubVideo *)addSubVideoInfoWithSpeedType:(MHShootSpeedType)videoSpeedType
{
    ShootSubVideo * subModel = [[ShootSubVideo alloc] init];
    subModel.videoSpeedType = videoSpeedType;
    
    unlink([subModel.subVideoPath UTF8String]);// 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
    
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.subVideoInfos];
    [arr addObject:subModel];
    self.subVideoInfos = [NSArray arrayWithArray:arr];
    
    return subModel;
}
#pragma mark - 删除上一段子视频
- (void)removeLastSubVideoInfo
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.subVideoInfos];
    if (arr.count > 0) {
        [arr removeLastObject];
    }
    self.subVideoInfos = [NSArray arrayWithArray:arr];
}
#pragma mark - 计算全部子视频 视频时长总和
-(CGFloat)getAllSubVideoInfoVideoLength
{
    CGFloat totleLength = 0.f;
    for (ShootSubVideo * subvideo in self.subVideoInfos) {
        totleLength += subvideo.videolength;
    }
    return totleLength;
}
- (CGFloat)shootFinishVideolength
{
    if (!self.shootFinishMergedVideoPath) {
        return 0.f;
    }
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.shootFinishMergedVideoPath]];
    CGFloat length = (CGFloat)asset.duration.value/(CGFloat)asset.duration.timescale;
    return length;
}
#pragma mark - 对拍摄后的子视频进行变速+合并
+(void)compositionSubVideos:(NSArray<ShootSubVideo *> *)subVideoInfos callBack:(void (^)(BOOL, NSString *))callBack
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PostVideoModel changeSpeedVideo:subVideoInfos callBack:^(NSArray * changedSpeedVideoPathArr) {
            DLog(@"速度改变后的子视频数组：%@",changedSpeedVideoPathArr);
            NSString * videoPath = gatAVideoTempPath();
            NSURL * outPutUrl = [NSURL fileURLWithPath:videoPath];
            [MHVideoTool mergeVideosWithPaths:changedSpeedVideoPathArr outPutUrl:outPutUrl callBack:^(BOOL success, NSURL *outPurUrl) {
                callBack(success,outPurUrl.path);
            }];
            
        }];
    });

}
+(void)changeSpeedVideo:(NSArray<ShootSubVideo *> *)subVideoInfos callBack:(void(^)(NSArray *))callBack
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int j = 0; j < subVideoInfos.count; j ++) {
        [arr addObject:@""];
    }
    
    for (int i = 0; i < subVideoInfos.count; i ++) {
        ShootSubVideo * subVideo = (ShootSubVideo *)subVideoInfos[i];
        NSURL * videoUrl = [NSURL fileURLWithPath:subVideo.subVideoPath];
        [PostVideoModel changeSpeedVideoUrl:videoUrl speed:[PostVideoModel videoSpeedFor:subVideo.videoSpeedType] videoindex:i callBack:^(BOOL success, NSString *outUrlPath, NSInteger videoIndex) {
            [arr replaceObjectAtIndex:videoIndex withObject:outUrlPath];
            
            //判断是否全部处理完
            BOOL isFinished = YES;
            for (NSString * subInfo in arr) {
                if ([subInfo isEqualToString:@""]) {
                    isFinished = NO;
                    break;
                }
            }
            if (isFinished) {
                callBack([NSArray arrayWithArray:arr]);
                return;
            }
            
        }];
    }
}
+(void)changeSpeedVideoUrl:(NSURL *)videoUrl speed:(CGFloat)speed videoindex:(NSInteger)index callBack:(void(^)(BOOL success,NSString * outUrlPath,NSInteger videoIndex))callBack
{
    NSString * subPath = gatAVideoTempPath();
    NSURL * outPutUrl = [NSURL fileURLWithPath:subPath];
    
    [MHVideoTool changeVideoSpeed:videoUrl speed:speed outPutUrl:outPutUrl callBack:^(BOOL success) {
        callBack(success,subPath,index);
    }];
}
+(CGFloat)videoSpeedFor:(MHShootSpeedType)speedType
{
    switch (speedType) {
        case MHShootSpeedTypeNomal:
        {
            return 1.0;
        }
            break;
        case MHShootSpeedTypeaSlow:
        {
            return 2.0;
        }
            break;
        case MHShootSpeedTypeMoreSlow:
        {
            return 4.0;
        }
            break;
        case MHShootSpeedTypeFast:
        {
            return 0.5;
        }
            break;
        case MHShootSpeedTypeMorefast:
        {
            return 0.25;
        }
            break;
        default:
            break;
    }
    return 1.0;
}
#pragma mark - 合并视频+音频
+(void)videoAddBGM_videoUrl:(NSURL *)videoUrl originalInfo:(PostVideoModel *)model callBack:(void (^)(BOOL, NSString *))callBack
{
    //如果存在背景音乐 需要先裁剪背景音乐
    if (model.bgmName.length > 0) {
        //先裁剪背景音乐
        NSString * path = [[NSBundle mainBundle] pathForResource:model.bgmName ofType:@"mp3"];
        NSURL * bgmUrl = [NSURL fileURLWithPath:path];
        [MHVideoTool crapMusicWithUrl:bgmUrl startTime:model.bgmStartTime length:[MHVideoTool mh_getVideolength:videoUrl] callBack:^(BOOL success, NSURL *outPurUrl) {
            
            NSURL * finalBGMUrl = bgmUrl;
            if (success) {
                finalBGMUrl = outPurUrl;
            }
            [MHVideoTool mergevideoWithVideoUrl:videoUrl
                     originalAudioTrackVideoUrl:[NSURL fileURLWithPath:model.shootFinishMergedVideoPath]
                                         bgmUrl:finalBGMUrl
                                 originalVolume:model.videoVolume
                                      bgmVolume:model.bgmVolume
                                      outPutUrl:[NSURL fileURLWithPath:gatAVideoTempPath()]
                                       callBack:^(BOOL success, NSURL *outPurUrl) {
                                           callBack(success,outPurUrl.path);
                                       }];
        }];
    }else{
        //没有背景音乐
        [MHVideoTool mergevideoWithVideoUrl:videoUrl
                 originalAudioTrackVideoUrl:[NSURL fileURLWithPath:model.shootFinishMergedVideoPath]
                                     bgmUrl:nil
                             originalVolume:model.videoVolume
                                  bgmVolume:model.bgmVolume
                                  outPutUrl:[NSURL fileURLWithPath:gatAVideoTempPath()]
                                   callBack:^(BOOL success, NSURL *outPurUrl) {
            callBack(success,outPurUrl.path);
        }];
    }
}
#pragma mark - 清除拍摄临时视频文件
+(void)cleanShootTempCache
{
    NSString *cachPath = shortSubVideoTempDoc();
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *subFile in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:subFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}
#pragma mark - 创建-返回一个视频临时路径
+(NSString *)creatAVideoTempPath
{
    NSString * subPath = gatAVideoTempPath();
    return subPath;
}
@end


@implementation ShootSubVideo

-(id)init
{
    self = [super init];
    if (self) {
        //初始化时直接赋值分段视频路径
        NSString * subPath = gatAVideoTempPath();
        _subVideoPath = subPath;
        
        //默认视频速度1.0（原速）
        _videoSpeedType = MHShootSpeedTypeNomal;
    }
    return self;
}
- (CGFloat)videolength
{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.subVideoPath]];
    CGFloat length = (CGFloat)asset.duration.value/(CGFloat)asset.duration.timescale;
    return length;
}

@end
