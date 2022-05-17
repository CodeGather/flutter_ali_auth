//
//  PNSMainController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/5.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSMainController.h"
#import "PNSMainButtonView.h"
#import "PNSStyleSelectController.h"
#import "PNSVerifyController.h"
#import <PNSNetDetect/PNSNetDetect.h>

@interface PNSMainController ()

@property (nonatomic, strong) PNSMainButtonView *verifyTokenView;
@property (nonatomic, strong) PNSMainButtonView *loginTokenBtn;
@property (nonatomic, strong) PNSMainButtonView *delayLoginTokenBtn;
@property (nonatomic, strong) PNSMainButtonView *envDetectBtn;

@end

@implementation PNSMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"欢迎使用阿里巴巴本机认证服务";
}

#pragma mark - Action
- (void)clickVerifyTokenBtnAction:(id)sender {
    PNSVerifyController *controller = [[PNSVerifyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickLoginTokenBtnAction:(id)sender {
    PNSStyleSelectController *controller = [[PNSStyleSelectController alloc] init];
    controller.isDelay = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickDelayLoginTokenBtnAction:(id)sender {
    PNSStyleSelectController *controller = [[PNSStyleSelectController alloc] init];
    controller.isDelay = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEnvDetectBtnAction:(id)sender {
    PNSNetworkDetectViewController *controller = [[PNSNetworkDetectViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UI
- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.verifyTokenView];
    [self.view addSubview:self.loginTokenBtn];
    [self.view addSubview:self.delayLoginTokenBtn];
    [self.view addSubview:self.envDetectBtn];
}

- (void)setLayoutSubviews {
    [super setLayoutSubviews];
    
    [self.loginTokenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    [self.verifyTokenView mas_makeConstraints:^(MASConstraintMaker * _Nonnull make) {
        make.bottom.mas_equalTo(self.loginTokenBtn.mas_top).offset(-30);
        make.left.right.mas_equalTo(self.loginTokenBtn);
    }];
    
    [self.delayLoginTokenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginTokenBtn.mas_bottom).offset(30);
        make.left.right.mas_equalTo(self.loginTokenBtn);
    }];
    
    [self.envDetectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.delayLoginTokenBtn.mas_bottom).offset(30);
        make.left.right.mas_equalTo(self.delayLoginTokenBtn);
    }];
}

- (PNSMainButtonView *)verifyTokenView {
    if (!_verifyTokenView) {
        NSString *buttonTitile = @"本机号码认证流程";
        SEL buttonAction = @selector(clickVerifyTokenBtnAction:);
        NSString *description = @"模拟本机号码认证相关流程";
        _verifyTokenView = [[PNSMainButtonView alloc] initWithButtonTitle:buttonTitile
                                                             buttonTarget:self
                                                             buttonAction:buttonAction
                                                          descriptionText:description];
    }
    return _verifyTokenView;
}

- (PNSMainButtonView *)loginTokenBtn {
    if (!_loginTokenBtn) {
        NSString *buttonTitile = @"一键登录流程";
        SEL buttonAction = @selector(clickLoginTokenBtnAction:);
        NSString *description = @"模拟启动APP立马调用一键登录相关";
        _loginTokenBtn = [[PNSMainButtonView alloc] initWithButtonTitle:buttonTitile
                                                           buttonTarget:self
                                                           buttonAction:buttonAction
                                                        descriptionText:description];
    }
    return _loginTokenBtn;
}

- (PNSMainButtonView *)delayLoginTokenBtn {
    if (!_delayLoginTokenBtn) {
        NSString *buttonTitile = @"一键登录流程（延迟）";
        SEL buttonAction = @selector(clickDelayLoginTokenBtnAction:);
        NSString *description = @"模拟启动APP后，通过一些页面跳转到一键登录相关";
        _delayLoginTokenBtn = [[PNSMainButtonView alloc] initWithButtonTitle:buttonTitile
                                                                buttonTarget:self
                                                                buttonAction:buttonAction
                                                             descriptionText:description];
    }
    return _delayLoginTokenBtn;
}

- (PNSMainButtonView *)envDetectBtn {
    if (!_envDetectBtn) {
        NSString *buttonTitle = @"环境检测";
        SEL buttonAction = @selector(clickEnvDetectBtnAction:);
        NSString *description = @"如果遇到接口请求失败，可以点击该按钮，检查并展示下当前环境相关信息，帮助问题排查";
        _envDetectBtn = [[PNSMainButtonView alloc] initWithButtonTitle:buttonTitle
                                                          buttonTarget:self
                                                          buttonAction:buttonAction
                                                       descriptionText:description];
    }
    return _envDetectBtn;
}

@end
