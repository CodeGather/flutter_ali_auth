//
//  PNSVerifyController.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSVerifyController.h"

@interface PNSVerifyController ()

@property (nonatomic, strong) UITextField *phonenumberTf;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *verifyBtn;

@end

@implementation PNSVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"本机号码校验";
        
    [self checkAndPrepareEnv];
}

#pragma mark - Logic
- (void)checkAndPrepareEnv {
    //开始状态置为YES，默认当前环境可以使用一键登录
    [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:3.0
                                                         complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"为后面获取本机号码校验Token加个速，加速结果：%@", resultDic);
    }];
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)clickVerifyButton:(id)sender {
    
    NSString *phoneNumber = self.phonenumberTf.text;
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!phoneNumber || phoneNumber.length == 0) {
        PNSToast(self.view, @"请输入手机号", 2.0);
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) ws = self;
    [[TXCommonHandler sharedInstance] getVerifyTokenWithTimeout:3.0
                                                       complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"获取本机号码校验Token返回：%@", resultDic);
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]]) {
            //NSString *token = [resultDic objectForKey:@"token"];
            NSString *text = @"获取Token成功，接下来可以拿着Token和用户输入手机号去服务端进行校验，SDK提供服务到此结束";
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
            PNSToast(ws.view, text, 4.0);
        } else {
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
            PNSToast(ws.view, [resultDic objectForKey:@"msg"], 3.0);
        }
    }];
}

#pragma mark - UI
- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.phonenumberTf];
    [self.view addSubview:self.line];
    [self.view addSubview:self.verifyBtn];
}

- (void)setLayoutSubviews {
    [super setLayoutSubviews];
    
    [self.phonenumberTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 35);
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
    [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UIButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn = [[UIButton alloc] init];
        _verifyBtn.backgroundColor = [UIColor orangeColor];
        _verifyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _verifyBtn.titleLabel.numberOfLines = 0;
        _verifyBtn.layer.cornerRadius = 5.0;
        [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_verifyBtn setTitle:@"本机号码校验" forState:UIControlStateNormal];
        [_verifyBtn addTarget:self
                       action:@selector(clickVerifyButton:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}

@end
