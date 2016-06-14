//
//  ViewController.m
//  EaseUIImagePickerController
//
//  Created by jonhory on 16/6/13.
//
//

#import "ViewController.h"
#import "NextViewController.h"

#define SCREEN [UIScreen mainScreen].bounds.size

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatBtnWithTitle:@"跳转下一个VC" centerY:SCREEN.height - 150 action:@selector(goNextVC)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)goNextVC{
    NextViewController * VC = [[NextViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)creatBtnWithTitle:(NSString*)title centerY:(CGFloat)y action:(nonnull SEL)action{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    btn.center = CGPointMake(SCREEN.width/2, y);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
