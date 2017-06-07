//
//  ZKChoseImageBigCollectionViewCell.m
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageBigCollectionViewCell.h"

@implementation ZKChoseImageBigCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
}
- (IBAction)choseBtnAction:(UIButton *)sender {
    if (_returnChoseBtnActionBlock) {
        self.returnChoseBtnActionBlock(sender);
    }
}

@end
