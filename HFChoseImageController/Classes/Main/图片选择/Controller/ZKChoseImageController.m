//
//  ZKChoseImageController.m
//  ZK
//
//  Created by duanhuifen on 17/5/17.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import "ZKChoseImageController.h"
#import "ZKChoseImageBigCollectionViewCell.h"
#import "ZKBottomChoseImageCollectionViewCell.h"
#import "ZKChoseImageTipController.h"
#import "ZKChoseImageNavTitleTableViewCell.h"
#import "ZKChoseImageSeeBigCollectionViewCell.h"
#import "ZKPreviewBigImageViewController.h"
#import "ZKChoseImagePhotoCollectionViewCell.h"
//#import "ZKSingleWebVCViewController.h"
#import "ZKChoseImageTipWebViewController.h"

//#import <Photos/Photos.h>
//#import <AssetsLibrary/AssetsLibrary.h>
//相册使用
#import "ZLPhotoTool.h"
#import "ZLSelectPhotoModel.h"

@interface ZKChoseImageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UICollectionView * collectionView;
//@property (nonatomic,strong) UICollectionView * bottomCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;


@property (nonatomic,strong) NSMutableArray * imageArr;
@property (weak, nonatomic) IBOutlet UIView *haveChoseView;
@property (weak, nonatomic) IBOutlet UIView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *havechoseCountLab;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistanceH;
@property (nonatomic,strong) NSMutableArray * dataArr;

@property (weak, nonatomic) IBOutlet UIButton *navTitleBtn;
@property (nonatomic,strong) UITableView * navTitleTableView;
@property (nonatomic,strong) NSMutableArray * navTitleListArr;
@property (nonatomic,strong) UICollectionView * seeBigImageCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *navCountLab;
@property (weak, nonatomic) IBOutlet UIButton *navRightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *navRightImageView;
//完成后的数组
@property (nonatomic,strong) NSMutableArray * photos;
@property (nonatomic, assign , getter=isHaveHomePic) BOOL HaveHomePic;



@end

@implementation ZKChoseImageController

static NSString * const imageCellId = @"ZKChoseImageBigCollectionViewCell";
static NSString * const imagePhotoCellId = @"ZKChoseImagePhotoCollectionViewCell";

//static NSString * const imageCellId = @"imageCellId";
//static NSString * const imagePhotoCellId = @"imagePhotoCellId";

static NSString * const bottomImageCellId = @"ZKBottomChoseImageCollectionViewCell";
//导航标题的点击
static NSString * navTitleCellId = @"ZKChoseImageNavTitleTableViewCell";
//看大图的cellid
static NSString * const seeBigImageCellId = @"ZKChoseImageSeeBigCollectionViewCell";



#define imageMargin  3
#define imageBigRowCount 2
#define imageSmallRowCount 3

#define imageBigW   (SCREEN_WIDTH - (imageBigRowCount - 1) * imageMargin)/ imageBigRowCount

#define imageSmallW   (SCREEN_WIDTH - (imageSmallRowCount + 1) * imageMargin)/ imageSmallRowCount

#define bottomImageM  5
#define bottomImageW  80

double const ScalePhotoW = 1000;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTopCollectionView];
    [self creatBottomCollectionView];
    [self getPhotoImage];
    [self creatNavTitleTableView];
    [self getAllPhotoSetList];
    [self creatSeeBigImageCollectionView];
    [self configUI];
    
    if (self.selectImageArr.count) {
        [self refreshBottomView];
    }
}

- (void)configUI{
    self.finishBtn.layer.cornerRadius = 10;
    self.finishBtn.clipsToBounds = YES;
}


- (void)configNavTitleBtn{
    [self.navTitleBtn sizeToFit];
}
- (IBAction)navTitleBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.navTitleTableView.hidden = NO;
    }else{
        self.navTitleTableView.hidden = YES;
    }
    
}

- (void)creatNavTitleTableView{
    UITableView * navTitleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:navTitleTableView];
    self.navTitleTableView = navTitleTableView;
    [self.navTitleTableView registerNib:[UINib nibWithNibName:@"ZKChoseImageNavTitleTableViewCell" bundle:nil] forCellReuseIdentifier:navTitleCellId];
    self.navTitleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navTitleTableView.delegate = self;
    self.navTitleTableView.dataSource = self;
    self.navTitleTableView.hidden = YES;
    self.navTitleTableView.showsVerticalScrollIndicator = NO;
}

