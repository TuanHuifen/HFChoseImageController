//
//  ZKChoseImageTipWebViewController.m
//  ZK
//
//  Created by duanhuifen on 17/6/6.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageTipWebViewController.h"

@interface ZKChoseImageTipWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ZKChoseImageTipWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSString * url = @"http://www.izhenku.com/weiweb/Iwanttosell/choosetheskills.html";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.view.backgroundColor = [UIColor blackColor];
    self.webView.backgroundColor = [UIColor blackColor];
//    [self.webView setOpaque:NO];
//    [[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (IBAction)closeBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
