//
//  ZKBottomChoseImageCollectionViewCell.m
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKBottomChoseImageCollectionViewCell.h"

@implementation ZKBottomChoseImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.returnDeleteBtnActionBlock) {
        self.returnDeleteBtnActionBlock();
    }
}

@end
