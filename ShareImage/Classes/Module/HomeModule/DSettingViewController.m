//
//  DSettingViewController.m
//  ShareImage
//
//  Created by FTY on 2017/3/14.
//  Copyright © 2017年 DaiSuke. All rights reserved.
//

#import "DSettingViewController.h"
#import "DSettingTableViewCell.h"

#import "DAboutViewController.h"
#import "DLanguageViewController.h"
#import "DNavigationViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/SDImageCache.h>


@interface DSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, assign) NSString *cacheSizeStr;

@end

@implementation DSettingViewController

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeLanguageNotificationName object:nil];
//}

/**
 夜间（考虑）、缓存、语言、关于、退出
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self)
    kLanguageManager.completion = ^(NSString *language){
        @strongify(self)
        [self refreshLanguage];
    };
    
    [self setupData];
    [self setupView];
    
}

- (void)setupData{
    self.navLeftItemType = DNavigationItemTypeBack;
    
//    [self refreshCacheData];
    [self refreshLanguage];
   
}

- (void)setupView{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

//- (void)refreshCacheData{
//    NSInteger size = [[SDImageCache sharedImageCache] getSize];
//    NSInteger sizeF = size / 1024 / 1024;
//    self.cacheSizeStr = [NSString stringWithFormat:@"%@M", @(sizeF)];
//    [self.tableView reloadData];
//}

- (void)clickLogout{
    [self logoutByType:LogoutTypeForOther];
}

#pragma mark - overLoad
- (void)refreshLanguage{
    self.title = kLocalizedLanguage(@"settings");
    self.titles = @[@[kLocalizedLanguage(@"language"), kLocalizedLanguage(@"night")], @[kLocalizedLanguage(@"give Evaluation")], @[kLocalizedLanguage(@"clear Storage"),kLocalizedLanguage(@"about")]];
    [self.tableView reloadData];
}


- (void)navigationBarDidClickNavigationBtn:(UIButton *)navBtn isLeft:(BOOL)isLeft{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 1;
            break;
        case 0:
        case 2:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSettingTableViewCell *cell = [DSettingTableViewCell cellWithTableView:tableView];
    
    if (self.titles.count > indexPath.section) {
        NSArray *titleArr = self.titles[indexPath.section];
        [cell setLeftTitle:titleArr[indexPath.row] indexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 144;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = DSystemColorGrayF3F3F3;
        [bgView setFrame:0 y:0 w:self.view.width h:144];
        
        UIButton *logoutBtn = [[UIButton alloc] init];
        logoutBtn.backgroundColor = [UIColor whiteColor];
        [logoutBtn setTitle:kLocalizedLanguage(@"log Out") forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [logoutBtn.layer setBorderColor:DSystemColorGrayE0E0E0.CGColor];
        [logoutBtn.layer setBorderWidth:0.5];
        [logoutBtn setFrame:-0.5 y:50 w:self.view.width+1 h:44];
        [bgView addSubview:logoutBtn];
        return bgView;
    }
    
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                DNavigationViewController *nav = [[DNavigationViewController alloc] initWithRootViewController:[[DLanguageViewController alloc] init]];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                @weakify(self)
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                    [SVProgressHUD showSuccessWithStatus:kLocalizedLanguage(@"clean up!")];
                    @strongify(self)
                    [self.tableView reloadData];
                }];
            } else {
                DAboutViewController *about = [[DAboutViewController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter & setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = DSystemColorGrayF3F3F3;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}
/**
 夜间（考虑）、缓存、语言、关于、退出
 */
//- (NSArray *)titles{
//    if (!_titles) {
//        _titles = @[@[kLocalizedString(@"Language", @"语言"), kLocalizedString(@"Night", @"夜间模式")], @[@"Give Evaluation"], @[@"Clear Storage", @"About"]];
//    }
//    return _titles;
//}

//- (NSArray *)contents{
//    if (!_contents) {
//        _contents = @[@[@""], @[@""], @[@"", @""]];
//    }
//    return _contents;
//}




@end
