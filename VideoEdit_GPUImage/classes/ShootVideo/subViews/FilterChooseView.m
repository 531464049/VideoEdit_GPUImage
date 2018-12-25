//
//  FilterChooseView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FilterChooseView.h"

@interface FilterChooseView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong)UIView * topTypeBar;//顶部分类 选中 线
@property(nonatomic,assign)NSInteger curentTopIndex;//当前 顶部分类选中下标 默认0
@property(nonatomic,strong)UIView * topAniLine;//顶部分类 选中 线

//滤镜展示collectionView
@property(nonatomic,strong)UICollectionView * filterCollectionView;
@property(nonatomic,strong)NSArray * dataArr;//展示数据

@property(nonatomic,strong)MHFilterInfo * curentFilterInfo;//当前滤镜信息

@end

@implementation FilterChooseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curentFilterInfo = [MHFilterInfo customEmptyInfo];
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    {
        //顶部 分类
        self.topTypeBar = [[UIView alloc] init];
        [self addSubview:self.topTypeBar];
        self.topTypeBar.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(Width(45));
        [self.topTypeBar updateLayout];
        
        NSArray * arr = @[@"人像",@"风景",@"新锐"];
        for (int i = 0; i < 3; i ++) {
            UIButton * item = [UIButton buttonWithType:0];
            item.frame = CGRectMake(self.frame.size.width/3*i, 0, self.frame.size.width/3, self.topTypeBar.frame.size.height);
            [item setTitle:arr[i] forState:0];
            item.titleLabel.font = FONT(14);
            item.tag = 7800 + i;
            [item addTarget:self action:@selector(topItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.topTypeBar addSubview:item];
            
            item.titleEdgeInsets = UIEdgeInsetsMake(self.topTypeBar.frame.size.height/2-Width(10), 0, 0, 0);
        }
        self.curentTopIndex = 0;
        [self updateTopTypeItemState:0];
        
        self.topAniLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(26), 2)];
        self.topAniLine.backgroundColor = [UIColor yellowColor];
        self.topAniLine.layer.cornerRadius = 1;
        self.topAniLine.layer.masksToBounds = YES;
        [self.topTypeBar addSubview:self.topAniLine];
        self.topAniLine.center = [self topAniLineCenter];
    }
    
    //读取数据
    self.dataArr = [FilterHelper readAllCommonFiltersArr];
    //collection
    CGFloat itemWidth = Width(70);
    CGFloat itemHeight = self.frame.size.height - Width(45);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Width(45), self.frame.size.width, itemHeight) collectionViewLayout:layout];
    self.filterCollectionView.backgroundColor = [UIColor clearColor];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.showsVerticalScrollIndicator = NO;
    self.filterCollectionView.showsHorizontalScrollIndicator = NO;
    [self.filterCollectionView registerClass:[FilterPreCell class] forCellWithReuseIdentifier:@"c_c_cdfgf_c"];
    [self addSubview:self.filterCollectionView];
}
#pragma mark - 顶部分类 点击
-(void)topItemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 7800;
    if (self.curentTopIndex == tag) {
        return;
    }
    self.curentTopIndex = tag;
    [self updateTopTypeItemState:tag];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.topAniLine.center = [self topAniLineCenter];
    }];
    
    //跳转到对应的滤镜范围
    NSInteger sCellNum = ceil(self.dataArr.count/3);
    [self.filterCollectionView setContentOffset:CGPointMake(sCellNum*self.curentTopIndex*Width(70), 0) animated:NO];
}
#pragma mark - 更新顶部分类按钮状态
-(void)updateTopTypeItemState:(NSInteger)selIndex
{
    for (int i = 0; i < 3; i ++) {
        UIButton * item = (UIButton *)[self viewWithTag:7800 + i];
        if (selIndex == i) {
            [item setTitleColor:[UIColor whiteColor] forState:0];
        }else{
            [item setTitleColor:[UIColor lightGrayColor] forState:0];
        }
    }
}
#pragma mark - 计算顶部分类黄线中心坐标
-(CGPoint )topAniLineCenter
{
    CGFloat itemWidth = self.frame.size.width/3;
    CGFloat pointX = itemWidth/2 + itemWidth*self.curentTopIndex;
    CGFloat pointY = self.topTypeBar.frame.size.height - self.topAniLine.frame.size.height/2;
    return CGPointMake(pointX, pointY);
}
#pragma mark - 更新选中的滤镜
- (void)updateCurentFIlterInfo:(MHFilterInfo *)filterInfo
{
    self.curentFilterInfo = filterInfo;
    [self.filterCollectionView reloadData];
    
    NSInteger curentIndex = [self curentFilterIndex];
    CGFloat offX = Width(70)*curentIndex;
    if (offX <= self.filterCollectionView.frame.size.width/2) {
        offX = 0;
        [self.filterCollectionView setContentOffset:CGPointMake(offX, 0) animated:NO];
    }else{
        offX = offX - self.filterCollectionView.frame.size.width/2;
        if (offX >= self.filterCollectionView.contentSize.width - self.filterCollectionView.frame.size.width) {
            offX = self.filterCollectionView.contentSize.width - self.filterCollectionView.frame.size.width;
            [self.filterCollectionView setContentOffset:CGPointMake(offX, 0) animated:NO];
        }else{
            [self.filterCollectionView setContentOffset:CGPointMake(offX, 0) animated:NO];
        }
    }
    [self handle_scrollEnd:offX];
}
-(NSInteger)curentFilterIndex
{
    NSInteger index = 0;
    for (int i = 0; i < self.dataArr.count; i ++) {
        MHFilterInfo * filter = (MHFilterInfo *)self.dataArr[i];
        if ([filter.filterClassName isEqualToString:self.curentFilterInfo.filterClassName]) {
            index = i;
            break;
        }
    }
    return index;
}
-(void)handle_scrollEnd:(CGFloat)offX
{
    NSInteger tag = 0;
    NSInteger sCellNum = ceil(self.dataArr.count/3);
    offX = offX + self.filterCollectionView.frame.size.width;
    if (offX < sCellNum*Width(70)) {
        tag = 0;
    }else if (offX < sCellNum*2*Width(70)){
        tag = 1;
    }else {
        tag = 2;
    }
    if (self.curentTopIndex == tag) {
        return;
    }
    self.curentTopIndex = tag;
    [self updateTopTypeItemState:tag];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.topAniLine.center = [self topAniLineCenter];
    }];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterPreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"c_c_cdfgf_c" forIndexPath:indexPath];
    MHFilterInfo * model = (MHFilterInfo *)self.dataArr[indexPath.row];
    BOOL isS = [self.curentFilterInfo.filterClassName isEqualToString:model.filterClassName];
    cell.model = model;
    cell.is_Selected = isS;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHFilterInfo * model = (MHFilterInfo *)self.dataArr[indexPath.row];
    if ([self.curentFilterInfo.filterClassName isEqualToString:model.filterClassName]) {
        return;
    }
    self.curentFilterInfo = model;
    [self.filterCollectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(filterChooseViewChoosedFilter:)]) {
        [self.delegate filterChooseViewChoosedFilter:model];
    }
}
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    DLog(@"scrollViewDidEndDragging");
    if (decelerate == NO){
        [self handle_scrollEnd:scrollView.contentOffset.x];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    DLog(@"scrollViewDidEndDecelerating");
    [self handle_scrollEnd:scrollView.contentOffset.x];
}
@end


