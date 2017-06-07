//
//  ZKPreviewBigImageViewController.m
//  ZK
//
//  Created by duanhuifen on 17/5/22.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKPreviewBigImageViewController.h"
#import "ZKPreviewBigImageCollectionViewCell.h"
#import "ZLSelectPhotoModel.h"

@interface ZKPreviewBigImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *setHomeBtn;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,assign) NSInteger currentPage; //第几页
@end

@implementation ZKPreviewBigImageViewController
//看大图的cellid
static NSString * const BigImageCellId = @"ZKPreviewBigImageCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTopCollectionView];
    [self configCountLab];
    if (self.isShowSettingHomeBtn) {
        self.setHomeBtn.hidden = NO;
    }else{
        self.setHomeBtn.hidden = YES;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configCountLab{
    self.countLab.text = SF(@"%ld/%lu",(long)self.currentIndex + 1,(unsigned long)self.selectArr.count);
    self.currentPage = self.currentIndex;
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * self.collectionView.frame.size.width , 0) animated:YES];
    [self.collectionView reloadData];
}
//上面的选择collection
- (void)creatTopCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45) collectionViewLayout:layout];
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    // 设置布局的内边距
    //    layout.sectionInset = UIEdgeInsetsMake(imageMargin, imageMargin, imageMargin, imageMargin);
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZKPreviewBigImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:BigImageCellId];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZKPreviewBigImageCollectionViewCell * cell = [collectionView    dequeueReusableCellWithReuseIdentifier:BigImageCellId forIndexPath:indexPath];
    ZLSelectPhotoModel * model = self.selectArr[indexPath.item];
    cell.asset = model.asset;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
}



- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.refreshSelectArrBlock) {
        self.refreshSelectArrBlock(self.selectArr);
    }
}
- (IBAction)deleteAction:(UIButton *)sender {
    if (self.selectArr.count) {
        [self.selectArr removeObjectAtIndex:self.currentPage];
        [self refreshCountLab];
    }else{
//        [self showSuccessTip:@"暂无选中图片"];
    }
}
- (IBAction)setHomeImageAction:(UIButton *)sender {
    if (self.selectArr.count) {
        ZLSelectPhotoModel * model = self.selectArr[self.currentPage];
        [self.selectArr removeObjectAtIndex:self.currentPage];
        [self.selectArr insertObject:model atIndex:0];
    }else{
//        [self showSuccessTip:@"暂无选中图片"];
    }
    [self.collectionView reloadData];

//    [self judgeWetherContainObjectWithObject:(btn.tag - 1000)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //改变导航标题
    CGFloat page = scrollView.contentOffset.x/(self.collectionView.frame.size.width);
    NSString *str = [NSString stringWithFormat:@"%.0f", page];
    self.currentPage = str.integerValue;
    self.countLab.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPage + 1, self.selectArr.count];
}

- (void)refreshCountLab{
    if (self.selectArr.count == 0) {
        self.countLab.text = @"0/0";
//        [self showSuccessTip:@"暂无选中图片"];
    }else{
        self.countLab.text = SF(@"%ld/%lu",self.currentPage + 1,(unsigned long)self.selectArr.count);
    }
    [self.collectionView reloadData];
}

//查看大图设为封面按钮点击
- (void)setImageWithHomePic:(UIButton *)btn{
   }

//    判断选中里有没有这个图片，如果有，是不是封面，不是设置封面，，是，提示不用再次设置
//    如果没有这个图片，就添加并设置封面
- (void)judgeWetherContainObjectWithObject:(NSInteger)tag{
//    PHAsset *asset = self.imageArr[tag];
//    // 检查已选的图片是否含有当前照片
//    __block BOOL isHaveSelected = NO;
//    
//    [self.selectImageArr enumerateObjectsUsingBlock:^(ZLSelectPhotoModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
//        if ([obj.localIdentifier isEqualToString:asset.localIdentifier]) {
//            isHaveSelected = YES;
//            if (i == 0) {
//                //                    cell.HomePic = YES;
//                [self showSuccessTip:@"已经是封面"];
//            }else{
//                [self.selectImageArr removeObjectAtIndex:i];
//                [self.selectImageArr insertObject:obj atIndex:0];
//                [self refreshBottomView];
//            }
//            
//        }
//    }];
//    // 没有这个图片
//    if (!isHaveSelected) {
//        //        选中并且设置为封面
//        NSIndexPath * index = [NSIndexPath indexPathForItem:tag inSection:0];
//        ZKChoseImageSeeBigCollectionViewCell * cell = (ZKChoseImageSeeBigCollectionViewCell *)[self.seeBigImageCollectionView cellForItemAtIndexPath:index];
//        
//        if (!cell.choseBtn.selected) {
//            //            if (self.selectImageArr.count == self.maxCount) {
//            //                [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
//            //                return ;
//            //            }
//            ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
//            model.asset = asset;
//            model.localIdentifier = asset.localIdentifier;
//            //            [self.selectImageArr addObject:model ];
//            [self.selectImageArr insertObject:model atIndex:0];
//        } else {
//            for (ZLSelectPhotoModel *model in self.selectImageArr) {
//                if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
//                    [self.selectImageArr removeObject:model];
//                    break;
//                }
//            }
//        }
//        
//        cell.choseBtn.selected = !cell.choseBtn.selected;
//        if (cell.choseBtn.selected) {
//            cell.selectImageView.image = [UIImage imageNamed:@"选择 选中"];
//        }else{
//            cell.selectImageView.image = [UIImage imageNamed:@"选择 未选中"];
//            
//        }
//        [self refreshBottomView];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
