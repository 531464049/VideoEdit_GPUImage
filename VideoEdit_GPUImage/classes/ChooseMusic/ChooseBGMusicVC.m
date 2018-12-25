//
//  ChooseBGMusicVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ChooseBGMusicVC.h"

@interface ChooseBGMusicVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tabview;
@property(nonatomic,strong)NSArray * musicsArr;

@end

@implementation ChooseBGMusicVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"选择音乐"];
    self.musicsArr = [self readAllMusicList];
    self.tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight) style:UITableViewStylePlain];
    self.tabview.showsVerticalScrollIndicator = NO;
    self.tabview.showsHorizontalScrollIndicator = NO;
    self.tabview.backgroundColor = [UIColor whiteColor];
    self.tabview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    [self.tabview mh_fixIphoneXBottomMargin];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * chooseID = @"gdfhrberxjtbnmnbyvr";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:chooseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseID];
    }
    cell.textLabel.text = self.musicsArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString * musicName = self.musicsArr[indexPath.row];
    NSLog(@"%@",musicName);
    [MAlertView showAlertIn:self msg:@"是否选择该背景音乐" callBack:^(BOOL sure) {
        if (sure) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(bgMusicChooseCallBack:)]) {
                [self.delegate bgMusicChooseCallBack:musicName];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(NSArray *)readAllMusicList
{
    NSArray * arr = @[
                      @"Aeolus (Original Mix) - Jeremy Lim",
                      @"Alpha - Christophe Lebled",
                      @"August Night - Martian",
                      @"Aurora - Capo Productions",
                      @"Black & White (Vinid Ambient Mix) - Vinid & Vla-D,The Great Voices of Bulgaria"
                      ];
    return arr;
}
@end
