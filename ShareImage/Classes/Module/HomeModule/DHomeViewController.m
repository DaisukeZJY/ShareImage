//
//  DHomeViewController.m
//  DFrame
//
//  Created by DaiSuke on 16/8/22.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

#import "DHomeViewController.h"
#import "DUserProfileViewController.h"

#import "DSearchViewController.h"
#import "DCommonPhotoController.h"
#import "DUserCollectionsController.h"
#import "DSettingViewController.h"
#import "DCommonPhotoController.h"

#import "DUITableView.h"
#import "DHomeTableViewCell.h"
#import "DHomeMenuView.h"

#import "DPhotosAPIManager.h"
#import "DCollectionsAPIManager.h"
#import "DUserAPIManager.h"
#import "DMWPhotosManager.h"

#import "DPhotosParamModel.h"
#import "DCollectionsParamModel.h"
#import "DPhotosModel.h"
#import "DUserParamModel.h"

#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "LLSlideMenu.h"


#define kPhotoModelIndex        @"kPhotoModelIndex"

@interface DHomeViewController ()<UITableViewDelegate, UITableViewDataSource, DHomeMenuViewDelegate>

@property (nonatomic, strong) DUITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) LLSlideMenu *slideMenu;
@property (nonatomic, strong) DHomeMenuView *menuView;

@property (nonatomic, strong) DMWPhotosManager *manager;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footerView;


@end

@implementation DHomeViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.slideMenu];
    self.title = kLocalizedLanguage(@"tabHome");
//    [self.tabBarItem setTitle:kLocalizedLanguage(@"tabHome")];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.navLeftItemType = DNavigationItemTypeRightMenu;
    self.navRighItemType = DNavigationItemTypeRightSearch;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 初始化上下拉刷新
    [self setupTableViewUpAndDowmLoad];
    
    [self.view addSubview:self.tableView];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.slideMenu.hidden = YES;
    self.menuView.hidden = YES;
    if (self.slideMenu.ll_isOpen) {
        [self.slideMenu ll_closeSlideMenu];
    }
    if (self.slideMenu) {
        [self.slideMenu removeFromSuperview];
        self.slideMenu = nil;
    }

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    // 布局子视图
    [self setupSubViewsAutoLayout];
    
}

#pragma mark - 菜单部分


#pragma mark - 私有方法
- (void)setupSubViewsAutoLayout{
    self.tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view,0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
}

- (void)getPhotosData{
    DPhotosAPIManager *manager = [DPhotosAPIManager getHTTPManagerByDelegate:self info:self.networkUserInfo];
    DPhotosParamModel *paramModel = [[DPhotosParamModel alloc] init];
    paramModel.page = self.page;
    paramModel.per_page = 20;
    [manager fetchPhotosByParamModel:paramModel];
}


/**
 设置上下拉刷新
 */
- (void)setupTableViewUpAndDowmLoad{
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            self.page = 1;
            [self getPhotosData];
        });
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = self.footerView;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DHomeTableViewCell *cell = [DHomeTableViewCell cellWithTableView:tableView];
    
    if (self.photos.count > indexPath.section) {
        DPhotosModel *model = self.photos[indexPath.section];
        cell.photosModel = model;
        DUserModel *userModel = model.user;
        @weakify(self)
        [cell setClickIconBlock:^{
            DLog(@"点击头像");
            @strongify(self)
            DUserProfileViewController *userController = [[DUserProfileViewController alloc] initWithUserName:userModel.username type:DUserProfileTypeForOther];
            [self.navigationController pushViewController:userController animated:YES];
        }];
        [cell setClickLikeBlock:^{
           @strongify(self)
            [self.networkUserInfo setObject:@(indexPath.section) forKey:kPhotoModelIndex];
            DPhotosAPIManager *manager = [DPhotosAPIManager getHTTPManagerByDelegate:self info:self.networkUserInfo];
            DPhotosParamModel *paramModel = [[DPhotosParamModel alloc] init];
            paramModel.pid = model.pid;
            [manager likePhotoByParamModel:paramModel];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.photos[indexPath.section];
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"photosModel" cellClass:[DHomeTableViewCell class] contentViewWidth:self.view.width];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.photos.count > indexPath.section) {
        DPhotosModel *photoModel = self.photos[indexPath.section];
        [self.manager photoPreviewWithPhotoModels:@[photoModel] currentIndex:0 currentViewController:self];
    }
}


#pragma mark - DHomeMenuViewDelegate
- (void)homeMenuView:(DHomeMenuView *)homeMenuView didClickHeaderView:(DHomeMenuHeader *)headerView{
    DUserProfileViewController *userController = [[DUserProfileViewController alloc] initWithUserName:KGLOBALINFOMANAGER.accountInfo.username type:DUserProfileTypeForMine];
    [self.navigationController pushViewController:userController animated:YES];
    
}

