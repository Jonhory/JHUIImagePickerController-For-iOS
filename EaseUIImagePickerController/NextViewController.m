//
//  NextViewController.m
//  EaseUIImagePickerController
//
//  Created by jonhory on 16/6/13.
//
//

#import "NextViewController.h"

#import "JHImagePickerController.h"
#import "JHImageTool.h"

#define SCREEN [UIScreen mainScreen].bounds.size

@interface NextViewController ()<JHImagePickerControllerDelegate>
{
    UIImageView * _imageView;
    JHImagePickerController * _imagePickerController;
}
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sdlfalksdfklasdj");
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化方法一
    //_imagePickerController = [[JHImagePickerController alloc]init];
    //设置是否缓存 默认为NO
    //_imagePickerController.isCaches = YES;
    //设置缓存标识符
    //_imagePickerController.identifier = @"abc";
    
    //初始化方法二
    _imagePickerController = [[JHImagePickerController alloc]initWithIsCaches:YES andIdentifier:@"abc"];
    
    _imagePickerController.delegate = self;
    //若不需要裁剪图片，则设置该属性。
//    _imagePickerController.isEditImage = NO;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, SCREEN.width - 20, SCREEN.height - 280)];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    [self creatBtnWithTitle:@"选取图片" centerY:SCREEN.height - 50 action:@selector(selectImageClicked)];
    
    [self creatBtnWithTitle:@"读取图片" centerY:SCREEN.height - 100 action:@selector(readImageClicked)];
    
    [self creatBtnWithTitle:@"删除全部缓存" centerY:SCREEN.height - 150 action:@selector(deleteImageClicked)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)selectImageClicked{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选取图片来源" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_imagePickerController selectImageFromCameraSuccess:^(UIImagePickerController *imagePickerController) {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        } fail:^{
            NSLog(@"无法获取相机权限");
        }];
    }];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"无法获取相机权限");
        [JHImageTool presentPhotoVC:self maxCount:3 completeHandler:^(NSMutableArray<JHPhotoItem *> *images) {
            JHPhotoItem * item = images[0];
            [item originalImage:^(UIImage *original) {
                _imageView.image = original;
            }];
        }];
//        [_imagePickerController selectImageFromAlbumSuccess:^(UIImagePickerController *imagePickerController) {
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//        } fail:^{
//            NSLog(@"无法获取相簿权限");
//        }];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectImageFinished:(UIImage *)image{
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectImageFinishedAndCaches:(UIImage *)image cachesIdentifier:(NSString *)identifier isCachesSuccess:(BOOL)isCaches{
    if (isCaches) {
        _imageView.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readImageClicked{
    UIImage * image = [_imagePickerController readImageFromCachesIdentifier:@"abc"];
    if (image) {
        _imageView.image = image;
    }else {
        _imageView.image = nil;
        NSLog(@"read image fail");
    }
}

- (void)deleteImageClicked{
//    if ([_imagePickerController removeCachePictureForIdentifier:@"abc"]) {
//        _imageView.image = nil;
//        NSLog(@"remove pics success");
//    }else {
//        NSLog(@"remove fail");
//    }
    if ([_imagePickerController removeCachePictures]){
        _imageView.image = nil;
        NSLog(@"remove pics success");
    }else {
        NSLog(@"remove fail");
    }
}

- (void)creatBtnWithTitle:(NSString*)title centerY:(CGFloat)y action:(nonnull SEL)action{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    btn.center = CGPointMake(SCREEN.width/2, y);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)dealloc{
    NSLog(@"dealloc : %@",self);
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
