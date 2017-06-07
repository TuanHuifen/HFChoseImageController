//
//  ZKChoseImageBigCollectionViewCell.h
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKChoseImageBigCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIImageView *choseImageView;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (nonatomic,copy) void(^returnChoseBtnActionBlock)(UIButton *btn);

@end
