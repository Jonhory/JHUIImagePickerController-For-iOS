//
//  JHImageListVC.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <UIKit/UIKit.h>
#import "JHImageTool.h"

@interface JHImageListVC : UIViewController

@property(nonatomic, assign) NSUInteger listMaxCount;
@property(nonatomic, copy) JHImagePhotosCompletion myBlock;

@end
