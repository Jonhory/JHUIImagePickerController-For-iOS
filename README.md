# JHUIImagePickerController-For-iOS
EasyUIImagePickerController for iOS

###update:
* 1、添加了isEditImage属性，是否设置裁剪，默认为YES。

    `若不需要裁剪图片，则设置该属性。`
    
   `_imagePickerController.isEditImage = NO;`
   
*   2、修复了一个BUG，该BUG导致设置缓存时触发两个回调代理方法。
    
     
    
###正文：
1.声明

`JHImagePickerController * _imagePickerController;`

2.初始化呢

    //初始化方法一
    //_imagePickerController = [[JHImagePickerController alloc]init];
    //设置是否缓存 默认为NO
    //_imagePickerController.isCaches = YES;
    //设置缓存标识符
    //_imagePickerController.identifier = @"abc";
    
    //初始化方法二
    _imagePickerController = [[JHImagePickerController alloc]initWithIsCaches:YES andIdentifier:@"abc"];
    
3.设置代理

`_imagePickerController.delegate = self;`

4.选取图片来自相册

    [_imagePickerController selectImageFromAlbumSuccess:^(UIImagePickerController *imagePickerController) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
        } fail:^{
            NSLog(@"无法获取相簿权限");
    }];
    

选取图片来自相机

    [_imagePickerController selectImageFromCameraSuccess:^(UIImagePickerController *imagePickerController) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
        } fail:^{
            NSLog(@"无法获取相机权限");
    }];

5.当未设置缓存或缓存identifier为空时返回该方法

    - (void)selectImageFinished:(UIImage *)image{
        _imageView.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
    }

当设置了缓存，且输入缓存identifier时返回该方法(未设置缓存时可以不实现)

    - (void)selectImageFinishedAndCaches:(UIImage *)image cachesIdentifier:(NSString *)identifier isCachesSuccess:(BOOL)isCaches{
        if (isCaches) {
            _imageView.image = image;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }

6.根据identifier读取缓存图片

    - (void)readImageClicked{
        UIImage * image = [_imagePickerController readImageFromCachesIdentifier:@"abc"];
        if (image) {
            _imageView.image = image;
        }else {
            _imageView.image = nil;
            NSLog(@"read image fail");
        }
    }
    
7.删除指定identifier的缓存图片(删除id：abc)

    //    if ([_imagePickerController removeCachePictureForIdentifier:@"abc"]) {
    //        _imageView.image = nil;
    //        NSLog(@"remove pics success");
    //    }else {
    //        NSLog(@"remove fail");
    //    }

删除全部缓存图片

    if ([_imagePickerController removeCachePictures]){
        _imageView.image = nil;
        NSLog(@"remove pics success");
    }else {
        NSLog(@"remove fail");
    }





 