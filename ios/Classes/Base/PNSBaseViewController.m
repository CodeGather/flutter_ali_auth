//
//  PNSBaseViewController.m
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//

#import "PNSBaseViewController.h"

@interface PNSBaseViewController ()

@end

@implementation PNSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    [self setLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 状态栏

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldSetStatusBarStyleLight {
    return YES;
}

- (BOOL)shouldHiddenStatusBar {
    return NO;
}

#pragma mark - UI
- (void)initSubviews {
    // 子类重写
}

- (void)setLayoutSubviews {
    //子类重新
}

#pragma mark - 屏幕方向（让设备支持旋转, 但是只支持竖屏, 这样防止从横屏过来导致APP没法旋转成竖屏）
// 是否支持设备自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"[%@,%@]===已被释放",NSStringFromClass([self class]), self.navigationItem.title ?: self.title);
}

@end
