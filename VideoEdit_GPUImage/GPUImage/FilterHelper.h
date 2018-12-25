//
//  FilterHelper.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHFilterInfo;

@interface FilterHelper : NSObject

/**
 读取滤镜信息（全部，包括普通和特效）
 @return 所有滤镜信息数组
 */
+(NSArray<MHFilterInfo *> *)readAllfilterArr;
/**
 读取全部普通滤镜信息
 */
+(NSArray<MHFilterInfo *> *)readAllCommonFiltersArr;
/**
 读取全部特效滤镜信息
 */
+(NSArray<MHFilterInfo *> *)readAllSpecialFiltersArr;

@end



@interface MHFilterInfo : NSObject

@property(nonatomic,copy)NSString * filterName;      //滤镜名
@property(nonatomic,copy)NSString * filterClassName; //滤镜类名

/** 默认使用空滤镜 */
+(MHFilterInfo *)customEmptyInfo;

@end


/** 当前美颜指数信息 */
@interface MHBeautifyInfo : NSObject
/** 美颜程度 */
@property(nonatomic,assign)CGFloat beautyLevel;
/** 美白程度 */
@property(nonatomic,assign)CGFloat brightLevel;
/** 色调强度 */
@property(nonatomic,assign)CGFloat toneLevel;

/** 默认美颜参数 */
+(MHBeautifyInfo *)customBeautifyInfo;

@end
