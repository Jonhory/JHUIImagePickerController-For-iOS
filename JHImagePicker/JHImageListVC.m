//
//  JHImageListVC.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImageListVC.h"
#import "JHImageListCell.h"
#import "JHImagePhotosVC.h"

@interface JHImageListVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) BOOL isFirstEnter;
@property(nonatomic, assign) BOOL isEnablePhoto;

@property(nonatomic, strong) NSMutableArray<JHListItem *> *items;

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation JHImageListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstEnter && self.isEnablePhoto) {
        JHImagePhotosVC * vc = [[JHImagePhotosVC alloc]init];
        vc.item = self.items.firstObject;
        vc.maxCount = self.listMaxCount;
        vc.block = self.myBlock;
        
        [self.navigationController pushViewController:vc animated:NO];
        self.isFirstEnter = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstEnter = YES;
    self.isEnablePhoto = [JHImageTool getAuthorizePhotoLibrary];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片";
    [self setRightBtn];
    
    if (self.isEnablePhoto) {
        [self loadImageDatas];
        [self loadTableView];
    } else {
        [self showUnablePhoto];
    }
}

#pragma mark - Touch
- (void)cancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 逻辑处理
- (void)loadImageDatas {
    PHFetchOptions * smartOptions = [[PHFetchOptions alloc]init];
    PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smartOptions];
    [self convertCollection:smartAlbums];
    
}

- (void)convertCollection:(PHFetchResult <PHAssetCollection *>*)collection {
    for (PHAssetCollection *collect in collection) {
        PHFetchOptions * resultsOptions = [[PHFetchOptions alloc]init];
        resultsOptions.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"creationDate" ascending:YES]];
        
        if ([collect.localizedTitle isEqualToString:@"最近删除"] || [collect.localizedTitle isEqualToString:@"已隐藏"] || [collect.localizedTitle isEqualToString:@"Recently Deleted"] || [collect.localizedTitle isEqualToString:@"Hidden"]) {
            continue;
        }
        PHFetchResult * assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collect options:resultsOptions];
        if (assetsFetchResult.count < 1) {
            continue;
        }
        
        JHListItem * jhItem = [[JHListItem alloc]initWith:collect.localizedTitle result:assetsFetchResult];
        [self.items addObject:jhItem];
    }
    
    JHListItem * tempItem = nil;
    for (JHListItem *item in self.items) {
        if ([item.title isEqualToString:@"所有照片"]) {
            tempItem = item;
            [self.items removeObject:item];
            break;
        }
    }
    if (tempItem != nil) {
        [self.items insertObject:tempItem atIndex:0];
    }
}

#pragma mark - UITableViewDataSource && Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHImageListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    JHImagePhotosVC * vc = [[JHImagePhotosVC alloc]init];
    vc.item = self.items[indexPath.row];
    vc.maxCount = self.listMaxCount;
    vc.block = self.myBlock;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHImageListCell * cell = [JHImageListCell configWith:tableView];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JHCellHeight;
}

#pragma mark - UI渲染
- (void)loadTableView {
    [self.view addSubview:self.tableView];
}

- (void)setRightBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked)];
}

- (void)showUnablePhoto {
    UILabel * label = [[UILabel alloc]init];
    label.text = @"请在iPhone的“设置-隐私-照片”选项中，允许本应用访问你的手机相册。";
    label.frame = CGRectMake(60, 120, jhSCREEN.width - 120, 20);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    [self.view addSubview:label];
}

- (NSMutableArray<JHListItem *> *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"dealloc :%@",self);
}
@end