//获取相册中的图片
- (void)getPhotoImage{
    
    [self.imageArr addObjectsFromArray: [[ZLPhotoTool sharePhotoTool] getAllAssetInPhotoAblumWithAscending:NO]];
}
//获取相册列表和图片
- (void)getAllPhotoSetList{
    [self.navTitleListArr addObjectsFromArray:[[ZLPhotoTool sharePhotoTool] getPhotoAblumList]];
}
//获取指定相册中的图片
- (void)getAppointPhotoImageWith:(ZLPhotoAblumList *)listModel{
    [self.imageArr removeAllObjects];
    [self.imageArr addObjectsFromArray:[[ZLPhotoTool sharePhotoTool] getAssetsInAssetCollection:listModel.assetCollection ascending:NO]];
    [self.collectionView reloadData];
}

//通过asset获取图片
- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    size.width  *= 1.5;
    size.height *= 1.5;
    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}
#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//上面的选择collection
- (void)creatTopCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 140) collectionViewLayout:layout];
    // 设置列的最小间距
    layout.minimumInteritemSpacing = imageMargin;
    // 设置最小行间距
    layout.minimumLineSpacing = imageMargin;
    // 设置布局的内边距
//    layout.sectionInset = UIEdgeInsetsMake(imageMargin, imageMargin, imageMargin, imageMargin);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZKChoseImageBigCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imageCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZKChoseImagePhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imagePhotoCellId];
    [self.view bringSubviewToFront:self.haveChoseView];
