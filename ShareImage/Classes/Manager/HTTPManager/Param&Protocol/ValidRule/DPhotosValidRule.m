//
//  DPhotosValidRule.m
//  ShareImage
//
//  Created by DaiSuke on 2017/2/17.
//  Copyright © 2017年 DaiSuke. All rights reserved.
//

#import "DPhotosValidRule.h"
//#import "DPhotosParamModel.h"

@implementation DPhotosValidRule

+ (NSString *)checkPhotoIDByParamModel:(id<DPhotosParamProtocol>)paramModel{
    if (paramModel.pid.length == 0) {
        return @"图片的ID必须有";
    }
    return @"";
}

+ (NSString *)checkSearchPhotoByParamModel:(id<DPhotosParamProtocol>)paramModel{
    if (paramModel.query.length == 0) {
        return @"请输入关键字";
    }
    return @"";
}

@end
