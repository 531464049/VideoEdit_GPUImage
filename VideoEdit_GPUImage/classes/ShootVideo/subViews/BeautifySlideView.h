//
//  BeautifySlideView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BeautifySlideDelegate;
@interface BeautifySlideView : UIView

@property(nonatomic,weak)id <BeautifySlideDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame beautifyInfo:(MHBeautifyInfo *)beautifyInfo;

@end

@protocol BeautifySlideDelegate <NSObject>
/** 美颜参数修改回调 */
-(void)beautifySlideViewValueChanged:(MHBeautifyInfo *)beautifyInfo;

@end
