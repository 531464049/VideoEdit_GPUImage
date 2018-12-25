//
//  ShootMusicBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ShootMusicBar.h"
#import "ZScrollLabel.h"

@interface ShootMusicBar ()

@property (nonatomic, strong) ZScrollLabel *titleLabel;

@end

@implementation ShootMusicBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subViews];
        self.barCanUse = YES;
    }
    return self;
}
-(void)commit_subViews
{
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(30), Width(30))];
    img.center = CGPointMake(Width(20), self.frame.size.height/2);
    img.image = [UIImage imageNamed:@"shoot_crapbgm"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.clipsToBounds = YES;
    [self addSubview:img];
    
    _titleLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(Width(40), 0, self.frame.size.width - Width(40), self.frame.size.height)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = FONT(16);
    _titleLabel.text = @"选择音乐";
    [self addSubview:_titleLabel];
    
    self.chooseMusicBtn = [UIButton buttonWithType:0];
    self.chooseMusicBtn.frame = self.bounds;
    [self addSubview:self.chooseMusicBtn];
}
- (void)setBarCanUse:(BOOL)barCanUse
{
    _barCanUse = barCanUse;
    self.chooseMusicBtn.enabled = barCanUse;
    
    if (barCanUse) {
        _titleLabel.textColor = [UIColor whiteColor];
    }else{
        _titleLabel.textColor = [UIColor grayColor];
    }
}
- (void)updateChooseMusicName:(NSString *)musicName
{
    _titleLabel.text = musicName;
}
@end