//    [self hideBottomView];

}
//查看大图的collection
- (void)creatSeeBigImageCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.seeBigImageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 140) collectionViewLayout:layout];
    // 设置列的最小间距
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    layout.itemSize = self.seeBigImageCollectionView.bounds.size;
    // 设置布局的内边距
    //    layout.sectionInset = UIEdgeInsetsMake(imageMargin, imageMargin, imageMargin, imageMargin);
    self.seeBigImageCollectionView.backgroundColor = [UIColor blackColor];
    self.seeBigImageCollectionView.showsHorizontalScrollIndicator = NO;
    self.seeBigImageCollectionView.delegate = self;
    self.seeBigImageCollectionView.dataSource = self;
    self.seeBigImageCollectionView.pagingEnabled = YES;
    [self.view addSubview:self.seeBigImageCollectionView];
    [self.seeBigImageCollectionView registerNib:[UINib nibWithNibName:@"ZKChoseImageSeeBigCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:seeBigImageCellId];
    [self.seeBigImageCollectionView registerNib:[UINib nibWithNibName:@"ZKChoseImageSeeBigCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:seeBigImageCellId];
    self.seeBigImageCollectionView.hidden = YES;
    self.navCountLab.hidden = YES;

}
- (void)showBottomView{
    self.bottomDistanceH.constant = 0;
}

- (void)hideBottomView{
    self.bottomDistanceH.constant = -140;
}
//下面选中的小图
- (void)creatBottomCollectionView{
//    暂时不要删掉，留着找原因duanhuifen
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
////    self.bottomCollectionView = [[UICollectionView alloc]initWithFrame:self.bottomImageView.bounds collectionViewLayout:layout];
//    self.bottomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, self.haveChoseView.width, 80) collectionViewLayout:layout];
//    self.bottomCollectionView.showsHorizontalScrollIndicator = NO;
//    // 设置列的最小间距
////    layout.minimumInteritemSpacing = bottomImageM;
//    // 设置最小行间距
//    layout.minimumLineSpacing = bottomImageM;
    // 设置布局的内边距
    //    layout.sectionInset = UIEdgeInsetsMake(imageMargin, imageMargin, imageMargin, imageMargin);
    
    self.bottomCollectionView.backgroundColor = [UIColor clearColor];
    self.bottomCollectionView.showsHorizontalScrollIndicator = NO;
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
//    [self.bottomImageView addSubview:self.bottomCollectionView];
//    [self.haveChoseView addSubview:self.bottomCollectionView];
    
    [self.bottomCollectionView registerNib:[UINib nibWithNibName:@"ZKBottomChoseImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bottomImageCellId];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.imageArr.count + 1;
    }else if (collectionView == self.seeBigImageCollectionView){
        return self.imageArr.count;
    }else{
        return self.selectImageArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    if (collectionView == self.collectionView) {
        ZKChoseImageBigCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
        ZKChoseImagePhotoCollectionViewCell * photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:imagePhotoCellId forIndexPath:indexPath];
        cell.choseBtn.tag = indexPath.row;
        cell.choseBtn.selected = NO;
        cell.choseImageView.image = [UIImage imageNamed:@"全新"];
        if (self.imageArr.count) {
            if (indexPath.item == 0) {
                return photoCell;
                
            }else{
                cell.choseBtn.tag = indexPath.row;
                PHAsset *asset = self.imageArr[indexPath.item - 1];

                [self getImageWithAsset:asset completion:^(UIImage *image, NSDictionary *info) {
                    cell.picImageView.image = image;
                    cell.choseImageView.hidden = NO;
                    cell.choseBtn.hidden = NO;
                    
                    for (ZLSelectPhotoModel *model in weakSelf.selectImageArr) {
                        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                            cell.choseBtn.selected = YES;
                            cell.choseImageView.image = [UIImage imageNamed:@"已选择"];
                            break;
                        }
                    }

                    __weak typeof(cell)weakCell = cell;
                    cell.returnChoseBtnActionBlock = ^(UIButton *btn){
                        if (!btn.selected) {
                            if (self.selectImageArr.count == self.maxCount) {
//                                [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
                                return ;
                            }
                            ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
                            model.asset = asset;
                            model.localIdentifier = asset.localIdentifier;
                            [weakSelf.selectImageArr addObject:model];
                        } else {
                            for (ZLSelectPhotoModel *model in self.selectImageArr) {
                                if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                                    [self.selectImageArr removeObject:model];
                                    break;
                                }
                            }
                        }
                        
                        btn.selected = !btn.selected;
                        if (weakSelf.selectImageArr.count) {
                            [weakSelf showBottomView];
                        }
                        if (btn.selected) {
                            weakCell.choseImageView.image = [UIImage imageNamed:@"已选择"];
                        }else{
                            weakCell.choseImageView.image = [UIImage imageNamed:@"全新"];
                            
                        }
                        [weakSelf.collectionView reloadData];
                        [weakSelf refreshBottomView];
                    };
                }];
            }
        }
        return cell;
    }else if (collectionView == self.seeBigImageCollectionView){
        self.HaveHomePic = NO;
        PHAsset *asset = self.imageArr[indexPath.item];
        ZKChoseImageSeeBigCollectionViewCell * bigCell = [collectionView dequeueReusableCellWithReuseIdentifier:seeBigImageCellId forIndexPath:indexPath];
        if (self.isShowSettingHomeBtn) {
            bigCell.setHomeBtn.hidden = NO;
        }else{
            bigCell.setHomeBtn.hidden = YES;
        }
        bigCell.choseBtn.selected = NO;
        bigCell.HomePic = NO;
        bigCell.selectImageView.image = [UIImage imageNamed:@"全新"];
        bigCell.asset = asset;
        bigCell.choseBtn.tag = indexPath.item;
        bigCell.setHomeBtn.tag = indexPath.item + 1000;
        
        for (ZLSelectPhotoModel *model in weakSelf.selectImageArr) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                bigCell.choseBtn.selected = YES;
                bigCell.selectImageView.image = [UIImage imageNamed:@"已选择"];
                break;
            }
        }
        
        [bigCell.choseBtn addTarget:self action:@selector(choseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bigCell.setHomeBtn addTarget:self action:@selector(setImageWithHomePic:) forControlEvents:UIControlEventTouchUpInside];
        
        bigCell.imageTapBlock = ^(){
            weakSelf.seeBigImageCollectionView.hidden = YES;
            weakSelf.navTitleBtn.hidden = NO;
            weakSelf.navCountLab.hidden = YES;
            weakSelf.navRightBtn.hidden = NO;
            weakSelf.navRightImageView.hidden = NO;
            [weakSelf.collectionView reloadData];
        };
        return bigCell;
    }else{
        ZKBottomChoseImageCollectionViewCell * bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomImageCellId forIndexPath:indexPath];
         ZLSelectPhotoModel * model = self.selectImageArr[indexPath.item];
        [self getImageWithAsset:model.asset completion:^(UIImage *image, NSDictionary *info) {
            bottomCell.picImageView.image = image;
        }];
        bottomCell.returnDeleteBtnActionBlock = ^(){
            if (self.seeBigImageCollectionView.hidden) {
                [weakSelf.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (model.asset == weakSelf.imageArr[idx]) {
                        NSIndexPath * index = [NSIndexPath indexPathForItem:(idx+1) inSection:0];
                        ZKChoseImageBigCollectionViewCell * cell = (ZKChoseImageBigCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:index];
                        cell.choseBtn.selected = NO;
                        cell.choseImageView.image = [UIImage imageNamed:@"全新"];
                    }
                    
                }];
                [weakSelf.selectImageArr removeObjectAtIndex:indexPath.item];
                [weakSelf refreshBottomView];
//                weakSelf.havechoseCountLab.text = SF(@"已添加%lu张图片",(unsigned long)self.selectImageArr.count);
//                [weakSelf.bottomCollectionView reloadData];
                [weakSelf.collectionView reloadData];
            }else{
                [weakSelf.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (model.asset == weakSelf.imageArr[idx]) {
                        NSIndexPath * index = [NSIndexPath indexPathForItem:(idx+1) inSection:0];
                        ZKChoseImageSeeBigCollectionViewCell * cell = (ZKChoseImageSeeBigCollectionViewCell *)[weakSelf.seeBigImageCollectionView cellForItemAtIndexPath:index];
                        cell.choseBtn.selected = NO;
                        cell.selectImageView.image = [UIImage imageNamed:@"全新"];
                    }
                    
                }];
                [weakSelf.selectImageArr removeObjectAtIndex:indexPath.item];
                [weakSelf refreshBottomView];
//                weakSelf.havechoseCountLab.text = SF(@"已添加%lu张图片",(unsigned long)self.selectImageArr.count);
//                [weakSelf.bottomCollectionView reloadData];
                [weakSelf.seeBigImageCollectionView reloadData];
            }
            
            
        };
        return bottomCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        
        if (indexPath.item == 0 || indexPath.item == 1) {
            
            return CGSizeMake(imageBigW, imageBigW);
        }else{
            return CGSizeMake(imageSmallW, imageSmallW);
        }
    }else if (collectionView == self.seeBigImageCollectionView){
        return CGSizeMake(self.seeBigImageCollectionView.frame.size.width, self.seeBigImageCollectionView.frame.size.height);
    }else{
        return CGSizeMake(bottomImageW, bottomImageW);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionView) {
        
        return UIEdgeInsetsMake(imageMargin, 0, imageMargin, 0);
    }else if (collectionView == self.seeBigImageCollectionView){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else{
//        return UIEdgeInsetsMake(bottomImageM, bottomImageM, 0, bottomImageM);
        return UIEdgeInsetsMake(0, 0, 0, bottomImageM);

    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    if (collectionView == self.collectionView) {
        if (indexPath.item == 0) {
            if (self.selectImageArr.count == self.maxCount) {
//                [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
                return ;
            }
            [self openCamera];
        }else{
            self.seeBigImageCollectionView.hidden = NO;
            self.navTitleBtn.hidden = YES;
            self.navCountLab.hidden = NO;
            self.navRightBtn.hidden = YES;
            self.navRightImageView.hidden = YES;
            self.navCountLab.text = [NSString stringWithFormat:@"1/%ld", self.imageArr.count];
            [self turnSeeBigImageCollectionWithIndex:(indexPath.item - 1)];
            
        }
    }else if (collectionView == self.seeBigImageCollectionView){
        self.seeBigImageCollectionView.hidden = YES;
        self.navTitleBtn.hidden = NO;
        self.navCountLab.hidden = YES;
        self.navRightBtn.hidden = NO;
        self.navRightImageView.hidden = NO;
        [self.collectionView reloadData];
    }else{
        ZKPreviewBigImageViewController * previewImageVC = [[ZKPreviewBigImageViewController alloc]init];
        if (self.isShowSettingHomeBtn) {
            previewImageVC.showSettingHomeBtn = YES;
        }else{
            previewImageVC.showSettingHomeBtn = NO;
        }
        previewImageVC.selectArr = self.selectImageArr;
        previewImageVC.currentIndex = indexPath.item;
        previewImageVC.refreshSelectArrBlock = ^(NSMutableArray * selectArr){
//            [weakSelf.selectImageArr removeAllObjects];
//            [weakSelf.selectImageArr addObjectsFromArray:selectArr];
            weakSelf.selectImageArr = selectArr;
            [weakSelf refreshBottomView];
            if (self.seeBigImageCollectionView.hidden) {
                [weakSelf.collectionView reloadData];
            }else{
                [weakSelf.seeBigImageCollectionView reloadData];
            }
                
        };
        [self.navigationController pushViewController:previewImageVC animated:YES];
    }
}

#pragma mark -- 导航标题按钮的点击的tableview所有
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.navTitleListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKChoseImageNavTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:navTitleCellId];
    ZLPhotoAblumList * listModel = self.navTitleListArr[indexPath.row];
    cell.nameLab.text = listModel.title;
    cell.countLab.text = SF(@"(%ld张)",(long)listModel.count);
    [self getImageWithAsset:listModel.headImageAsset completion:^(UIImage *image, NSDictionary *info) {
        cell.picImageView.image = image;
    }];
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ZLPhotoAblumList * listModel = self.navTitleListArr[indexPath.row];
    [self getAppointPhotoImageWith:listModel];
    self.navTitleTableView.hidden = YES;
    [self.navTitleBtn setTitle:listModel.title forState:UIControlStateNormal];
    self.navTitleBtn.selected = NO;
}



