//
//  FilterHelper.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "FilterHelper.h"

@implementation FilterHelper

+ (NSArray<MHFilterInfo *> *)readAllfilterArr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MHFilter" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!jsonString) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * filterArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < filterArr.count; i ++) {
        NSDictionary * dic = (NSDictionary *)filterArr[i];
        MHFilterInfo * filter = [[MHFilterInfo alloc] init];
        filter.filterName = dic[@"name"];
        filter.filterClassName = dic[@"filterName"];
        [arr addObject:filter];
    }
    
    return [NSArray arrayWithArray:arr];
}
+ (NSArray<MHFilterInfo *> *)readAllCommonFiltersArr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MHVideoCommonFilter" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!jsonString) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * filterArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < filterArr.count; i ++) {
        NSDictionary * dic = (NSDictionary *)filterArr[i];
        MHFilterInfo * filter = [[MHFilterInfo alloc] init];
        filter.filterName = dic[@"name"];
        filter.filterClassName = dic[@"filterName"];
        [arr addObject:filter];
    }
    
    return [NSArray arrayWithArray:arr];
}
+ (NSArray<MHFilterInfo *> *)readAllSpecialFiltersArr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MHVideoSpecialFilter" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!jsonString) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * filterArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < filterArr.count; i ++) {
        NSDictionary * dic = (NSDictionary *)filterArr[i];
        MHFilterInfo * filter = [[MHFilterInfo alloc] init];
        filter.filterName = dic[@"name"];
        filter.filterClassName = dic[@"filterName"];
        [arr addObject:filter];
    }
    
    return [NSArray arrayWithArray:arr];
}
@end



@implementation MHFilterInfo

+ (MHFilterInfo *)customEmptyInfo
{
    MHFilterInfo * fil = [[MHFilterInfo alloc] init];
    fil.filterName = @"正常";
    fil.filterClassName = @"MHGPUImageEmptyFilter";
    return fil;
}

@end


@implementation MHBeautifyInfo

+ (MHBeautifyInfo *)customBeautifyInfo
{
    MHBeautifyInfo * info = [[MHBeautifyInfo alloc] init];
    info.beautyLevel = 1.0;//美颜程度   0-2
    info.brightLevel = 0.50;//美白程度 0-1
    info.toneLevel = 0.50;//色调强度   0-1
    return info;
}

@end
