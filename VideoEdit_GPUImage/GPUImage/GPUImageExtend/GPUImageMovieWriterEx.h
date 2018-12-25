//
//  GPUImageMovieWriterEx.h
//  aikan
//
//  Created by lihejun on 14-1-14.
//  Copyright (c) 2014年 taobao. All rights reserved.
//
#import "GPUImage.h"
#import "GPUImageMovieWriter.h"

/**
 支持视频录制暂停和恢复.
 */
@interface GPUImageMovieWriterEx : GPUImageMovieWriter
@property (nonatomic, assign) BOOL started;
@property (readwrite) int32_t maxFrames; //为了计算进度
- (void)pauseRecording;
- (void)resumeRecording;
- (float)getProgress;
@end
