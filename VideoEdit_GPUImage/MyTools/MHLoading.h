//
//  MHLoading.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHLoading : UIView

+(void)showloading;
+(void)showloadingIn:(UIView *)inView;

+(void)stopLoadingIn:(UIView *)inView;
+(void)stopLoading;

@end
