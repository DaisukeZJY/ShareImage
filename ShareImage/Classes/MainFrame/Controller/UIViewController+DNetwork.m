//
//  UIViewController+DNetwork.m
//  DFrame
//
//  Created by DaiSuke on 2016/12/22.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

#import "UIViewController+DNetwork.h"
#import <objc/runtime.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Reachability.h"

#import "DOAuthViewController.h"
#import "DNavigationViewController.h"

static char* const networkLoadingView_KEY = "networkLoadingView";
static char* const noNetworkAlertView_KEY = "noNetworkAlertView";
static char* const networkErrorReloadView_KEY = "networkErrorReloadView";
static char* const noNetworkDelegate_KEY = "noNetworkDelegate";
static char* const noNoDataView_KEY = "DataView";


@implementation UIViewController (DNetwork)

#pragma mark - 动态添加属性
- (void)setNetworkLoadingView:(UIView *)networkLoadingView{
    objc_setAssociatedObject(self, networkLoadingView_KEY, networkLoadingView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)networkLoadingView{
    return objc_getAssociatedObject(self, networkLoadingView_KEY);
}

- (void)setNoNetworkAlertView:(UIControl *)noNetworkAlertView{
    objc_setAssociatedObject(self, noNetworkAlertView_KEY, noNetworkAlertView, OBJC_ASSOCIATION_RETAIN);
}

- (UIControl *)noNetworkAlertView{
    return objc_getAssociatedObject(self, noNetworkAlertView_KEY);
}

- (void)setNetworkErrorReloadView:(UIControl *)networkErrorReloadView{
    objc_setAssociatedObject(self, networkErrorReloadView_KEY, networkErrorReloadView, OBJC_ASSOCIATION_RETAIN);
}

- (UIControl *)networkErrorReloadView{
    return objc_getAssociatedObject(self, networkErrorReloadView_KEY);
}

- (void)setNoNetworkDelegate:(id<NoNetworkButtonDelegate>)noNetworkDelegate{
    objc_setAssociatedObject(self, noNetworkDelegate_KEY, noNetworkDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (id<NoNetworkButtonDelegate>)noNetworkDelegate{
    return objc_getAssociatedObject(self, noNetworkDelegate_KEY);
}

- (void)setNoDataView:(DNoDataView *)noDataView{
    objc_setAssociatedObject(self, noNoDataView_KEY, noDataView, OBJC_ASSOCIATION_RETAIN);
}

- (DNoDataView *)noDataView{
    return objc_getAssociatedObject(self, noNoDataView_KEY);
}

#pragma mark - 暴露方法

/**
 断网通知
 */
- (void)noNetworkNotify{
    
}

/**
 *  添加断网提示页面
 *
 *  @param inView 断网提示页面需要添加到哪个页面
 */
- (void)addNotNetworkAlertViewAddInView:(UIView *)inView{
    [self addNotNetworkAlertViewAddInView:inView customY:0];
}

/**
 *  添加断网提示页面
 *
 *  @param inView 断网提示页面需要添加到哪个页面
 *  @param customY 在页面Y轴距离父view的顶部的距离
 */
- (void)addNotNetworkAlertViewAddInView:(UIView *)inView customY:(CGFloat)customY{
    [self removeNoNetworkAlertView];
    
    CGRect rect = inView.frame;
    rect.origin.y = 0;
    
    self.noNetworkAlertView = [[UIControl alloc] initWithFrame:rect];
//    [self.noNetworkAlertView setBackgroundColor:[UIColor whiteColor]];
    self.noNetworkAlertView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    CGFloat currentHeight = (rect.size.height - kVIEW_IMG_RELOAD_HEIGHT)/2 - 40;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((rect.size.width - kVIEW_IMG_RELOAD_WIDTH)/2.0, currentHeight, kVIEW_IMG_RELOAD_WIDTH, kVIEW_IMG_RELOAD_HEIGHT)];
    imageView.image = [UIImage getImageWithName:@"common_refresh"];
    [self.noNetworkAlertView addSubview:imageView];
    
    currentHeight += kVIEW_IMG_RELOAD_HEIGHT+15;
    
    UILabel *reloadContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, SCREEN_WIDTH - 20, 20)];
    [reloadContentLabel setNumberOfLines:0];
    [reloadContentLabel setBackgroundColor:[UIColor clearColor]];
    [reloadContentLabel setText:@"网络异常,轻触重新加载"];
    [reloadContentLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [reloadContentLabel setTextColor:DSystemColorBlackContent];
    reloadContentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [reloadContentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.noNetworkAlertView addSubview:reloadContentLabel];
    
    [self.noNetworkAlertView addTarget:self action:@selector(pressToRefresh) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:self.noNetworkAlertView];
    
}


- (void)addNoDataViewAddInView:(UIView *)inView{
    [self removeNoDataView];
    
    self.noDataView = [[DNoDataView alloc] init];
    self.noDataView.titleLabel.text = @"Very Sorry\n No Datas You Want";
    [self.noDataView.refreshButton addTarget:self action:@selector(clickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [self.noDataView setFrame:0 y:20 w:SCREEN_WIDTH h:SCREEN_HEIGHT - 20];
    [inView addSubview:self.noDataView];
    [inView bringSubviewToFront:self.noDataView];
}

- (void)removeNoDataView{
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
}



#pragma mark - 私有方法
- (void)pressToRefresh{
    if (self.noNetworkDelegate && [self.noNetworkDelegate respondsToSelector:@selector(pressNoNetworkBtnToRefresh)]) {
        [self.noNetworkDelegate pressNoNetworkBtnToRefresh];
    } else {
        DLog(@"未实现代理NoNetworkButtonDelegate");
    }
}

- (void)clickRefreshButton{
    if (self.noNetworkDelegate && [self.noNetworkDelegate respondsToSelector:@selector(pressNoDataBtnToRefresh)]) {
        [self.noNetworkDelegate pressNoDataBtnToRefresh];
    } else {
        DLog(@"未实现代理NoNetworkButtonDelegate");
    }
}


#pragma mark - 暴露方法
/**
 *  移除断网提示页面
 */
- (void)removeNoNetworkAlertView{
    if (self.noNetworkAlertView) {
        [self.noNetworkAlertView removeFromSuperview];
        self.noNetworkAlertView = nil;
    }
}

/**
 *  添加网络错误重新加载页面
 *
 *  @param inView 网络错误重新加载页面需要添加到哪个页面
 */
- (void)addnetworkErrorReloadViewAddInView:(UIView *)inView{
    [self removeNetworkErrorReloadView];
    
    CGRect rect = inView.frame;
    rect.origin = CGPointMake(0, 0);
    
    self.networkErrorReloadView = [[UIControl alloc] initWithFrame:rect];
    [self.networkErrorReloadView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat currentHeight = (rect.size.height - kVIEW_IMG_RELOAD_HEIGHT)/2 - 40;;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((rect.size.width - kVIEW_IMG_RELOAD_WIDTH)/2.0, currentHeight, kVIEW_IMG_RELOAD_WIDTH, kVIEW_IMG_RELOAD_HEIGHT)];
    imageView.image = [UIImage getImageWithName:@"common_refresh"];
    [self.networkErrorReloadView addSubview:imageView];
    
    currentHeight += kVIEW_IMG_RELOAD_HEIGHT+15;
    
    UILabel *reloadContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, SCREEN_WIDTH - 20, 20)];
    [reloadContentLabel setNumberOfLines:0];
    [reloadContentLabel setBackgroundColor:[UIColor clearColor]];
    [reloadContentLabel setText:@"加载失败,轻触重新加载"];
    [reloadContentLabel setFont:[UIFont systemFontOfSize:15.0]];
    reloadContentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [reloadContentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.networkErrorReloadView addSubview:reloadContentLabel];
    
    [self.networkErrorReloadView addTarget:self action:@selector(pressToRefresh) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:self.networkErrorReloadView];
}

/**
 *  移除网络错误重新加载页面
 */
- (void)removeNetworkErrorReloadView{
    if (self.networkErrorReloadView) {
        [self.networkErrorReloadView removeFromSuperview];
        self.networkErrorReloadView = nil;
    }
}

/**
 *  网络请求加载动画
 *
 *  @param strText 现在加载的文字提示
 */
- (void)addNetworkLoadingViewByText:(NSString *)strText userInfo:(NSDictionary *)userInfo{
    
    NSString *strClass = NSStringFromClass([self class]);
    if (userInfo && [[userInfo objectForKey:KVIEWNAME] isEqualToString:strClass]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDModeCustomView;
        hud.activityIndicatorColor = [UIColor blackColor];
        hud.color = [UIColor whiteColor];
        hud.labelColor = [UIColor blackColor];
        hud.labelText = strText;
        hud.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        [self.view bringSubviewToFront:hud];
    }
}

/**
 *  移除网络请求加载动画
 */
- (void)removeNetworkLoadingView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  本地错误提示
 *
 *  @param localError 根据对象的isAlertFor2Second判断提示类型，yes：弹自定义提示控件 no：弹提示对话框
 *                    根据对象的titleText显示提示标题（标题不存在时不显示,只有提示框才有效）
 *                    根据对象的alertText显示提示内容
 */
- (void)localError:(DLocalError *)localError userInfo:(NSDictionary *)userInfo{
    if(localError == nil){
        return;
    }
    NSString *strClass = NSStringFromClass([self class]);
    if(userInfo && [[userInfo objectForKey:KVIEWNAME] isEqualToString:strClass]){
        NSDictionary *dicError = (NSDictionary *)[DCacheManager getCacheObjectForKey:kVIEW_KEY_ERROR];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        if(dicError){
            NSDate *date = [NSDate date];
            NSDate *lastDate = [dicError objectForKey:kVIEW_KEY_DATE];
            DLog(@"%@",@([date timeIntervalSinceDate:lastDate]));
            if(lastDate && [date timeIntervalSinceDate:lastDate] < 1){
                NSString *strContent = [dicError objectForKey:kVIEW_KEY_CONTENT];
                [dic setObject:[NSDate date] forKey:kVIEW_KEY_DATE];
                [dic setObject:localError.alertText forKey:kVIEW_KEY_CONTENT];
                [DCacheManager setCacheObjectByData:dic forKey:kVIEW_KEY_ERROR withTimeoutInterval:kVIEW_ERROR_SAVE_TIME];
                if([strContent isEqualToString:localError.alertText]){
                    return;
                }
            }
            
        }
        [dic setObject:[NSDate date] forKey:kVIEW_KEY_DATE];
        [dic setObject:localError.alertText forKey:kVIEW_KEY_CONTENT];
        [DCacheManager setCacheObjectByData:dic forKey:kVIEW_KEY_ERROR withTimeoutInterval:kVIEW_ERROR_SAVE_TIME];
        if(localError.isAlertFor2Second){
            [DAlert show:localError.alertText hasSuccessIcon:NO AndShowInView:self.view];
            return;
        }
        
        DAlertView *alert = [[DAlertView alloc] initWithTitle:localError.titleText andMessage:localError.alertText];
        __weak UIViewController *weakSelf= self;
        if (localError.errCode == 3840) {
            NSMutableDictionary *dicUser = userInfo.mutableCopy;
            [dicUser setObject:@(YES) forKey:kErrorNeedBackKey];
            userInfo = dicUser.copy;
        }
        if(localError.errCode == -1001 && [userInfo objectForKey:KNEEDRELOAD] && [[userInfo objectForKey:KNEEDRELOAD] boolValue]){
            
            [alert addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeCancel handler:^(DAlertView *alertView) {
                [weakSelf addReloadViewForNetworkError];
            }];
            
            [alert addButtonWithTitle:@"重新加载" type:CustomAlertViewButtonTypeDefault handler:^(DAlertView *alertView) {
                [weakSelf reloadDataForBadNetwork];
            }];
        }
        else{
            [alert addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeDefault handler:^(DAlertView *alertView) {
                [weakSelf addReloadViewForNetworkError];
                id object = [userInfo objectForKey:kErrorNeedBackKey];
                if(object && [object boolValue]){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
        [alert show];
    }
}

/**
 *  UI本地错误提示
 *
 *  @param alertText         提示内容
 *  @param isAlertFor2Second yes：弹自定义提示控件 no：弹提示对话框
 */
- (void)localError:(NSString *)alertText isAlertFor2Second:(BOOL)isAlertFor2Second{
    if (alertText.length == 0) {
        return;
    }
    if (isAlertFor2Second) {
        [SVProgressHUD showErrorWithStatus:alertText];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    DAlertView *alert = [[DAlertView alloc] initWithTitle:@"" andMessage:alertText];
    [alert addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alert show];
    
}

/**
 吐司弹出成功提示
 
 @param strText 内容
 */
- (void)localShowSuccess:(NSString *)strText{
    [SVProgressHUD showSuccessWithStatus:strText];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}


/**
 *  账号异常时让用户退出并重新登录，跳转至登陆页面
 */
- (void)logoutByType:(LogoutType)type{
    @weakify(self)
    switch (type) {
        case LogoutTypeForNoValid:
        {
            
        }
            break;
        case LogoutTypeForNoOAuth:
        {
            
        }
            break;
        case LogoutTypeForOther:
        {
            DAlertView *alertView = [[DAlertView alloc] initWithTitle:@"" andMessage:@"Do You Want To LogOut?"];
            [alertView addButtonWithTitle:@"No" handler:nil];
            [alertView addButtonWithTitle:@"Yes" handler:^(DAlertView *alertView) {
                @strongify(self)
                [self logout];
            }];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)logout{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(NO) forKey:[NSString stringWithFormat:kCacheIsLoginByUid,KGLOBALINFOMANAGER.uid]];
    [KGLOBALINFOMANAGER setIsAlertLogout:NO];
    [KGLOBALINFOMANAGER clearAllInfo];
    // 授权
    // 切换窗口的跟控制器
    self.view.window.rootViewController = [[DOAuthViewController alloc] init];
    
}


#pragma mark - 子类重写的
/**
 *  锁UI
 */
- (void)lockUI{
    
}

/**
 *  解除UI锁定
 */
- (void)unlockUI{
    
}

//网络超时-重新获取数据
- (void)reloadDataForBadNetwork{
    
}

//网络错误-重新获取数据
- (void)addReloadViewForNetworkError{
    
}

// 点击刷新
- (void)pressNoNetworkBtnToRefresh{
    
}

@end
