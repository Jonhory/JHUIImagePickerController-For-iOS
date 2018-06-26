//
//  JHImagePhotosVC.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <UIKit/UIKit.h>
#import "JHImageTool.h"

@interface JHImagePhotosVC : UIViewController

@property(nonatomic, strong) JHListItem *item;
@property(nonatomic, copy) JHImagePhotosCompletion block;
@property(nonatomic, assign) NSUInteger maxCount;

@end
