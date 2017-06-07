//
//  ZKChoseImageTipController.m
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageTipController.h"

@interface ZKChoseImageTipController ()
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myScrollviewH;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (weak, nonatomic) IBOutlet UIView *firstImageView;
@property (weak, nonatomic) IBOutlet UIView *secondImageView;
@property (weak, nonatomic) IBOutlet UIView *thirdImageView;

@end

@implementation ZKChoseImageTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myScrollview.showsVerticalScrollIndicator = NO;
    [self setUpAllImageViewWithView:self.firstImageView];
    [self setUpAllImageViewWithView:self.secondImageView];
    [self setUpAllImageViewWithView:self.thirdImageView];
    self.myScrollviewH.constant = CGRectGetMaxY(self.thirdView.frame);
}

- (void)setUpAllImageViewWithView:(UIView *)view{
    for (UIImageView * imageView in view.subviews) {
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
