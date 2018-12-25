//
//  MHHUD.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHUD : NSObject

+(void)showTips:(NSString *)tips;

+(void)showLoading;

+(void)finishedLoading;

+(void)showError:(NSString *)errorMsg;

+(void)showSuccess;

+(void)showSuccessWithMsg:(NSString *)msg;

@end
