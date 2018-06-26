//
//  JHImagePhotosVC.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImagePhotosVC.h"
#import "JHImagePhotosCell.h"
#import "JHImagePhotosBar.h"

@interface JHImagePhotosVC ()<UICollectionViewDelegate, UICollectionViewDataSource, JHImagePhotosCellDelegate, JHImagePhotosBarDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) PHFetchResult<PHAsset *> *assets;
@property(nonatomic, strong) NSMutableArray<JHPhotoItem *> *photos;
@property(nonatomic, strong) PHCachingImageManager *imageManager;
@property(nonatomic, strong) NSMutableDictionary *imagesDict;
@property(nonatomic, strong) NSMutableArray<JHPhotoItem *> *selectedPhotos;
@property(nonatomic, assign) BOOL isShowMask;
@property(nonatomic, assign) BOOL isFirstLoad;

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, strong) PHImageRequestOptions *options;

@property(nonatomic, strong) JHImagePhotosBar *barView;

@end

@implementation JHImagePhotosVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollToBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.isFirstLoad = YES;
    self.imageManager = [[PHCachingImageManager alloc]init];
    self.imageSize = CGSizeMake(JHPhotosCellWH * [UIScreen mainScreen].scale, JHPhotosCellWH * [UIScreen mainScreen].scale);
    self.options = [[PHImageRequestOptions alloc]init];
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [self setRightBtn];
    [self handleDatasource];
    [self loadCollectionView];
}

- (void)scrollToBottom {
    if (self.assets.count <= 1 || self.isFirstLoad == NO) {
        return;
    }
    self.isFirstLoad = NO;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.assets.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    
    CGPoint point = CGPointMake(0, self.collectionView.contentOffset.y + [JHImageTool navHeight] + 44);
    [self.collectionView setContentOffset:point];
}

- (void)handleDatasource {
    self.title = self.item.title;
    self.assets = self.item.result;
    
    for (PHAsset * asset in self.assets) {
        JHPhotoItem * item = [[JHPhotoItem alloc]initWith:asset];
        [self.photos addObject:item];
    }
}

#pragma mark - Touch
- (void)cancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setRightBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked)];
}

- (void)loadCollectionView {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(JHPhotosCellWH, JHPhotosCellWH);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    
    CGRect f = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44 - [JHImageTool tabBarSafeBottomMargin]);
    self.collectionView = [[UICollectionView alloc]initWithFrame:f collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JHImagePhotosCell class] forCellWithReuseIdentifier:JHImagePhotosCellID];
    self.collectionView.contentInset = UIEdgeInsetsMake(3.5, 3.5, 3.5, 3.5);
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.barView];
}

#pragma mark - JHImagePhotosCellDelegate
- (void)photosCellClicked:(JHPhotoItem *)item btn:(UIButton *)btn {
    if (item.isSelected) {
        NSMutableArray <NSIndexPath *>* indexPs = [[NSMutableArray alloc]init];
        if ([self.selectedPhotos containsObject:item]) {
            [btn setTitle:nil forState:UIControlStateNormal];
            
            NSUInteger ind = [self.selectedPhotos indexOfObject:item];
            [self.selectedPhotos removeObjectAtIndex:ind];

            for (NSInteger i = item.index - 1; i<self.selectedPhotos.count; i++) {
                JHPhotoItem * otherItem = self.selectedPhotos[i];
                otherItem.index -= 1;
                [indexPs addObject:otherItem.indexP];
            }
        }
        item.isSelected = NO;
        btn.selected = NO;
        
        if (![self reloadDatas]) {
            [self.collectionView reloadItemsAtIndexPaths:indexPs];
        }
        [self.barView handleBarBtn:self.selectedPhotos.count >= 1 count:self.selectedPhotos.count];
        
        return;
    }
    
    if (self.selectedPhotos.count >= self.maxCount) {
        [self showMxCountAlert];
        return;
    }
    
    if (item.isSelected == NO) {
        item.isSelected = YES;
        item.isAble = YES;
        btn.selected = YES;
        NSUInteger index = self.selectedPhotos.count + 1;
        item.index = index;
        NSString * str = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        
        [btn setTitle:str forState:UIControlStateNormal];
        
        [self.selectedPhotos addObject:item];
        
        if (self.selectedPhotos.count >= self.maxCount) {
            item.isNeedAnimated = YES;
        } else {
            [btn showAnimation];
        }
    }
    if (self.selectedPhotos.count >= 1) {
        [self.barView handleBarBtn:YES count:self.selectedPhotos.count];
    }
    
    if ([self reloadDatas] == NO) {
        [self.collectionView reloadItemsAtIndexPaths:@[item.indexP]];
    }
}

- (void)showMxCountAlert {
    NSString * str = [NSString stringWithFormat:@"您最多只能%lu张照片",self.maxCount];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}


- (BOOL)reloadDatas {
    if (self.selectedPhotos.count == self.maxCount - 1 && self.isShowMask) {
        self.isShowMask = NO;
        for (JHPhotoItem * p in self.photos) {
            p.isAble = YES;
        }
        [self.collectionView reloadData];
        return YES;
    }
    
    if (self.selectedPhotos.count >= self.maxCount && !self.isShowMask) {
        self.isShowMask = YES;
        for (JHPhotoItem * photo in self.photos) {
            if (photo.isSelected == NO) {
                photo.isAble = NO;
            } else {
                photo.isAble = YES;
            }
        }
        [self.collectionView reloadData];
        return YES;
    }
    return NO;
}

#pragma mark - JHImagePhotosBarDelegate
- (void)barClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.block) {
        self.block(self.selectedPhotos);
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHImagePhotosCell * cell = (JHImagePhotosCell *)[collectionView dequeueReusableCellWithReuseIdentifier:JHImagePhotosCellID forIndexPath:indexPath];
    JHPhotoItem * item = self.photos[indexPath.row];
    item.indexP = indexPath;
    cell.item = item;
    cell.delegate = self;
    if (item.asset) {
        if (item.image == nil) {
            [self.imageManager requestImageForAsset:item.asset targetSize:self.imageSize contentMode:PHImageContentModeAspectFill options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.iv.image = result;
                item.image = result;
            }];
        } else {
            
            cell.iv.image = item.image;
        }
    }
    return cell;
}

- (NSMutableArray<JHPhotoItem *> *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc]init];
    }
    return _photos;
}

- (NSMutableArray<JHPhotoItem *> *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc]init];
    }
    return _selectedPhotos;
}

- (JHImagePhotosBar *)barView {
    if (!_barView) {
        _barView = [[JHImagePhotosBar alloc]initWithFrame:CGRectMake(0, jhSCREEN.height - 44 - [JHImageTool tabBarSafeBottomMargin], jhSCREEN.width, 44+[JHImageTool tabBarSafeBottomMargin])];
        _barView.delegate = self;
    }
    return _barView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"dealloc :%@",self);
}

@end
