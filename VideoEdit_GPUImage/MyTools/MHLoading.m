//
//  MHLoading.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHLoading.h"

@interface MHLoading ()

@property(nonatomic,strong)UIImageView * aniImgView;

@end

@implementation MHLoading

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.aniImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.aniImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.aniImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.aniImgView.clipsToBounds = YES;
        [self addSubview:self.aniImgView];
        
        NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
        for (NSUInteger i = 0; i<14; i++) {
            NSString * imgName = [NSString stringWithFormat:@"loading%02lu@2x",(unsigned long)i];
            NSString * path = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [imgArr safe_addObject:image];
        }
        //图片播放一次所需时长
        self.aniImgView.animationDuration = 1.0;
        //图片播放次数,0表示无限
        self.aniImgView.animationRepeatCount = 0;
        //设置动画图片数组
        self.aniImgView.animationImages = [NSArray arrayWithArray:imgArr];
        
        [self.aniImgView startAnimating];
    }
    return self;
}
-(void)finished
{
    [self.aniImgView stopAnimating];
    [self.aniImgView removeFromSuperview];
    [self removeFromSuperview];
}
+(MHLoading *)getLoadingInView:(UIView *)inView
{
    NSEnumerator *subviewsEnum = [inView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            MHLoading * loading = (MHLoading *)subview;
            return loading;
        }
    }
    return nil;
}
+(void)showloading
{
    [MHLoading showloadingIn:[self theKeyWindow]];
}
+(void)showloadingIn:(UIView *)inView
{
    MHLoading * loading = [self getLoadingInView:inView];
    if (!loading) {
        loading = [[MHLoading alloc] initWithFrame:inView.bounds];
        [inView addSubview:loading];
    }
}
+(void)stopLoadingIn:(UIView *)inView
{
    MHLoading * loading = [self getLoadingInView:inView];
    if (loading) {
        [loading finished];
    }
}
+(void)stopLoading
{
    [MHLoading stopLoadingIn:[self theKeyWindow]];
}
+(UIWindow *)theKeyWindow
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    return keywindow;
}
@end
