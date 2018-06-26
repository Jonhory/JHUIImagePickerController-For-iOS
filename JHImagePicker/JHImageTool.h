//
//  JHImageTool.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define jhSCREEN [UIScreen mainScreen].bounds.size
#define jhPHAuthorized @"jhPHAuthorized"

@interface JHListItem : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) PHFetchResult *result;

- (instancetype)initWith:(NSString *)title result:(PHFetchResult *)result;

@end

@interface JHPhotoItem : NSObject

@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL isAble;
@property(nonatomic, assign) BOOL isNeedAnimated;

@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) NSIndexPath *indexP;
@property(nonatomic, strong) UIImage *image;

- (instancetype)initWith:(PHAsset *)asset;
- (void)originalImage:(void(^)(UIImage*original))finished;

@end

typedef void(^JHImagePhotosCompletion)(NSMutableArray<JHPhotoItem*>* images);

@interface JHImageTool : NSObject

+ (void)getOriginalImage:(PHAsset*)asset finished:(void(^)(UIImage* original))finished;
+ (BOOL)getAuthorizePhotoLibrary;
+ (void)presentPhotoVC:(UIViewController *)ovc maxCount:(NSUInteger)maxCount completeHandler:(JHImagePhotosCompletion)completeHandler;


/// 44 / 20
+ (CGFloat)statusBarHeight;
/// 44
+ (CGFloat)navigationBarHeight;
/// 88 / 64
+ (CGFloat)navHeight;
/// 49+34 / 49
+ (CGFloat)tabBarHeight;
/// 34 / 0
+ (CGFloat)tabBarSafeBottomMargin;

@end
