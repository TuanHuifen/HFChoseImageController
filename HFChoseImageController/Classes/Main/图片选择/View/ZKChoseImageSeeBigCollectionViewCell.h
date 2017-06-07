//
//  ZKChoseImageSeeBigCollectionViewCell.h
//  ZK
//
//  Created by duanhuifen on 17/5/19.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;
@interface ZKChoseImageSeeBigCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (nonatomic, strong) PHAsset *asset;
@property (weak, nonatomic) IBOutlet UIButton *setHomeBtn;
@property (nonatomic,copy) void(^imageTapBlock)();
//是否的封面
@property (nonatomic, assign , getter=isHomePic) BOOL HomePic;


@end
