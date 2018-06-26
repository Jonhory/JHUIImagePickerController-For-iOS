//
//  JHImagePhotosCell.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <UIKit/UIKit.h>

#import "JHImageTool.h"

//let JHPhotosCellWH: CGFloat = (jhSCREEN.width - 5 * 4) / 4
#define JHImagePhotosCellID @"JHImagePhotosCellID"
#define JHPhotosCellWH ((jhSCREEN.width - 5 * 4) / 4)

@interface UIButton (JHAnimation)
- (void)showAnimation;
@end


@protocol JHImagePhotosCellDelegate<NSObject>

- (void)photosCellClicked:(JHPhotoItem *)item btn:(UIButton *)btn;

@end

@interface JHImagePhotosCell : UICollectionViewCell

@property(nonatomic, weak) id<JHImagePhotosCellDelegate> delegate;
@property(nonatomic, strong) JHPhotoItem *item;
@property(nonatomic, strong) UIImageView *iv;

@end
