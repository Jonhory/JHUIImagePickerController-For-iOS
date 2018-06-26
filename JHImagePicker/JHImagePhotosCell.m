//
//  JHImagePhotosCell.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImagePhotosCell.h"

@implementation UIButton (JHAnimation)

- (void)showAnimation {
    NSTimeInterval duration = 0.6;
    CGFloat maxScale = 1.1;
    CGFloat minScale = 0.9;
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:duration/3 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, maxScale, maxScale);
        }];
        [UIView addKeyframeWithRelativeStartTime:duration/3 relativeDuration:duration/3*2 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, minScale, minScale);
        }];
        [UIView addKeyframeWithRelativeStartTime:duration/3*2 relativeDuration:duration animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    } completion:nil];
}

@end

@interface JHImagePhotosCell()

@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIButton *maskV;

@end

@implementation JHImagePhotosCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)selectBtnClick:(UIButton *)btn {
    if (self.item) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(photosCellClicked:btn:)]) {
            [self.delegate photosCellClicked:self.item btn:btn];
        }
    }
}

- (void)setItem:(JHPhotoItem *)item {
    _item = item;
    
    self.selectBtn.selected = item.isSelected;
    if (item.isAble) {
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)item.index] forState:UIControlStateSelected];
    } else {
        [self.selectBtn setTitle:nil forState:UIControlStateNormal];
    }
    
    self.maskV.hidden = item.isAble;
    if (item.isNeedAnimated) {
        [self.selectBtn showAnimation];
        item.isNeedAnimated = NO;
    }
}

- (void)loadUI {
    [self.contentView addSubview:self.iv];
    [self.contentView addSubview:self.maskV];
    [self.contentView addSubview:self.selectBtn];
}

- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc]init];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
        _iv.frame = CGRectMake(0, 0, JHPhotosCellWH, JHPhotosCellWH);
        _iv.backgroundColor = [UIColor lightGrayColor];
    }
    return _iv;
}

- (UIButton *)maskV {
    if (!_maskV) {
        _maskV = [[UIButton alloc]initWithFrame:self.iv.bounds];
        _maskV.backgroundColor = [UIColor whiteColor];
        _maskV.alpha = 0.5;
        _maskV.hidden = YES;
    }
    return _maskV;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(JHPhotosCellWH - 27 - 2, 2, 27, 27)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"jh_select"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"jh_select"] forState:UIControlStateHighlighted];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"jh_selected"] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
