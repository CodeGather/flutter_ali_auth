//
//  PrivacyWebViewController.m
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//

#import "PrivacyWebViewController.h"
#import <WebKit/WebKit.h>

@interface PrivacyWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, copy) NSString *urlName;

@end

@implementation PrivacyWebViewController

- (instancetype)initWithUrl:(NSString *)url andUrlName:(nonnull NSString *)urlName{
    self = [super init];
    if (self) {
        _url = url ?: nil;
        _urlName = urlName ?: nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.urlName ?: @"服务协议";
    [self.view addSubview:self.webView];
    
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
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


#pragma mark - UI

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = 0;
        preference.javaScriptEnabled = YES;
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        float y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.webView];
}

@end