- (void)homeMenuView:(DHomeMenuView *)homeMenuView didSelectIndex:(NSInteger)selectIndex{
    switch (selectIndex) {
        case 0:
        {
            DCommonPhotoController *photoView = [[DCommonPhotoController alloc] initWithTitle:kLocalizedLanguage(@"homePhotos") type:UserAPIManagerType];
            photoView.username = KGLOBALINFOMANAGER.accountInfo.username;
            [self.navigationController pushViewController:photoView animated:YES];
        }
            break;
        case 1:
        {
            DUserCollectionsController *collectionView = [[DUserCollectionsController alloc] init];
            [self.navigationController pushViewController:collectionView animated:YES];
        }
            break;
        case 2:
        {
            // 喜欢的图片
            DCommonPhotoController *likeView = [[DCommonPhotoController alloc] initWithTitle:kLocalizedLanguage(@"homeLikes") type:UserAPIManagerLikePhotoType];
            likeView.username = KGLOBALINFOMANAGER.accountInfo.username;
            [self.navigationController pushViewController:likeView animated:YES];
        }
            break;
        case 3:
        {
            DSettingViewController *collectionView = [[DSettingViewController alloc] init];
            [self.navigationController pushViewController:collectionView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 导航栏点击事件
- (void)navigationBarDidClickNavigationBtn:(UIButton *)navBtn isLeft:(BOOL)isLeft{
    if (isLeft) {
        self.slideMenu.hidden = NO;
        self.menuView.hidden = NO;
        if (self.slideMenu.ll_isOpen) {
            [self.slideMenu ll_closeSlideMenu];
        } else {
            [self.slideMenu ll_openSlideMenu];
            [self.menuView reloadData];
        }
    } else {
        DSearchViewController *searchController = [[DSearchViewController alloc] init];
        [self.navigationController pushViewController:searchController animated:YES];
    }
}


#pragma mark - 请求回调
- (void)requestServiceSucceedWithModel:(__kindof DJsonModel *)dataModel userInfo:(NSDictionary *)userInfo{
    [self.tableView reloadData];
}


- (void)requestServiceSucceedBackArray:(NSArray *)arrData userInfo:(NSDictionary *)userInfo{
    
    self.page++;
    [self.photos addObjectsFromArray:arrData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
    self.footerView.stateLabel.hidden = NO;
    [self.tableView setTableFooterView:[UIView new]];
    [self removeNoDataView];
}

- (void)unlockUI{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)clearData{
    [self.photos removeAllObjects];
}

- (void)hasNotMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)alertNoData{
    [self clearData];
    self.footerView.stateLabel.hidden = YES;
    self.noDataView.titleLabel.text = @"Very Sorry\n No Photos You Want";
    [self addNoDataViewAddInView:self.tableView];
    [self setNoNetworkDelegate:self];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView reloadData];
}

#pragma mark - getter & setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[DUITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DSystemColorGrayF3F3F3;
    }
    return _tableView;
}

- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}


- (DMWPhotosManager *)manager{
    if (!_manager) {
        _manager = [[DMWPhotosManager alloc] init];
        _manager.longPressType = DMWPhotosManagerTypeForSaveDownLoadLike;
    }
    return _manager;
}


- (LLSlideMenu *)slideMenu{
    if (!_slideMenu) {
        _slideMenu = [[LLSlideMenu alloc] init];
        _slideMenu.ll_menuWidth = 200.f;
        _slideMenu.ll_menuBackgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        _slideMenu.ll_distance = 100.f;     // 拉伸距离  pulling distance
        _slideMenu.ll_springDamping = 20;       // 阻力
        _slideMenu.ll_springVelocity = 15;      // 速度
        _slideMenu.ll_springFramesNum = 60;     // 关键帧数量
        _slideMenu.hidden = YES;
        _slideMenu.ll_isOpen = NO;
        self.menuView = [[DHomeMenuView alloc] init];
        [self.menuView setFrame:0 y:0 w:200 h:SCREEN_HEIGHT];
        self.menuView.delegate = self;
        self.menuView.hidden = YES;

        [_slideMenu addSubview:self.menuView];
    }
    return _slideMenu;
}

- (MJRefreshAutoNormalFooter *)footerView{
    if (!_footerView) {
        @weakify(self);
        _footerView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self getPhotosData];
            });
        }];
        _footerView.stateLabel.hidden = YES;
    }
    return _footerView;
}




@end