- (IBAction)backBtnAction:(UIButton *)sender {
    [self.selectImageArr removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tipBtnAction:(UIButton *)sender {
//    ZKChoseImageTipWebViewController * tipWebVC = [[ZKChoseImageTipWebViewController alloc]init];
//    
//    [self.navigationController pushViewController:tipWebVC animated:YES];
    
//    下面这个是本地加载的勿删
    ZKChoseImageTipController * tipVC = [[ZKChoseImageTipController alloc]init];
    [self presentViewController:tipVC animated:YES completion:nil];
}

- (IBAction)finishBtnAction:(UIButton *)sender {
//    self.bottomDistanceH.constant = - 140;
    if (self.selectImageArr.count) {
        [self requestSelPhotos];
    }else{
        [self.photos removeAllObjects];
        [self.selectImageArr removeAllObjects];
        if (self.returnSelectImageArrBlock) {
            self.returnSelectImageArrBlock(self.photos,self.selectImageArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//已经选中的图片
- (void)requestSelPhotos
{
    [self.photos removeAllObjects];
    CGFloat scale = [UIScreen mainScreen].scale;
    WEAKSELF
    for (int i = 0; i < self.selectImageArr.count; i++) {
        ZLSelectPhotoModel *model = self.selectImageArr[i];
        [[ZLPhotoTool sharePhotoTool] requestImageForAsset:model.asset scale:scale resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image) {
            if (image){
                [weakSelf.photos addObject:[self scaleImage:image]];
            }
            if (i == weakSelf.selectImageArr.count - 1) {
                if (weakSelf.returnSelectImageArrBlock) {
                    weakSelf.returnSelectImageArrBlock(weakSelf.photos,weakSelf.selectImageArr);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}


//打开相机
- (void)openCamera{
    UIImagePickerController * pickVC = [[UIImagePickerController alloc]init];
    pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    WEAKSELF;
    [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [[ZLPhotoTool sharePhotoTool] saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (suc) {
                        ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
                        model.asset = asset;
                        model.localIdentifier = asset.localIdentifier;
                        [weakSelf.selectImageArr addObject:model];
                        [weakSelf refreshBottomView];
                        [weakSelf.collectionView reloadData];

                    } else {
                        NSLog(@"保存相册失败");
                    }
                });
            }];
    }];

}

//查看大图右侧选择按钮的点击
- (void)choseBtnAction:(UIButton *)btn{
     PHAsset *asset = self.imageArr[btn.tag];
    if (!btn.selected) {
        if (self.selectImageArr.count == self.maxCount) {
//            [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
            return ;
        }

        ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
        model.asset = asset;
        model.localIdentifier = asset.localIdentifier;
        [self.selectImageArr addObject:model];
    } else {
        for (ZLSelectPhotoModel *model in self.selectImageArr) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [self.selectImageArr removeObject:model];
                break;
            }
        }
    }
    
    btn.selected = !btn.selected;
    if (self.selectImageArr.count) {
        [self showBottomView];
    }
    NSIndexPath * index = [NSIndexPath indexPathForItem:(btn.tag) inSection:0];
    ZKChoseImageSeeBigCollectionViewCell * cell = (ZKChoseImageSeeBigCollectionViewCell *)[self.seeBigImageCollectionView cellForItemAtIndexPath:index];
    if (btn.selected) {
        cell.selectImageView.image = [UIImage imageNamed:@"已选择"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"全新"];

    }
    [self refreshBottomView];
//    [self.seeBigImageCollectionView reloadData];

}
//查看大图设为封面按钮点击
- (void)setImageWithHomePic:(UIButton *)btn{
    if (self.selectImageArr.count == self.maxCount) {
//        [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
        return ;
    }
    [self judgeWetherContainObjectWithObject:(btn.tag - 1000)];
}

//    判断选中里有没有这个图片，如果有，是不是封面，不是设置封面，，是，提示不用再次设置
//    如果没有这个图片，就添加并设置封面
- (void)judgeWetherContainObjectWithObject:(NSInteger)tag{
    PHAsset *asset = self.imageArr[tag];
    // 检查已选的图片是否含有当前照片
    __block BOOL isHaveSelected = NO;
    
    [self.selectImageArr enumerateObjectsUsingBlock:^(ZLSelectPhotoModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
            if ([obj.localIdentifier isEqualToString:asset.localIdentifier]) {
                 isHaveSelected = YES;
                if (i == 0) {
//                    cell.HomePic = YES;
//                    [self showSuccessTip:@"已经是封面"];
                }else{
                    [self.selectImageArr removeObjectAtIndex:i];
                    [self.selectImageArr insertObject:obj atIndex:0];
                    [self refreshBottomView];
                }

            }
    }];
    // 没有这个图片
    if (!isHaveSelected) {
        //        选中并且设置为封面
        NSIndexPath * index = [NSIndexPath indexPathForItem:tag inSection:0];
        ZKChoseImageSeeBigCollectionViewCell * cell = (ZKChoseImageSeeBigCollectionViewCell *)[self.seeBigImageCollectionView cellForItemAtIndexPath:index];
        
        if (!cell.choseBtn.selected) {
            //            if (self.selectImageArr.count == self.maxCount) {
            //                [self showSuccessTip:SF(@"最多选%ld张",(long)self.maxCount)];
            //                return ;
            //            }
            ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
            model.asset = asset;
            model.localIdentifier = asset.localIdentifier;
            //            [self.selectImageArr addObject:model ];
            [self.selectImageArr insertObject:model atIndex:0];
        } else {
            for (ZLSelectPhotoModel *model in self.selectImageArr) {
                if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                    [self.selectImageArr removeObject:model];
                    break;
                }
            }
        }
        
        cell.choseBtn.selected = !cell.choseBtn.selected;
        if (cell.choseBtn.selected) {
            cell.selectImageView.image = [UIImage imageNamed:@"已选择"];
        }else{
            cell.selectImageView.image = [UIImage imageNamed:@"全新"];
            
        }
        [self refreshBottomView];
    }
}
/**
 * @brief 这里对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(ScalePhotoW, ScalePhotoW * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//更新底部的选中图片和数字
- (void)refreshBottomView{
    self.havechoseCountLab.text = SF(@"已添加%lu张图片",(unsigned long)self.selectImageArr.count);
    
    [self.bottomCollectionView reloadData];
}
//跳转到指定的看大图模式
- (void)turnSeeBigImageCollectionWithIndex:(NSInteger)index{
    [self.seeBigImageCollectionView setContentOffset:CGPointMake(self.seeBigImageCollectionView.frame.size.width * index, 0) animated:NO];
      self.navCountLab.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, self.imageArr.count];
    [self.seeBigImageCollectionView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.seeBigImageCollectionView) {
        //改变导航标题
        CGFloat page = scrollView.contentOffset.x/(self.seeBigImageCollectionView.frame.size.width);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        NSInteger currentPage = str.integerValue + 1;
        self.navCountLab.text = [NSString stringWithFormat:@"%ld/%ld", currentPage, self.imageArr.count];
    }

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

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)navTitleListArr
{
    if (!_navTitleListArr) {
        _navTitleListArr = [NSMutableArray array];
    }
    return _navTitleListArr;
}
- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
