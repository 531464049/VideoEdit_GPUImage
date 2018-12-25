//
//  FastSlowChooseView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/16.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FastSlowChooseDelegate;
@interface FastSlowChooseView : UIView

@property(nonatomic,weak)id <FastSlowChooseDelegate> delegate;
@property(nonatomic,assign,readonly)MHShootSpeedType speedType;

@end


@protocol FastSlowChooseDelegate <NSObject>

@optional
-(void)fastSlowChooseCallBack:(MHShootSpeedType)speedType;

@end
