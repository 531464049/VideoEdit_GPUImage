//
//  FastSlowChooseView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/16.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FastSlowChooseView.h"

@interface FastSlowChooseView ()

@property(nonatomic,strong)UIView * runView;

@end

@implementation FastSlowChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        //默认 标准速度
        _speedType = MHShootSpeedTypeNomal;
        [self commit_subviews];
    }
    return self;
}
-(void)commit_subviews
{
    CGFloat itemWidth = self.frame.size.width / 5;
    CGFloat itemHeight = self.frame.size.height;
    
    self.runView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
    self.runView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.runView.backgroundColor = [UIColor whiteColor];
    self.runView.layer.cornerRadius = 4;
    self.runView.layer.masksToBounds = YES;
    [self addSubview:self.runView];
    
    NSArray * arr = @[@"极慢",@"慢",@"标准",@"快",@"极快"];
    for (int i = 0; i < 5; i ++) {
        UIButton * btn = [UIButton buttonWithType:0];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        [btn setTitle:arr[i] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = FONT(15);
        btn.tag = 3500 + i;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    [self updateCurentSelectedIndex:self.speedType];
}
-(void)updateCurentSelectedIndex:(NSInteger)index
{
    for (int i = 0; i < 5; i ++) {
        UIButton * btn = (UIButton *)[self viewWithTag:3500+i];
        if (index == i) {
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:0];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.runView.center = CGPointMake(self.frame.size.width/5/2 + self.frame.size.width/5*index, self.frame.size.height/2);
    }];
}
-(void)itemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 3500;
    if (self.speedType == tag) {
        return;
    }
    _speedType = tag;
    [self updateCurentSelectedIndex:tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fastSlowChooseCallBack:)]) {
        [self.delegate fastSlowChooseCallBack:self.speedType];
    }
}
@end
