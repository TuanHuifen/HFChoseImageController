//
//  ViewController.m
//  HFChoseImageController
//
//  Created by duanhuifen on 17/6/6.
//  Copyright © 2017年 huifen. All rights reserved.
//

#import "ViewController.h"
#import "ZKChoseImageController.h"
#import "ZKChoseImagePhotoCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myLayout;
@property (nonatomic,strong) NSMutableArray * imageArr;
@property (nonatomic,strong) NSMutableArray * selectImageArr;
@end

@implementation ViewController
static NSString * const cellid = @"ZKChoseImagePhotoCollectionViewCell";
static int count = 3;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionViewUI];
    
}
- (void)configCollectionViewUI{
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"ZKChoseImagePhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellid];
//    self.myLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 )/count, (SCREEN_WIDTH - 20 )/count);
    self.myCollectionView.backgroundColor = [UIColor yellowColor];
    
    
}

- (IBAction)enterAction:(UIButton *)sender {
    WEAKSELF
    ZKChoseImageController * choseVC = [[ZKChoseImageController alloc]init];
    choseVC.showSettingHomeBtn = YES;
    choseVC.maxCount = 9;
    choseVC.selectImageArr = [self.selectImageArr mutableCopy];
    choseVC.returnSelectImageArrBlock = ^(NSMutableArray<UIImage *> * selectImageArr,NSMutableArray<ZLSelectPhotoModel *> * selectImageModelArr){
        weakSelf.imageArr = selectImageArr;
        weakSelf.selectImageArr = selectImageModelArr;
        [weakSelf.myCollectionView reloadData];
    };
    [self.navigationController pushViewController:choseVC animated:YES];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZKChoseImagePhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.picView.image = self.imageArr[indexPath.item];
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 20 * 2 - 10 * 2)/count, (SCREEN_WIDTH - 20 * 2 -10 * 2)/count);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

        return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)selectImageArr
{
    if (!_selectImageArr) {
        _selectImageArr = [NSMutableArray array];
    }
    return _selectImageArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
