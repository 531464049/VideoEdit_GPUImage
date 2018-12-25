//
//  ShootProgressBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ShootProgressBar.h"
@interface ShootProgressBar ()

@property(nonatomic,strong)UIView * progressView;//进度条

@property(nonatomic,strong)NSMutableArray * specProgressArr;//保存分割点进度的数组
@property(nonatomic,strong)NSMutableArray * specItemArr;//保存分割点view的数组

@end

@implementation ShootProgressBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        self.progressView.backgroundColor = [UIColor yellowColor];
        self.progressView.alpha = 0.7;
        self.progressView.layer.cornerRadius = self.frame.size.height/2;
        self.progressView.layer.masksToBounds = YES;
        [self addSubview:self.progressView];
        
        _shootProgress = 0.0;
        self.specProgressArr = [NSMutableArray arrayWithCapacity:0];
        self.specItemArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
#pragma mark - 更新进度
- (void)updateShootPregress:(CGFloat)progress
{
    _shootProgress = progress;
    CGFloat width = self.frame.size.width * progress;
    self.progressView.frame = CGRectMake(0, 0, width, self.frame.size.height);
}
#pragma mark - 停止拍摄 添加一个进度分割点
- (void)addSpecItem
{
    [self.specProgressArr addObject:@(self.shootProgress)];
    
    CGFloat width = self.frame.size.width * self.shootProgress;
    UIView * specItem = [[UIView alloc] initWithFrame:CGRectMake(width - 4, 0, 4, self.frame.size.height)];
    [self addSubview:specItem];
    
    [self.specItemArr addObject:specItem];
    
    //如果进度到1，最后这个分割点设置为透明色
    if (self.shootProgress >= 1.0) {
        specItem.backgroundColor = [UIColor clearColor];
    }else{
        specItem.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark - 删除上一个分割点
-(void)removeLastSpecItem
{
    if (self.specProgressArr.count > 0) {
        [self.specProgressArr removeLastObject];
    }
    
    if (self.specItemArr.count > 0) {
        UIView * lastItem = (UIView *)[self.specItemArr lastObject];
        
        [self.specItemArr removeLastObject];
        
        [lastItem removeFromSuperview];
    }
    
    CGFloat curentProgress = 0.f;
    if (self.specProgressArr.count > 0) {
        curentProgress = [[self.specProgressArr lastObject] floatValue];
    }
    [self updateShootPregress:curentProgress];
}
@end
