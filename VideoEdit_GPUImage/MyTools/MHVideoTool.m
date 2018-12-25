//
//  MHVideoTool.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "MHVideoTool.h"

@implementation MHVideoTool

#pragma mark - 相册视频保存本地路径
+(NSString *)mh_albumVideoOutTempPath
{
    NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"albumVideoTemp"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:tempPath]){
            [fileManage createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"VideoCompressionTemp%f.mp4",time];
    NSString *outPath =  [tempPath stringByAppendingPathComponent:fileName];
    if([fileManage fileExistsAtPath:outPath]){
        [fileManage removeItemAtPath:outPath error:nil];
    }
    return outPath;
}
#pragma mark - 获取视频的缩略图方法
+ (UIImage *)mh_getVideoTempImageFromVideo:(NSURL *)videoUrl withTime:(CGFloat)theTime
{
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    CGFloat timescale = asset.duration.timescale;
    UIImage *shotImage;
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CGFloat width = [UIScreen mainScreen].scale * 100;
    CGFloat height = width * [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
    gen.maximumSize =  CGSizeMake(width, height);
    
    CMTime time = CMTimeMakeWithSeconds(theTime, timescale);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}
#pragma mark - 获取视频长度
+(CGFloat)mh_getVideolength:(NSURL *)videoUrl
{
    AVURLAsset * asset = [AVURLAsset assetWithURL:videoUrl];
    CGFloat length = (CGFloat)asset.duration.value/(CGFloat)asset.duration.timescale;
    return length;
}
#pragma mark - 视频的旋转角度
+(NSUInteger)mh_getDegressFromVideoWithURL:(NSURL *)url
{
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}
#pragma mark - 获取视频尺寸
+(CGSize)mh_getVideoSize:(NSURL *)videoUrl
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in asset.tracks) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    return videoSize;
}
#pragma mark - 根据比例调整视频输出的尺寸，width=480
+(CGSize)mh_fixVideoOutPutSize:(CGSize)nomSize
{
    if (nomSize.width <= 480.0) {
        return nomSize;
    }
    CGFloat height = nomSize.height * 480.0 / nomSize.width;
    return CGSizeMake(480.0, height);
}
#pragma mark - 将视频保存到相册
+(void)mh_writeVideoToPhotosAlbum:(NSURL *)videoUrl callBack:(void (^)(BOOL))callBack
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoUrl]) {
        [library writeVideoAtPathToSavedPhotosAlbum:videoUrl completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (callBack) {
                        callBack(NO);
                    }
                } else {
                    NSLog(@"已保存到相册");
                    if (callBack) {
                        callBack(YES);
                    }
                }
            });
        }];
    }
}
#pragma mark - 改变视频速度
+(void)changeVideoSpeed:(NSURL *)videoUrl speed:(CGFloat)speed outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL))callBack
{
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //添加视频轨道信息
    AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:nil];
    
    // 根据速度比率调节音频和视频
    [videoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale))
                    toDuration:CMTimeMake(videoAsset.duration.value * speed , videoAsset.duration.timescale)];
    
    if ([videoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        
        [audioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale))
                        toDuration:CMTimeMake(videoAsset.duration.value * speed, videoAsset.duration.timescale)];
    }
    
    //输出文件
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                callBack(YES);
            }else{
                callBack(NO);
            }
        });
    }];
}
#pragma mark - 将多个视频合成一个视频
+(void)mergeVideosWithPaths:(NSArray *)paths outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL, NSURL *))callBack
{
    if (paths.count == 0) {
        callBack(NO,nil);
        return;
    }
    
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < paths.count; i ++) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:paths[i]]];
        
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
        
        NSError *errorVideo = nil;
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetVideoTrack atTime:totalDuration error:&errorVideo];
        
        
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];

        NSError *erroraudio = nil;
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:totalDuration error:&erroraudio];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    
    //输出文件
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                callBack(YES,outPutUrl);
            }else{
                callBack(NO,outPutUrl);
            }
        });
    }];
}
#pragma mark - 音频裁剪
+(void)crapMusicWithUrl:(NSURL *)bgmUrl startTime:(CGFloat)startTime length:(CGFloat)length callBack:(void (^)(BOOL, NSURL *))callBack
{
    AVAsset *asset = [AVAsset assetWithURL:bgmUrl];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    //剪辑(设置导出的时间段)
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(length,asset.duration.timescale);
    exporter.timeRange = CMTimeRangeMake(start, duration);
    
    //输出路径
    NSURL * outPutUrl = [NSURL fileURLWithPath:[MHVideoTool musicCrapOutPutTempPath]];
    exporter.outputURL = outPutUrl;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse= YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            DLog(@"音频 裁剪 成功");
            callBack(YES,outPutUrl);
        }else{
            DLog(@"音频 裁剪 失败");
            callBack(NO,nil);
        }
    }];
}
#pragma mark - 裁剪音频时 输出路径(临时文件夹)
+(NSString *)musicCrapOutPutTempPath
{
    NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"musicTemp"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:tempPath]){
            [fileManage createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"musicCrapTemp%f.m4a",time];
    NSString *outPath =  [tempPath stringByAppendingPathComponent:fileName];
    if([fileManage fileExistsAtPath:outPath]){
        [fileManage removeItemAtPath:outPath error:nil];
    }
    return outPath;
}
#pragma mark - 合并视频+背景音乐 同时调整原始视频的音频和背景音乐的音量
+(void)mergevideoWithVideoUrl:(NSURL *)videoUrl originalAudioTrackVideoUrl:(NSURL *)originalAudioTrackVideoUrl bgmUrl:(NSURL *)bgmUrl originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL, NSURL *))callBack
{
    //创建合并Composition
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    //添加视频轨道信息
    AVURLAsset * inputVideoAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inputVideoAsset.duration)
                        ofTrack:[[inputVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:nil];
    
    //添加视频自带的音频轨道信息
    //保存音频音量数据
    NSMutableArray * audioInputParamsArr = [NSMutableArray arrayWithCapacity:0];
    
    AVURLAsset * originalVideoAsset = [AVURLAsset URLAssetWithURL:originalAudioTrackVideoUrl options:nil];
    if ([originalVideoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        
        AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inputVideoAsset.duration)
                            ofTrack:[[originalVideoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        
        //调整音量
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
        [audioInputParams setVolumeRampFromStartVolume:originalVolume toEndVolume:.0f timeRange:CMTimeRangeMake(kCMTimeZero, originalVideoAsset.duration)];
        [audioInputParams setTrackID:audioTrack.trackID];
        
        [audioInputParamsArr addObject:audioInputParams];
    }
    
    //添加背景音乐音频轨道信息
    if (bgmUrl && bgmUrl.absoluteString.length > 0) {
        AVURLAsset * inputAudioAsset = [AVURLAsset URLAssetWithURL:bgmUrl options:nil];
        if ([inputAudioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
            AVMutableCompositionTrack * addAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [addAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inputVideoAsset.duration)
                                   ofTrack:[[inputAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                    atTime:kCMTimeZero
                                     error:nil];
            
            //调整音量
            AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:addAudioTrack];
            [audioInputParams setVolumeRampFromStartVolume:bgmVolume toEndVolume:.0f timeRange:CMTimeRangeMake(kCMTimeZero, inputVideoAsset.duration)];
            [audioInputParams setTrackID:addAudioTrack.trackID];
            
            [audioInputParamsArr addObject:audioInputParams];
        }
    }
    
    //处理视频旋转和缩放
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, inputVideoAsset.duration);
    
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    AVAssetTrack *videoAssetTrack = [[inputVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    CGSize videoSize = videoAssetTrack.naturalSize;
    if(videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0)
    {
        videoTransform = CGAffineTransformTranslate(videoTransform,0,videoTransform.tx-videoSize.height);
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    [videolayerInstruction setTransform:videoTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:inputVideoAsset.duration];
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.renderSize = videoSize;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);//fps
    
    //音频调整
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:audioInputParamsArr];
    
    //输出文件
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    exporter.audioMix = audioMix;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                callBack(YES,outPutUrl);
            }else{
                callBack(NO,nil);
            }
        });


    }];
}


