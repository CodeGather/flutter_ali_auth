//
//  PNSSmsLoginController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSSmsLoginController.h"

@interface PNSSmsLoginController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITextField *phonenumberTf;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *getSmsCodeBtn;

@end

@implementation PNSSmsLoginController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"短信登录";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isHiddenNavgationBar) {
        //显示系统导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isHiddenNavgationBar) {
        //隐藏系统导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)backPrePage:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickGetSmsCodeButton:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)initSubviews {
    [super initSubviews];
    if (self.isHiddenNavgationBar) {
        [self.view addSubview:self.backBtn];
    }
    [self.view addSubview:self.phonenumberTf];
    [self.view addSubview:self.getSmsCodeBtn];
    [self.view addSubview:self.line];
}

- (void)setLayoutSubviews {
    [super setLayoutSubviews];
    if (self.isHiddenNavgationBar) {
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
            } else {
                make.top.mas_equalTo(35);
            }
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(26);
        }];
    }
    [self.phonenumberTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phonenumberTf.mas_bottom).offset(6);
        make.left.mas_equalTo(self.phonenumberTf);
        make.right.mas_equalTo(self.phonenumberTf);
        make.height.mas_equalTo(0.3);
    }];
    [self.getSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-35);
        } else {
            make.bottom.mas_equalTo(self.view).offset(-35);
        }
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(45);
    }];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_nav_back_gray"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backPrePage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UITextField *)phonenumberTf {
    if (!_phonenumberTf) {
        _phonenumberTf = [[UITextField alloc] init];
        _phonenumberTf.borderStyle = UITextBorderStyleNone;
        UILabel *leftTipLabel = [[UILabel alloc] init];
        leftTipLabel.font = [UIFont systemFontOfSize:15.0];
        leftTipLabel.text = @" +86 >  ";
        _phonenumberTf.leftView = leftTipLabel;
        _phonenumberTf.leftViewMode = UITextFieldViewModeAlways;
        _phonenumberTf.placeholder = @"请输入手机号";
        _phonenumberTf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phonenumberTf;
}

- (UIButton *)getSmsCodeBtn {
    if (!_getSmsCodeBtn) {
        _getSmsCodeBtn = [[UIButton alloc] init];
        _getSmsCodeBtn.backgroundColor = [UIColor orangeColor];
        _getSmsCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _getSmsCodeBtn.titleLabel.numberOfLines = 0;
        _getSmsCodeBtn.layer.cornerRadius = 5.0;
        [_getSmsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getSmsCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        [_getSmsCodeBtn addTarget:self
                               action:@selector(clickGetSmsCodeButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _getSmsCodeBtn;
}

@end
