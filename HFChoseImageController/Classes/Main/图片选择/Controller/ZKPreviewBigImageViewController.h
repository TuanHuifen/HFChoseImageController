//
//  ZKPreviewBigImageViewController.h
//  ZK
//
//  Created by duanhuifen on 17/5/22.
//  Copyright © 2017年 Risenb. All rights reserved.
//

//#import "ZKBaseViewController.h"
#import <UIKit/UIKit.h>

@interface ZKPreviewBigImageViewController : UIViewController
@property (nonatomic,strong) NSMutableArray * selectArr;
@property (nonatomic,assign) NSInteger currentIndex; //当前是第几个
@property (nonatomic,copy) void(^refreshSelectArrBlock)(NSMutableArray * selectArr);
//是否显示设为封面
@property (nonatomic, assign , getter=isShowSettingHomeBtn) BOOL showSettingHomeBtn;
@end
