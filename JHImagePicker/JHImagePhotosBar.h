//
//  JHImagePhotosBar.h
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import <UIKit/UIKit.h>

@protocol JHImagePhotosBarDelegate<NSObject>

- (void)barClicked;

@end

@interface JHImagePhotosBar : UIView

@property(nonatomic, weak) id<JHImagePhotosBarDelegate> delegate;
@property(nonatomic, strong) UIButton *finishedBtn;

- (void)handleBarBtn:(BOOL)enable count:(NSUInteger)count;

@end
