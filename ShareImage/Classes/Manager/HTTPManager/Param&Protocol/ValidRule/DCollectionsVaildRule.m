//
//  DCollectionsVaildRule.m
//  ShareImage
//
//  Created by FTY on 2017/2/22.
//  Copyright © 2017年 DaiSuke. All rights reserved.
//

#import "DCollectionsVaildRule.h"

@implementation DCollectionsVaildRule
+ (NSString *)checkCollectionIDByParamModel:(id<DCollectionParamProtocol>)paramModel{
    if (paramModel.collection_id == 0) {
        return @"分类的ID必须有";
    }
    return @"";
}

+ (NSString *)checkCreateCollectionByParamModel:(id<DCollectionParamProtocol>)paramModel{
    if (paramModel.title.length == 0) {
        return @"分类的标题必须有";
    }
    return @"";
}

+ (NSString *)checkAddPhotoToCollectionByParamModel:(id<DCollectionParamProtocol>)paramModel{
    if (paramModel.collection_id == 0) {
        return @"分类的ID必须有";
    } else if (paramModel.photo_id.length == 0) {
        return @"图片的ID必须有";
    }
    return @"";
}
@end
