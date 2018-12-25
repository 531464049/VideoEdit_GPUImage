//
//  ChooseBGMusicVC.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChooseBGMusicDelegate;
@interface ChooseBGMusicVC : BaseViewController

@property(nonatomic,weak)id <ChooseBGMusicDelegate> delegate;

@end


@protocol ChooseBGMusicDelegate <NSObject>

-(void)bgMusicChooseCallBack:(NSString *)choosedMusicName;

@end
