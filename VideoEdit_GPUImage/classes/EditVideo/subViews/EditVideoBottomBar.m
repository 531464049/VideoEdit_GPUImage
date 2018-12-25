//
//  EditVideoBottomBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/26.
//  Copyright © 2018 mh. All rights reserved.
//

#import "EditVideoBottomBar.h"

@interface EditVideoBottomBar ()

@property(nonatomic,strong)UIButton * nextStepItem;//下一步 按钮

@property(nonatomic,strong)UIButton * specialItem;//特效
@property(nonatomic,strong)UIButton * coverItem;//选封面
@property(nonatomic,strong)UIButton * filterItem;//滤镜

@end

@implementation EditVideoBottomBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subviews];
    }
    return self;
}
-(void)commit_subviews
{
    self.specialItem = [self creatItemTitle:@"特效" imgName:@"editVide_chooseBGM" index:0];
    [self addSubview:self.specialItem];
    self.coverItem = [self creatItemTitle:@"选封面" imgName:@"editVideo_volume" index:1];
    [self addSubview:self.coverItem];
    self.filterItem = [self creatItemTitle:@"滤镜" imgName:@"editVideo_crapBGM" index:2];
    [self addSubview:self.filterItem];
    
    //下一步
    self.nextStepItem = [UIButton buttonWithType:0];
    self.nextStepItem.frame = CGRectMake(0, 0, Width(68), Width(32));
    self.nextStepItem.center = CGPointMake(self.frame.size.width - Width(15) - Width(68)/2, self.frame.size.height/2);
    self.nextStepItem.backgroundColor = [UIColor redColor];
    [self.nextStepItem setTitle:@"下一步" forState:0];
    [self.nextStepItem setTitleColor:[UIColor whiteColor] forState:0];
    self.nextStepItem.titleLabel.font = FONT(15);
    self.nextStepItem.layer.cornerRadius = 4;
    self.nextStepItem.layer.masksToBounds = YES;
    [self.nextStepItem addTarget:self action:@selector(nextStepItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextStepItem];
}
-(UIButton *)creatItemTitle:(NSString *)title imgName:(NSString *)imgName index:(NSInteger)index
{
    UIButton * item = [UIButton buttonWithType:0];
    item.frame = CGRectMake(Width(15) + Width(60)*index, 0, Width(60), Width(60));
    [item setTitle:title forState:0];
    [item setTitleColor:[UIColor grayColor] forState:0];
    item.titleLabel.font = FONT(14);
    [item setImage:[UIImage imageNamed:imgName] forState:0];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    item.tag = 5000 + index;
    [item mh_fixImageTop];
    return item;
}
-(void)nextStepItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoBottomBarHandleNextStep)]) {
        [self.delegate editVideoBottomBarHandleNextStep];
    }
}
-(void)itemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 5000;
    if (tag == 0) {
        //特效
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoBottomBarHandleSpecialFilter)]) {
            [self.delegate editVideoBottomBarHandleSpecialFilter];
        }
    }else if (tag == 1) {
        //选封面
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoBottomBarHandleChooseCover)]) {
            [self.delegate editVideoBottomBarHandleChooseCover];
        }
    }else{
        //滤镜
        if (self.delegate && [self.delegate respondsToSelector:@selector(editVideoBottomBarHandleCommonFilter)]) {
            [self.delegate editVideoBottomBarHandleCommonFilter];
        }
    }
}
@end
