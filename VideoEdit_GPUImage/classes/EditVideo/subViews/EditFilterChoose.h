//
//  EditFilterChoose.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/27.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditFilterChooseCallBack)(MHFilterInfo * filterInfo);
typedef void(^EditFilterChooseHidenHandle)(void);

@interface EditFilterChoose : UIView

+(void)showWithCurentFilter:(MHFilterInfo *)curentfilter callBack:(EditFilterChooseCallBack)callBack hidenHanlde:(EditFilterChooseHidenHandle)hidenHandle;

@end
