//
//  PCH.h
//  HFChoseImageController
//
//  Created by duanhuifen on 17/6/6.
//  Copyright © 2017年 huifen. All rights reserved.
//

#ifndef PCH_h
#define PCH_h

// 屏幕尺寸
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.width

// 弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;
#pragma mark - ------------------- String -------------------
#pragma mark FormatString
#define SF(...) [NSString stringWithFormat:__VA_ARGS__]


#endif /* PCH_h */
