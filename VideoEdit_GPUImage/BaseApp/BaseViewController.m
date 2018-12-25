//
//  BaseViewController.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/13.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MHStatusBarHelper updateStatuesBarHiden:NO];
    [MHStatusBarHelper updateStatuesBarStyleLight:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor base_color];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
}
-(void)mh_setTitle:(NSString *)title
{
    if (!self.mh_navTitle) {
        self.mh_navTitle = [self mh__mavTitle];
    }
    self.mh_navTitle.text = title;
}
-(void)mh_setNeedBackItem:(BOOL)needBackItem
{
    if (!self.mh_navBackItem) {
        self.mh_navBackItem = [self mh__navBackItem];
    }
    self.mh_navBackItem.hidden = !needBackItem;
}
-(void)mh_setNeedBackItemWithTitle:(NSString *)title
{
    [self mh_setTitle:title];
    [self mh_setNeedBackItem:YES];
}
-(void)mh_setNavBottomlineHiden:(BOOL)hiden
{
    self.mh_navBottomLine.hidden = hiden;
}
-(void)mh_navBackItem_click
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)mhNavBar
{
    if (!_mhNavBar) {
        _mhNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, NavHeight)];
        _mhNavBar.backgroundColor = [UIColor base_color];
        _mhNavBar.hidden = YES;
        [self.view addSubview:_mhNavBar];
        
        _mh_navBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight-0.5, Screen_WIDTH, 0.5)];
        _mh_navBottomLine.backgroundColor = [UIColor grayColor];
        [_mhNavBar addSubview:_mh_navBottomLine];
    }
    return _mhNavBar;
}
-(UILabel *)mh__mavTitle
{
    UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentCenter];
    lab.numberOfLines = 1;
    lab.frame = CGRectMake(0, 0, Screen_WIDTH/2, NavHeight - K_StatusHeight);
    lab.center = CGPointMake(Screen_WIDTH/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [self.mhNavBar addSubview:lab];
    return lab;
}
-(UIButton *)mh__navBackItem
{
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.center = CGPointMake(40/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [btn setImage:[UIImage imageNamed:@"common_back"] forState:0];
    [btn addTarget:self action:@selector(mh_navBackItem_click) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    [self.mhNavBar addSubview:btn];
    return btn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
