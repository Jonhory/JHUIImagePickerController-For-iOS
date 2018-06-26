//
//  JHImagePhotosBar.m
//  EaseUIImagePickerController
//
//  Created by Jonhory on 2018/6/26.
//

#import "JHImagePhotosBar.h"

@implementation JHImagePhotosBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        self.backgroundColor = [UIColor colorWithRed:39/255.0 green:46/255.0 blue:51/255.0 alpha:1.0];
    }
    return self;
}

- (void)btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(barClicked)]) {
        [self.delegate barClicked];
    }
}

- (void)handleBarBtn:(BOOL)enable count:(NSUInteger)count {
    self.finishedBtn.enabled = enable;
    if (enable) {
        self.finishedBtn.backgroundColor = [self enableGreenColor];
        [self.finishedBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",count] forState:UIControlStateNormal];
    } else {
        self.finishedBtn.backgroundColor = [self disableGreenColor];
        [self.finishedBtn setTitle:[NSString stringWithFormat:@"完成"] forState:UIControlStateNormal];
    }
}

- (void)loadUI {
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
    topLine.backgroundColor = [UIColor blackColor];
    UIView *topLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, self.bounds.size.width, 0.5)];
    topLine2.backgroundColor = [UIColor colorWithRed:35/255.0 green:41/255.0 blue:46/255.0 alpha:1.0];
    
    [self addSubview:topLine];
    [self addSubview:topLine2];
    
    UIButton *finishedBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 73, 6.5, 60, 31)];
    finishedBtn.backgroundColor = [self disableGreenColor];
    [finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    finishedBtn.layer.cornerRadius = 4;
    [finishedBtn setTitleColor:[UIColor colorWithRed:93/255.0 green:134/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishedBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    finishedBtn.enabled = NO;
    [self addSubview:finishedBtn];
    self.finishedBtn = finishedBtn;
}

- (UIColor *)disableGreenColor {
    return [UIColor colorWithRed:23/255.0 green:82/255.0 blue:22/255.0 alpha:1.0];
}

- (UIColor *)enableGreenColor {
    return [UIColor colorWithRed:26/255.0 green:173/255.0 blue:25/255.0 alpha:1.0];
}



@end