@interface FilterPreCell ()

@property(nonatomic,strong)UIImageView * filterIcon;
@property(nonatomic,strong)UILabel * filterName;

@property(nonatomic,strong)UIImageView * selectedImage;//选中图标

@end
@implementation FilterPreCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat width = CGRectGetWidth(self.frame);
        //CGFloat height = CGRectGetHeight(self.frame);
        
        self.filterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(53), Width(53))];
        self.filterIcon.center = CGPointMake(width/2, Width(18)+Width(53)/2);
        self.filterIcon.image = [UIImage imageNamed:@"filter_pre_image"];
        self.filterIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.filterIcon.clipsToBounds = YES;
        self.filterIcon.layer.cornerRadius = Width(53)/2;
        self.filterIcon.layer.masksToBounds = YES;
        [self addSubview:self.filterIcon];
        
        self.selectedImage = [[UIImageView alloc] initWithFrame:self.filterIcon.bounds];
        self.selectedImage.backgroundColor = [UIColor blackColor];
        self.selectedImage.alpha = 0.6;
        self.selectedImage.hidden = YES;
        [self.filterIcon addSubview:self.selectedImage];
        
        
        self.filterName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filterIcon.frame) + 10, width, Width(15))];
        self.filterName.backgroundColor = [UIColor clearColor];
        self.filterName.numberOfLines = 1;
        self.filterName.textAlignment = NSTextAlignmentCenter;
        self.filterName.font = [UIFont systemFontOfSize:15];
        self.filterName.textColor = [UIColor lightGrayColor];
        [self addSubview:self.filterName];
    }
    return self;
}
- (void)setModel:(MHFilterInfo *)model
{
    _model = model;
    self.filterName.text = model.filterName;
}
- (void)setIs_Selected:(BOOL)is_Selected
{
    _is_Selected = is_Selected;
    self.selectedImage.hidden = !is_Selected;
}
@end
