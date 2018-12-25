//
//  FilterChooseView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterChooseViewDelegate;
@class FilterPreCell;
@interface FilterChooseView : UIView

@property(nonatomic,weak)id <FilterChooseViewDelegate> delegate;

/** 更新当前选中的滤镜 */
-(void)updateCurentFIlterInfo:(MHFilterInfo *)filterInfo;

@end


@protocol FilterChooseViewDelegate <NSObject>
@optional
/** 选中滤镜后的回调 */
-(void)filterChooseViewChoosedFilter:(MHFilterInfo *)choosedFilterInfo;

@end


@interface FilterPreCell : UICollectionViewCell

@property(nonatomic,strong)MHFilterInfo * model;
@property(nonatomic,assign)BOOL is_Selected;

@end
