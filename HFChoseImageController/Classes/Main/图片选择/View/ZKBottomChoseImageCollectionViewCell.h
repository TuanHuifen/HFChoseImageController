//
//  ZKBottomChoseImageCollectionViewCell.h
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKBottomChoseImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic,copy) void(^returnDeleteBtnActionBlock)();
@end
