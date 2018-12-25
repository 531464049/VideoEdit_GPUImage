//
//  PostViewController.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/28.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostViewController.h"


@interface PostViewController ()


@end

@implementation PostViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [MHStatusBarHelper updateStatuesBarHiden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"发布"];
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
