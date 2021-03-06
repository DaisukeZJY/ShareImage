//
//  DHomeTableViewCell.m
//  ShareImage
//
//  Created by DaiSuke on 2017/2/17.
//  Copyright © 2017年 DaiSuke. All rights reserved.
//

#import "DHomeTableViewCell.h"
#import "DPhotosModel.h"
#import "DHomeCellTipLabel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+DUIImage.h"
#import "UIButton+DWebImage.h"

static NSString *const cellID = @"homeCell";

@interface DHomeTableViewCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIView *iconBgView;
@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) DHomeCellTipLabel *addressLabel;
@property (nonatomic, strong) DHomeCellTipLabel *likeLabel;
@end

@implementation DHomeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    DHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}


#pragma mark - 私有方法
- (void)setupSubViews{
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.iconBgView];
    [self.iconBgView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.photoView addSubview:self.likeLabel];
    [self.contentView addSubview:self.addressLabel];
    
    // layout
    self.photoView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(200);
    
    self.iconBgView.sd_layout
    .topSpaceToView(self.photoView, -25)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(50)
    .heightIs(50);
    
    self.iconView.sd_layout
    .centerXEqualToView(self.iconBgView)
    .centerYEqualToView(self.iconBgView)
    .widthIs(46)
    .heightIs(46);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.photoView, 2)
    .leftSpaceToView(self.iconBgView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20);
    
    self.likeLabel.sd_layout
    .topSpaceToView(self.photoView, 0)
    .rightSpaceToView(self.photoView, 10)
    .widthIs(60)
    .heightIs(40);
    
    self.addressLabel.sd_layout
    .topSpaceToView(self.nameLabel, 0)
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.contentView,10)
    .heightIs(20);
}

- (void)clickIcon{
    ExistActionDo(self.clickIconBlock, self.clickIconBlock());
}

- (void)clickLike{
    ExistActionDo(self.clickLikeBlock, self.clickLikeBlock());
}

#pragma mark - getter & setter
- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.backgroundColor = [UIColor lightRandom];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.userInteractionEnabled = YES;
    }
    return _photoView;
}

- (UIView *)iconBgView{
    if (!_iconBgView) {
        _iconBgView = [[UIView alloc] init];
        _iconBgView.backgroundColor = [UIColor whiteColor];
        [_iconBgView.layer setCornerRadius:25.0];
        [_iconBgView.layer setMasksToBounds:YES];
    }
    return _iconBgView;
}

- (UIButton *)iconView{
    if (!_iconView) {
        _iconView = [[UIButton alloc] init];
        [_iconView addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
//        [_iconView.layer setCornerRadius:23.0];
//        [_iconView.layer setMasksToBounds:YES];
        _iconView.backgroundColor = [UIColor whiteColor];
    }
    return _iconView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = DSystemFontTitle;
    }
    return _nameLabel;
}

- (DHomeCellTipLabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel = [[DHomeCellTipLabel alloc] init];
        _likeLabel.iconName = @"common_btn_like_hight";
        _likeLabel.describeLabel.textColor = [UIColor whiteColor];
        _likeLabel.describeLabel.font = DSystemFontTitle;
        _likeLabel.mode = HomeCellTipLabelRight;
        [_likeLabel addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeLabel;
}

- (DHomeCellTipLabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[DHomeCellTipLabel alloc] init];
        _addressLabel.iconName = @"common_btn_address_normal";
    }
    return _addressLabel;
}

- (void)setPhotosModel:(DPhotosModel *)photosModel{
    _photosModel = photosModel;
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photosModel.urls.small] placeholderImage:[UIImage getImageWithName:@""]];
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:photosModel.user.profile_image.large] forState:UIControlStateNormal placeholderImage:[UIImage getImageWithName:@""]];
//    @weakify(self)
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:photosModel.user.profile_image.large] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        image = [image imageByRoundCornerRadiusWithimageViewSize:CGSizeMake(46, 46)];
//        @strongify(self)
//        [self.iconView setImage:image forState:UIControlStateNormal];
//    }];
    [self.iconView setImageWithURL:photosModel.user.profile_image.large forState:UIControlStateNormal cornerRadius:23];
    
    self.nameLabel.text = photosModel.user.name;
    
    if (photosModel.likes > 0) {
        self.likeLabel.hidden = NO;
        self.likeLabel.describe = [NSString stringWithFormat:@"%@", @(photosModel.likes)];
    } else {
        self.likeLabel.hidden = YES;
    }
    
    if (photosModel.user.location.length > 0) {
        self.addressLabel.hidden = NO;
        self.addressLabel.describe = photosModel.user.location;
        // 设置最低端的距离
        [self setupAutoHeightWithBottomView:self.addressLabel bottomMargin:10];
    } else {
        self.addressLabel.hidden = YES;
        // 设置最低端的距离
        [self setupAutoHeightWithBottomView:self.iconBgView bottomMargin:10];
    }
}

@end
