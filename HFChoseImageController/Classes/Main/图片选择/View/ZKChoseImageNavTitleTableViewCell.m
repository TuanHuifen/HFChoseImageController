//
//  ZKChoseImageNavTitleTableViewCell.m
//  ZK
//
//  Created by duanhuifen on 17/5/18.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageNavTitleTableViewCell.h"

@interface ZKChoseImageNavTitleTableViewCell ()


@end
@implementation ZKChoseImageNavTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
