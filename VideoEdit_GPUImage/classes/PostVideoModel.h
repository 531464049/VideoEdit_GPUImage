//
//  PostVideoModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShootSubVideo;

@interface PostVideoModel : NSObject

/** 视频拍摄过程中 子视频信息 用于最终拍摄后的合成 */
@property(nonatomic,strong)NSArray<ShootSubVideo *> * subVideoInfos;
/** 拍摄结束 变速+合并后的视频本地路径 */
@property(nonatomic,copy)NSString * shootFinishMergedVideoPath;
/** 拍摄处理后的视频长度 */
@property(nonatomic,assign,readonly)CGFloat shootFinishVideolength;

/** 视频添加背景音乐 音乐名 */
@property(nonatomic,copy)NSString * bgmName;
/** 背景音乐开始位置 */
@property(nonatomic,assign)NSInteger bgmStartTime;
/** 视频原声音量 默认1 */
@property(nonatomic,assign)CGFloat videoVolume;
/** 背景音乐音量 默认1 */
@property(nonatomic,assign)CGFloat bgmVolume;
/** 视频封面位置 - 时间点 默认0.f */
@property(nonatomic,assign)CGFloat videoCaverLocation;
/** 最终视频路径 */
@property(nonatomic,copy)NSString * finalVideoPath;


/** 发布 标题 */
@property(nonatomic,copy)NSString * postTitle;
/** 发布 位置 */
@property(nonatomic,copy)NSString * postLocation;
/** 发布 公开类型 */
@property(nonatomic,assign)MHPostVideoOpenType postOpenType;


/** 根据视频拍摄速度 添加一个子视频模型 同时再返回当前添加模型 */
-(ShootSubVideo *)addSubVideoInfoWithSpeedType:(MHShootSpeedType)videoSpeedType;
/** 删除上一段子视频 */
-(void)removeLastSubVideoInfo;
/** 计算全部子视频 视频时长总和 */
-(CGFloat)getAllSubVideoInfoVideoLength;

/**
 对拍摄后的子视频进行变速+合并
 @param subVideoInfos 子视频数组
 @param callBack 回调-是否成功 处理完的视频路径
 */
+(void)compositionSubVideos:(NSArray<ShootSubVideo *> *)subVideoInfos callBack:(void(^)(BOOL success ,NSString * outPurPath))callBack;

/**
 合并视频+音频
 @param videoUrl 待合并的视频（无音频轨道，原始音频轨道需要从model里边shootFinishMergedVideoPath读取）
 @param model 视频信息
 @param callBack 回调
 */
+(void)videoAddBGM_videoUrl:(NSURL *)videoUrl originalInfo:(PostVideoModel *)model callBack:(void(^)(BOOL success ,NSString * outPurPath))callBack;

/** 清除拍摄临时视频文件 */
+(void)cleanShootTempCache;
/** 创建-返回一个视频临时路径 */
+(NSString *)creatAVideoTempPath;

@end


@interface ShootSubVideo : NSObject

/** 分段视频保存路径 */
@property(nonatomic,copy,readonly)NSString * subVideoPath;
/** 分段 视频长度 */
@property(nonatomic,assign,readonly)CGFloat videolength;
/** 分段 速度类型 */
@property(nonatomic,assign)MHShootSpeedType videoSpeedType;

@end
