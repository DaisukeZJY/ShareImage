//
//  DUserAPIManager.h
//  DFrame
//
//  Created by DaiSuke on 16/9/27.
//  Copyright © 2016年 DaiSuke. All rights reserved.
//

#import "DBaseManager.h"
#import "DOAuthParamProtocol.h"
#import "DUserParamProtocol.h"

@interface DUserAPIManager : DBaseManager

/**
 授权
 
 参数模型：DOAuthParamModel
 client_id：AppKey(Required)
 client_secret：秘钥;(Required)
 redirect_uri：回调地址;(Required)
 grant_type：授权类型 @"authorization_code";(Required)
 code：固定 code; (Required)
 
 回调：requestServiceSucceedWithModel:(DOAuthAccountModel)
 
 @param paramModel 参数模型
 */
- (void)oauthAccountByParamModel:(id<DOAuthParamProtocol>)paramModel;

/**
 *  获取个人信息
 
  回调：requestServiceSucceedWithModel:(DUserModel)
 *
 */
-(void)fetchAccountProfile;

/**
 *  获取个人信息(不使用缓存)
 
  回调：requestServiceSucceedWithModel:(DUserModel)
 *
 */
-(void)fetchAccountProfileWithNotCache;

/**
 更改个人信息
 
 参数模型：DUserParamModel
 username 用户名(Optional)
 first_name 姓(Optional)
 last_name 名(Optional)
 email email,格式必须正确(Optional)
 url 个人简介地址(Optional)
 location 地址(Optional)
 bio 简介(Optional)
 instagram_username instagram昵称
 
 回调：requestServiceSucceedWithModel:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)updateAccountByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户信息
 
 参数模型：DUserParamModel
 username 用户名(Required)
 
 回调：requestServiceSucceedWithModel:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserProfileByParamModel:(id<DUserParamProtocol>)paramModel;

/**
 获取用户介绍连接
 
 参数模型：DUserParamModel
 username 用户名(Required)
 
 回调：requestServiceSucceedBackString:(NSSting)
 
 @param paramModel 参数模型
 */
- (void)fetchUserProfileLinkByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户的图片集合
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 page：页数（Optional; default: 1）
 per_page：每页多少条（Optional; default: 10）
 order_by：排序（Valid values: latest, oldest, popular; default: latest）
 
 回调：requestServiceSucceedBackArray:(DPhotosModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserPhotosByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户喜欢的图片集合
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 page：页数（Optional; default: 1）
 per_page：每页多少条（Optional; default: 10）
 order_by：排序（Valid values: latest, oldest, popular; default: latest）
 
 回调：requestServiceSucceedBackArray:(DPhotosModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserLikePhotosByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户分类集合
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 page：页数（Optional; default: 1）
 per_page：每页多少条（Optional; default: 10）
 order_by：排序（Valid values: latest, oldest, popular; default: latest）
 
 回调：requestServiceSucceedBackArray:(DCollectionsModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserCollectionsByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户关注的人
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 page：页数（Optional; default: 1）
 per_page：每页多少条（Optional; default: 10）
 
 回调：requestServiceSucceedBackArray:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserFollowingByParamModel:(id<DUserParamProtocol>)paramModel;


/**
 获取用户粉丝
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 page：页数（Optional; default: 1）
 per_page：每页多少条（Optional; default: 10）
 
 回调：requestServiceSucceedBackArray:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)fetchUserFollowersByParamModel:(id<DUserParamProtocol>)paramModel;




/**
 关注
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 
 回调：requestServiceSucceedWithModel:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)followUserByParamModel:(id<DUserParamProtocol>)paramModel;




/**
 取消关注
 
 参数模型：DUserParamModel
 username: 用户名(Required)
 
 回调：requestServiceSucceedWithModel:(DUserModel)
 
 @param paramModel 参数模型
 */
- (void)cancelFollowUserByParamModel:(id<DUserParamProtocol>)paramModel;



@end
