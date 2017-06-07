//
//  ZKChoseImageController.h
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

//#import "ZKBaseViewController.h"
#import "ZLSelectPhotoModel.h"
#import <UIKit/UIKit.h>


@interface ZKChoseImageController : UIViewController
//最多图片个数
@property (nonatomic,assign) NSInteger maxCount;
//已选中的图片数组
@property (nonatomic,strong) NSMutableArray * selectImageArr;
//是否显示设为封面 (默认是不显示的)
@property (nonatomic, assign , getter=isShowSettingHomeBtn) BOOL showSettingHomeBtn;
//返回选中的图片数组和数组模型
@property (nonatomic,copy) void(^returnSelectImageArrBlock)(NSMutableArray<UIImage *> * selectImageArr,NSMutableArray<ZLSelectPhotoModel *> * selectImageModelArr);
@end
