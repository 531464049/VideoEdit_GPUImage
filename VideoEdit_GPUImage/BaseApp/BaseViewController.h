//
//  BaseViewController.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/13.
//  Copyright © 2018年 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,strong)UINavigationController * curentNav;

@property(nonatomic,strong)UIView * mhNavBar;
@property(nonatomic,strong)UILabel * mh_navTitle;
@property(nonatomic,strong)UIButton * mh_navBackItem;
@property(nonatomic,strong)UIView * mh_navBottomLine;

-(void)mh_setTitle:(NSString *)title;
-(void)mh_setNeedBackItem:(BOOL)needBackItem;
-(void)mh_setNeedBackItemWithTitle:(NSString *)title;
-(void)mh_setNavBottomlineHiden:(BOOL)hiden;
@end

