//
//  JHImageTool.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImageTool.h"
#import "JHImageListVC.h"

@implementation JHListItem

- (instancetype)initWith:(NSString *)title result:(PHFetchResult *)result {
    if (self = [super init]) {
        self.title = title;
        self.result = result;
    }
    return self;
}

@end

@implementation JHPhotoItem

- (instancetype)initWith:(PHAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;
        self.isAble = YES;
        self.index = 1;
    }
    return self;
}

- (void)originalImage:(void(^)(UIImage*original))finished {
    if (self.asset) {
        [JHImageTool getOriginalImage:self.asset finished:^(UIImage *original) {
            finished(original);
        }];
    }
}

@end

@implementation JHImageTool

+ (void)getOriginalImage:(PHAsset*)asset finished:(void(^)(UIImage* original))finished {
    PHCachingImageManager * m = [[PHCachingImageManager alloc]init];
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc]init];
    options.synchronous = YES;
    
    [m requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            finished(result);
        }
    }];
}

+ (BOOL)getAuthorizePhotoLibrary {
    switch (PHPhotoLibrary.authorizationStatus) {
        case PHAuthorizationStatusAuthorized:
            return YES;
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAuthorizePhotoLibrary];
                });
            }];
        }
        default:
            return NO;
    }
    return NO;
}

+ (void)presentPhotoVC:(UIViewController *)ovc maxCount:(NSUInteger)maxCount completeHandler:(JHImagePhotosCompletion)completeHandler {
    JHImageListVC * vc = [[JHImageListVC alloc]init];
    vc.listMaxCount = maxCount;
    vc.myBlock = completeHandler;
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [ovc presentViewController:nav animated:YES completion:nil];
}

+ (BOOL)isiPhoneX {
    if (jhSCREEN.width == 375.0 && jhSCREEN.height == 812.0) {
        return YES;
    }
    return NO;
}

+ (CGFloat)statusBarHeight {
    return [self isiPhoneX] ? 44.0 : 20.0;
}

+ (CGFloat)navigationBarHeight {
    return 44.0;
}

+ (CGFloat)navHeight {
    return [self isiPhoneX] ? 88.0 : 64.0;
}

+ (CGFloat)tabBarHeight {
    return [self isiPhoneX] ? (49.0+34.0) : 49.0;
}

+ (CGFloat)tabBarSafeBottomMargin {
    return [self isiPhoneX] ? 34.0 : 0.0;
}

@end


