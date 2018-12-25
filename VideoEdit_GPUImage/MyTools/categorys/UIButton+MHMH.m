//
//  UIButton+MHMH.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/15.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "UIButton+MHMH.h"

@implementation UIButton (MHMH)

- (void)mh_fixImageTop
{
    CGFloat labHeight = self.titleLabel.font.lineHeight + 4;
    UIImage *image = self.imageView.image;
    if (!image) {
        return;
    }
    CGFloat padding = 0;//lab image 间隔
    CGFloat space = 0;//上下左右间隔
    //设置后的图片高度
    CGFloat imageHeight = self.frame.size.height - (2 * space) - labHeight - padding;
    if (imageHeight > image.size.height) {
        imageHeight = image.size.height;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(space, (self.frame.size.width - imageHeight) / 2, space + labHeight + padding, (self.frame.size.width - imageHeight) / 2);
    self.titleEdgeInsets = UIEdgeInsetsMake(space + imageHeight + padding, -image.size.width, space, 0);
}

@end