+(NSString *)test_getAVideoUrl:(NSInteger)index
{
    NSArray * videoUrlArr = @[
                              @"https://img.xiaohua.com/video/0/113/113646_20181210170105394_0.mp4",
                              @"https://img.xiaohua.com/Video/0/30/30923_20180519160821142_1.mp4",
                              @"https://img.xiaohua.com/Video/0/52/52606_20180516154001504_1.mp4",
                              @"https://img.xiaohua.com/video/0/113/113842_20181212170022034_0.mp4",
                              @"https://img.xiaohua.com/video/0/114/114040_20181214165029120_0.mp4",
                              @"https://img.xiaohua.com/video/0/113/113847_20181212165935081_0.mp4",
                              @"https://img.xiaohua.com/video/0/113/113644_20181210170131044_0.mp4"];
    
    
    NSInteger sss = index % videoUrlArr.count;
    return videoUrlArr[sss];
}
+(NSString *)t_videoPreImage:(NSInteger)index
{
    NSArray * arr = @[
                      @"https://img.xiaohua.com/picture/201811266367884726093581093832945.jpg",
                      @"https://img.xiaohua.com/Picture/0/11/11205_20180526024238883_0.jpg",
                      @"https://img.xiaohua.com/picture/201811296367910506009836023194005.jpg",
                      @"https://img.xiaohua.com/Picture/0/13/13175_20180525214554225_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/15/15854_20180525150149323_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/103/103172_20180520005428048_0.jpg",
                      @"https://img.xiaohua.com/picture/201811306367919210476342532131195.jpeg",
                      @"https://img.xiaohua.com/Picture/0/28/28635_20180524194832739_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/48/48488_20180516144029305_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/16/16199_20180525141023968_0.jpg"];
    NSInteger a  = index % arr.count;
    return arr[a];
}
@end
