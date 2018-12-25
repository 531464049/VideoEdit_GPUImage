//
//  RootTabBarVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/13.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "RootTabBarVC.h"
#import "MHTabbar.h"
#import "BaseNavController.h"
@interface RootTabBarVC ()<MHTabbarViewDelegate>

@property(nonatomic,strong)MHTabbar * mhTabBar;
@property(nonatomic,assign)NSInteger lastSelectedItem;

@end

@implementation RootTabBarVC
+(RootTabBarVC *)sharedInstance
{
    static RootTabBarVC * _RootTabBarVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _RootTabBarVC = [[RootTabBarVC alloc] init];
    });
    return _RootTabBarVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 利用 KVC 来使用自定义的tabBar；
    self.mhTabBar = [[MHTabbar alloc] init];
    self.mhTabBar.tabbarView.delegate = self;
    [self setValue:self.mhTabBar forKey:@"tabBar"];

    [self creatTabBar];
}
#pragma mark - 初始化vcs
-(void)creatTabBar
{
    NSMutableArray * vcArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 5; i ++) {
        UIViewController * vc = [[UIViewController alloc] init];
        vc.title = @"";
 
        BaseNavController * nvc = [[BaseNavController alloc] initWithRootViewController:vc];
        nvc.navigationBar.tintColor = [UIColor whiteColor];
        nvc.navigationBar.translucent = NO;
        nvc.navigationBarHidden = YES;
        
        [vcArr addObject:nvc];
    }

    self.viewControllers = vcArr;
    self.lastSelectedItem = 0;
    self.selectedIndex = 0;
}
#pragma mark - tabbar点击回调
- (void)mhTabBarView:(MHTabbarView *)tabbarView selectedIndex:(NSInteger)index
{
    if (index == 2) {
        self.selectedIndex = self.lastSelectedItem;
        DLog(@"点击中心按钮");
        UIViewController * vc = [NSClassFromString(@"ShootVideoVC") new];
        BaseNavController * nvc = [[BaseNavController alloc] initWithRootViewController:vc];
        nvc.navigationBar.tintColor = [UIColor whiteColor];
        nvc.navigationBar.translucent = NO;
        nvc.navigationBarHidden = YES;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }else{
        self.lastSelectedItem = index;
        self.selectedIndex = index;
    }
}
#pragma mark - 点击index set方法
- (void)setLastSelectedItem:(NSInteger)lastSelectedItem
{
    _lastSelectedItem = lastSelectedItem;
    //更新选中下标item状态
    [self.mhTabBar.tabbarView update_selectedIndex:lastSelectedItem];
}
@end
