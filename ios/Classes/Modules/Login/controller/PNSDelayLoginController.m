//
//  PNSDelayLoginController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSDelayLoginController.h"
#import "PNSSmsLoginController.h"

@interface PNSDelayLoginController ()

@property (nonatomic, strong) UIButton *oneKeyLoginBtn;

@end

@implementation PNSDelayLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"模拟程序中的功能界面";
    
    [self checkAndPrepareEnv];
}

#pragma mark - Logic
- (void)checkAndPrepareEnv {
    //开始状态置为YES，默认当前环境可以使用一键登录
    [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"为后面授权页拉起加个速，加速结果：%@", resultDic);
    }];
}

#pragma mark - Action
- (void)clickoneKeyLoginBtn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TXCustomModel *model = [PNSBuildModelUtils buildModelWithStyle:self.style
                                                      button1Title:@"短信登录（使用系统导航栏）"
                                                           target1:self
                                                         selector1:@selector(gotoSmsControllerAndShowNavBar)
                                                      button2Title:@"短信登录（隐藏系统导航栏）"
                                                           target2:self
                                                         selector2:@selector(gotoSmsControllerAndHiddenNavBar)];
    
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
            NSLog(@"页面点击事件回调：%@", resultDic);
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            //NSString *token = [resultDic objectForKey:@"token"];
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            //失败后可以跳转到短信登录界面
            PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
            controller.isHiddenNavgationBar = NO;
            UINavigationController *navigationController = weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                navigationController = (UINavigationController *)weakSelf.presentedViewController;
            }
            [navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)gotoSmsControllerAndShowNavBar {
    PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
    controller.isHiddenNavgationBar = NO;
    if (self.presentedViewController) {
        //找到授权页的导航控制器
        [(UINavigationController *)self.presentedViewController pushViewController:controller animated:YES];
    }
}

- (void)gotoSmsControllerAndHiddenNavBar {
    PNSSmsLoginController *controller = [[PNSSmsLoginController alloc] init];
    controller.isHiddenNavgationBar = YES;
    if (self.presentedViewController) {
        //找到授权页的导航控制器
        [(UINavigationController *)self.presentedViewController pushViewController:controller animated:YES];
    }
}


#pragma mark - UI
- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.oneKeyLoginBtn];
}

- (void)setLayoutSubviews {
    [super setLayoutSubviews];
    [self.oneKeyLoginBtn mas_makeConstraints:^(MASConstraintMaker * _Nonnull make) {
        make.left.mas_offset(40);
        make.right.mas_offset(-40);
        make.height.mas_offset(45);
        make.bottom.mas_offset(-50);
    }];
}

- (UIButton *)oneKeyLoginBtn {
    if (!_oneKeyLoginBtn) {
        _oneKeyLoginBtn = [[UIButton alloc] init];
        _oneKeyLoginBtn.backgroundColor = [UIColor orangeColor];
        _oneKeyLoginBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _oneKeyLoginBtn.titleLabel.numberOfLines = 0;
        _oneKeyLoginBtn.layer.cornerRadius = 5.0;
        [_oneKeyLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oneKeyLoginBtn setTitle:@"点击拉起一键登录授权页" forState:UIControlStateNormal];
        [_oneKeyLoginBtn addTarget:self
                            action:@selector(clickoneKeyLoginBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneKeyLoginBtn;
}

@end
