//
//  FSKGPUImageBeautyFilter.h
//  KJAlbumDemo
//
//  Created by JOIN iOS on 2017/10/19.
//  Copyright © 2017年 Kegem. All rights reserved.
//

#import "GPUImage.h"

@interface FSKGPUImageBeautyFilter : GPUImageFilter

/** 美颜程度 */
@property (nonatomic, assign) CGFloat beautyLevel;
/** 美白程度 */
@property (nonatomic, assign) CGFloat brightLevel;
/** 色调强度 */
@property (nonatomic, assign) CGFloat toneLevel;

@end
