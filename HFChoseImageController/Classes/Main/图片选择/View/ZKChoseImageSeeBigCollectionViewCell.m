//
//  ZKChoseImageSeeBigCollectionViewCell.m
//  ZK
//
//  Created by duanhuifen on 17/5/19.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageSeeBigCollectionViewCell.h"
#import "ZLPhotoTool.h"

@interface ZKChoseImageSeeBigCollectionViewCell()<UIScrollViewDelegate>
//@property (nonatomic, strong) UIView *containerView;
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZKChoseImageSeeBigCollectionViewCell
// 不建议设置太大，太大的话会导致图片加载过慢
#define kMaxImageWidth 500

- (void)awakeFromNib {
    [super awakeFromNib];
    self.setHomeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.setHomeBtn.layer.cornerRadius = 12;
    self.setHomeBtn.clipsToBounds = YES;
//    [self addSubview:self.scrollView];
//    [self.scrollView addSubview:self.containerView];
//    [self.containerView addSubview:self.imageView];
//    [self bringSubviewToFront:self.selectView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self setUpScrollView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if (self.imageTapBlock) {
        self.imageTapBlock();
    }
}
- (void )setUpScrollView
{
        self.scrollView.frame = self.bounds;
        self.scrollView.maximumZoomScale = 3.0;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.multipleTouchEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches = NO;
        
        //        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        //        [_scrollView addGestureRecognizer:singleTap];
        //
        //        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        //        doubleTap.numberOfTapsRequired = 2;
        //        [_scrollView addGestureRecognizer:doubleTap];
        //
        //        [singleTap requireGestureRecognizerToFail:doubleTap];
}

//- (UIView *)containerView
//{
//    if (!_containerView) {
//        _containerView = [[UIView alloc] init];
//    }
//    return _containerView;
//}
//
//- (UIImageView *)imageView
//{
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _imageView;
//}

- (void)setAsset:(PHAsset *)asset
{
    WEAKSELF
    _asset = asset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN(self.frame.size.width, kMaxImageWidth);
    CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
    
    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        
        weakSelf.imageView.image = image;
        [weakSelf resetSubviewSize];
    }];
}

- (void)resetSubviewSize
{
    CGRect frame;
    frame.origin = CGPointZero;
    
    UIImage *image = self.imageView.image;
    CGFloat imageScale = image.size.height/image.size.width;
    CGFloat screenScale = self.frame.size.height/self.frame.size.width;
    if (image.size.width <= self.frame.size.width && image.size.height <= self.frame.size.height) {
        frame.size.width = image.size.width;
        frame.size.height = image.size.height;
    } else {
        if (imageScale > screenScale) {
            frame.size.height = self.frame.size.height;
            frame.size.width = self.frame.size.height/imageScale;
        } else {
            frame.size.width = self.frame.size.width;
            frame.size.height = self.frame.size.width * imageScale;
        }
    }
    
    self.scrollView.zoomScale = 1;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.containerView.frame = frame;
    self.containerView.center = self.scrollView.center;
    self.imageView.frame = self.containerView.bounds;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.scrollView.frame.size.width > scrollView.contentSize.width) ? (self.scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.frame.size.height > scrollView.contentSize.height) ? (self.scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.frame = self.bounds;
//        _scrollView.maximumZoomScale = 3.0;
//        _scrollView.minimumZoomScale = 1.0;
//        _scrollView.multipleTouchEnabled = YES;
//        _scrollView.delegate = self;
//        _scrollView.scrollsToTop = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _scrollView.delaysContentTouches = NO;
//        
////        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
////        [_scrollView addGestureRecognizer:singleTap];
////        
////        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
////        doubleTap.numberOfTapsRequired = 2;
////        [_scrollView addGestureRecognizer:doubleTap];
////        
////        [singleTap requireGestureRecognizerToFail:doubleTap];
//    }
//    return _scrollView;
//}
//
//- (UIView *)containerView
//{
//    if (!_containerView) {
//        _containerView = [[UIView alloc] init];
//    }
//    return _containerView;
//}
//
//- (UIImageView *)imageView
//{
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _imageView;
//}
//
//- (void)setAsset:(PHAsset *)asset
//{
//    WEAKSELF
//    _asset = asset;
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGFloat width = MIN(self.width, kMaxImageWidth);
//    CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
//    
//    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
//        
//        weakSelf.imageView.image = image;
//        [weakSelf resetSubviewSize];
//    }];
//}
//
//- (void)resetSubviewSize
//{
//    CGRect frame;
//    frame.origin = CGPointZero;
//    
//    UIImage *image = self.imageView.image;
//    CGFloat imageScale = image.size.height/image.size.width;
//    CGFloat screenScale = self.height/self.width;
//    if (image.size.width <= self.width && image.size.height <= self.height) {
//        frame.size.width = image.size.width;
//        frame.size.height = image.size.height;
//    } else {
//        if (imageScale > screenScale) {
//            frame.size.height = self.height;
//            frame.size.width = self.height/imageScale;
//        } else {
//            frame.size.width = self.width;
//            frame.size.height = self.width * imageScale;
//        }
//    }
//    
//    self.scrollView.zoomScale = 1;
//    self.scrollView.contentSize = frame.size;
//    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
//    self.containerView.frame = frame;
//    self.containerView.center = self.scrollView.center;
//    self.imageView.frame = self.containerView.bounds;
//}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return scrollView.subviews[0];
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    CGFloat offsetX = (self.scrollView.width > scrollView.contentSize.width) ? (self.scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (self.scrollView.height > scrollView.contentSize.height) ? (self.scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
//}

@end
