//
//  BaseView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/**
 view所在的导航控制器 赋值后 方便view内容跳转push
 */
@property(nonatomic,strong)UINavigationController * curentNav;

@end


@interface BaseTableView : UITableView


@end


@interface BaseCell : UITableViewCell


@end
