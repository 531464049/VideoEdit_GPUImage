//
//  MHVideoTool.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MHVideoTool : NSObject

/**
 相册视频保存本地路径
 @return 相册视频保存到本地的路径
 */
+(NSString *)mh_albumVideoOutTempPath;

/**
 获取视频的缩略图方法
 @param videoUrl 视频的路径
 @param time 时间
 @return 视频截图
 */
+ (UIImage *)mh_getVideoTempImageFromVideo:(NSURL *)videoUrl withTime:(CGFloat)time;


/**
 获取视频长度
 @param videoUrl 视频地址
 @return 视频长度
 */
+(CGFloat)mh_getVideolength:(NSURL *)videoUrl;

/**
 视频的旋转角度
 @param url 视频
 @return 角度
 */
+ (NSUInteger)mh_getDegressFromVideoWithURL:(NSURL *)url;

/**
 获取视频尺寸
 @param videoUrl 视频地址
 @return 视频尺寸
 */
+(CGSize)mh_getVideoSize:(NSURL *)videoUrl;

/**
 根据比例调整视频输出的尺寸，width=480
 @param nomSize 原始尺寸
 @return 调整后的尺寸
 */
+(CGSize)mh_fixVideoOutPutSize:(CGSize)nomSize;

/**
 将视频保存到相册
 @param videoUrl 要保存的视频地址
 @param callBack 保存回调
 */
+(void)mh_writeVideoToPhotosAlbum:(NSURL *)videoUrl callBack:(void(^)(BOOL success))callBack;

/**
 修改视频速度
 @param videoUrl 原始视频地址
 @param speed 要改变的速度 speed越大，视频修改后时间越长 最终时间=原始时间*speed
 @param outPutUrl 改变后的视频地址
 @param callBack 回调-是否成功
 */
+(void)changeVideoSpeed:(NSURL *)videoUrl speed:(CGFloat)speed outPutUrl:(NSURL *)outPutUrl callBack:(void(^)(BOOL success))callBack;

/**
 将多个视频合成一个视频
 @param paths 待合成的视频路径
 @param outPutUrl 输入路径
 @param callBack 回调-是否成功，输入路径
 */
+(void)mergeVideosWithPaths:(NSArray *)paths outPutUrl:(NSURL *)outPutUrl callBack:(void(^)(BOOL success,NSURL * outPurUrl))callBack;

/**
 音频bgm裁剪
 @param bgmUrl 待裁剪的音频路径
 @param startTime 裁剪开始时间
 @param length 裁剪长度
 @param callBack 回调
 */
+(void)crapMusicWithUrl:(NSURL *)bgmUrl startTime:(CGFloat)startTime length:(CGFloat)length callBack:(void(^)(BOOL success,NSURL * outPurUrl))callBack;

/**
 合并视频+背景音乐 同时调整原始视频的音频和背景音乐的音量
 @param videoUrl 要合并的视频地址
 @param originalAudioTrackVideoUrl 原始视频地址-从里边获取原始视频的音频轨道
 @param bgmUrl 背景音乐地址
 @param originalVolume 原始视频音频轨道音量
 @param bgmVolume 背景音乐音量
 @param outPutUrl 输出地址
 @param callBack 回调
 */
+(void)mergevideoWithVideoUrl:(NSURL *)videoUrl originalAudioTrackVideoUrl:(NSURL *)originalAudioTrackVideoUrl bgmUrl:(NSURL *)bgmUrl originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume outPutUrl:(NSURL *)outPutUrl callBack:(void(^)(BOOL success,NSURL * outPurUrl))callBack;

+(NSString *)test_getAVideoUrl:(NSInteger)index;
+(NSString *)t_videoPreImage:(NSInteger)index;
@end
