#import "AliAuthPlugin.h"

#import <UIKit/UIKit.h>

#import <ATAuthSDK/ATAuthSDK.h>
//#import "ProgressHUD.h"
#import "PNSBuildModelUtils.h"
#import "NSDictionary+Utils.h"
#import <AuthenticationServices/AuthenticationServices.h>

#define TX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TX_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

bool bool_true = true;
bool bool_false = false;

// 打印长度比较大的字符串
//#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

@interface AliAuthPlugin()<FlutterStreamHandler>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *img_logo;
@property (nonatomic, strong) UILabel *label_slogan;
@property (nonatomic, strong) UITextField *tf_phoneNumber;
@property (nonatomic, strong) UITextField *tf_timeout;
/// 号码认证
@property (nonatomic, strong) UIButton *btn_verifyToken;
/// 一键登录
@property (nonatomic, strong) UIButton *btn_login;
/// 一键登录全屏，且支持旋转
@property (nonatomic, strong) UIButton *btn_login_full;
/// 已将登陆弹窗，且支持旋转
@property (nonatomic, strong) UIButton *btn_login_alert;
/// 一键登陆全屏竖屏，不支持旋转
@property (nonatomic, strong) UIButton *btn_login_full_vertical;
/// 一键登陆全屏横屏，不支持旋转
@property (nonatomic, strong) UIButton *btn_login_full_horizontal;
/// 一键登陆弹窗竖屏，不支持旋转
@property (nonatomic, strong) UIButton *btn_login_alert_vertical;
/// 一键登陆弹窗横屏，不支持旋转
@property (nonatomic, strong) UIButton *btn_login_alert_horizontal;
@property (nonatomic, strong) UITextView *tv_result;

@end

@implementation AliAuthPlugin {
  FlutterEventSink _eventSink;
  FlutterResult _result;
  FlutterMethodCall * _callData;
  TXCustomModel * _model;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  AliAuthPlugin* instance = [[AliAuthPlugin alloc] init];
  
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"ali_auth" binaryMessenger: [registrar messenger]];
  FlutterEventChannel* chargingChannel = [FlutterEventChannel eventChannelWithName:@"ali_auth/event" binaryMessenger: [registrar messenger]];
  
  [chargingChannel setStreamHandler: instance];
  [registrar addMethodCallDelegate:instance channel: channel];
  //为了让手机安装demo弹出使用网络权限弹出框
  [[AliAuthPlugin alloc] httpAuthority];
}

#pragma mark - IOS 主动发送通知s让 flutter调用监听 eventChannel start
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  if(_model == nil){
    [self initSdk];
  }
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _eventSink = nil;
  return nil;
}

// eventChannel end
#pragma mark - 测试联网阿里授权必须
-(void)httpAuthority{
  NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];//此处修改为自己公司的服务器地址
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (error == nil) {
          // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
          NSLog(@"联网成功！");
      } else {
        NSLog(@"联网失败！");
      }
  }];
  
  [dataTask resume];
}

#pragma mark - flutter调用 oc eventChannel start
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   // SDK 初始化
  _callData = call;
  _result = result;
  if ([@"init" isEqualToString:call.method]) {
    if(_model == nil){
      [self initSdk];
    } else {
      NSDictionary *dict = @{
          @"code": @"600024",
          @"msg" : @"终端环境检查⽀持认证",
          @"data" : @(bool_true)
      };
      self->_result(dict);
    }
  }
  else if ([@"checkVerifyEnable" isEqualToString:call.method]) {
    [self checkVerifyEnable:call result:result];
  }
  else  if ([@"login" isEqualToString:call.method]) {
    if(_model == nil){
      NSDictionary *dict = @{
          @"code": @"500000",
          @"msg" : @"请先调用init进行初始化SDK！",
          @"data" : @""
      };
      self->_eventSink(dict);
      return;
    }
    [self loginWithModel: _model complete:^{}];
  }
  else  if ([@"preLogin" isEqualToString:call.method]) {
    [self getPreLogin:call result:result];
  }
  else if ([@"appleLogin" isEqualToString:call.method]) {
    [self handleAuthorizationAppleIDButtonPress:call result:result];
  }
  else if ([@"quitPage" isEqualToString:call.method]) {
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - 初始化SDK以及相关布局
- (void)initSdk {
  NSDictionary *dic = _callData.arguments;
  if ([dic isKindOfClass:[NSDictionary class]]) {
    [self initSubviews];
    NSString *secret = dic[@"sk"];
    NSDictionary *config = dic[@"config"];
    
    /// 判断是否是弹窗模式
    if([config boolValueForKey: @"isDialog" defaultValue: NO]){
      _model = [PNSBuildModelUtils buildNewAlertModel: config
                                             selector: @selector(btnClick:)
                                               target: self];
      _model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    } else {
      _model = [PNSBuildModelUtils buildNewFullScreenModel: config
                                                  selector: @selector(btnClick:)
                                                    target: self];
      _model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    }

    // __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:secret complete:^(NSDictionary * _Nonnull resultDic) {
      /// 打印日志
      // [weakSelf showResult:resultDic];
      
      [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == YES) {
          NSDictionary *dict = @{
              @"code": @"600024",
              @"msg" : @"终端环境检查⽀持认证",
              @"data" : @(bool_true)
          };
          self->_result(dict);
        } else {
          NSDictionary *dict = @{
              @"code": [NSString stringWithFormat: @"%@", [resultDic objectForKey:@"resultCode"]],
              @"msg" : [resultDic objectForKey:@"msg"]?:@"",
              @"data" : @(bool_false)
          };
          self->_result(dict);
        }
      }];
    }];
    
    //显示版本信息
    NSLog(@"sdk version：%@；cm sdk version：5.7.1.beta；ct sdk version：3.6.2.1；cu sdk version：4.0.1 IR02B1030",
      [[TXCommonHandler sharedInstance] getVersion]
    );
    
  } else {
    NSDictionary *dict = @{
        @"code": @"500000",
        @"msg" : @"config配置信息出现问题，请检查阿里云控制台sk与包名是否一致",
        @"data" : @""
    };
    self->_eventSink(dict);
  }
}

/** SDK 判断网络环境是否支持 */
- (void)checkVerifyEnable:(FlutterMethodCall*)call result:(FlutterResult)result {
  __weak typeof(self) weakSelf = self;
  
  [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue: [resultDic objectForKey:@"resultCode"] forKey: @"code"];
    if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
        [weakSelf showResult:resultDic];
        [dict setValue: @(bool_false) forKey: @"data"];
    } else {
      [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
          /// NSLog(@"为后面授权页拉起加个速，加速结果：%@", resultDic);
      }];
        // 中国移动支持2G/3G/4G、中国联通支持3G/4G、中国电信支持4G。   2G网络下认证失败率较高
        // WiFi，4G，3G，2G，NoInternet等
//            NSString *networktype = [[TXCommonUtils init] getNetworktype];
//            // 中国移动，中国联通，中国电信等
//            NSString *carrierName = [[TXCommonUtils init] getCurrentCarrierName];
//            if( [carrierName isEqual:(@"中国移动")] && [networktype isEqual:(@"2G")] && [networktype isEqual:(@"3G")] && [networktype isEqual:(@"4G")] ){
//              result(@(bool_true));
//            } else if( [carrierName isEqual:(@"中国联通")] && [networktype isEqual:(@"3G")] && [networktype isEqual:(@"4G")]){
//              result(@(bool_true));
//            } else if( [carrierName isEqual:(@"中国电信")] && [networktype isEqual:(@"4G")]){
//              result(@(bool_true));
//            }
//            result(@(bool_false));
      [dict setValue: @"终端环境检查⽀持认证" forKey: @"msg"];
      [dict setValue: @"600024" forKey: @"code"];
      [dict setValue: @(bool_true) forKey: @"data"];
    }
    self->_eventSink(dict);
  }];
}

#pragma mark - action 选中第三方按钮时回调
- (void)btnClick: (UIGestureRecognizer *) sender {
  UIView *view = (UIView *)sender.view;
  NSInteger index = view.tag;
  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated: YES complete:^(void) {
    NSDictionary *dict = @{
      @"code": @"700005",
      @"msg" : @"点击第三方登录按钮",
      @"data" : [NSNumber numberWithInteger: index]
    };
    self->_eventSink(dict);
  }];
}

// 一键登录预取号
- (void)getPreLogin:(FlutterMethodCall*)call result:(FlutterResult)result{
    [self accelerateLogin:_model call:call result:result complete:^{}];
}

/**
   * 函数名: accelerateLoginPageWithTimeout
  * @brief 加速一键登录授权页弹起，防止调用 getLoginTokenWithTimeout:controller:model:complete: 等待弹起授权页时间过长
   * @param timeout：接口超时时间，单位s，默认3.0s，值为0.0时采用默认超时时间
   * @param complete 结果异步回调，成功时resultDic=@{resultCode:600000, msg:...}，其他情况时"resultCode"值请参考PNSReturnCode
*/
#pragma mark - action 一键登录预取号
- (void)accelerateLogin:(TXCustomModel *)model call:(FlutterMethodCall*)call result:(FlutterResult)result complete:(void (^)(void))completion {
    float timeout = 5.0; //self.tf_timeout.text.floatValue;
    __weak typeof(self) weakSelf = self;
    
    //1. 调用check接口检查及准备接口调用环境
  [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
            [weakSelf showResult:resultDic];
            return;
        }
        
        //2. 调用取号接口，加速授权页的弹起
        [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:timeout complete:^(NSDictionary * _Nonnull resultDic) {
            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
                [weakSelf showResult:resultDic];
                return;
            }
            
            [weakSelf showResult:resultDic];
        }];
    }];
}

#pragma mark - action 一键登录公共方法
- (void)loginWithModel:(TXCustomModel *)model  complete:(void (^)(void))completion {
  float timeout = 5.0; //self.tf_timeout.text.floatValue;
  __weak typeof(self) weakSelf = self;
  UIViewController *_vc = [self findCurrentViewController];
    
  //1. 调用check接口检查及准备接口调用环境
  [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
            [weakSelf showResult:resultDic];
            return;
        }
        
        //2. 调用取号接口，加速授权页的弹起
        [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:timeout complete:^(NSDictionary * _Nonnull resultDic) {
            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
                [weakSelf showResult:resultDic];
                return ;
            }
            
            //3. 调用获取登录Token接口，可以立马弹起授权页
            [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:timeout controller:_vc model:model complete:^(NSDictionary * _Nonnull resultDic) {
                NSString *code = [resultDic objectForKey:@"resultCode"];
                if ([PNSCodeSuccess isEqualToString:code]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                    });
                } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
                  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                } else if ([PNSCodeCarrierChanged isEqualToString:code]) { // 切换运营商
//                  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                } else if ([PNSCodeLoginControllerClickChangeBtn isEqual: code]){
                  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                }
              [weakSelf showResult:resultDic];
            }];
        }];
    }];
}

#pragma mark - UI
- (void)initSubviews {
    [self.scrollView addSubview:self.img_logo];
    [self.scrollView addSubview:self.label_slogan];
    [self.scrollView addSubview:self.tf_phoneNumber];
    [self.scrollView addSubview:self.tf_timeout];
    [self.scrollView addSubview:self.btn_verifyToken];
    [self.scrollView addSubview:self.btn_login];
    [self.scrollView addSubview:self.btn_login_full];
    [self.scrollView addSubview:self.btn_login_alert];
    [self.scrollView addSubview:self.btn_login_full_vertical];
    [self.scrollView addSubview:self.btn_login_full_horizontal];
    [self.scrollView addSubview:self.btn_login_alert_vertical];
    [self.scrollView addSubview:self.btn_login_alert_horizontal];
    [self.scrollView addSubview:self.tv_result];
}

#pragma mark -  格式化数据utils返回数据
- (void)showResult:(id __nullable)showResult  {
  NSDictionary *dict = @{
      @"code": [NSString stringWithFormat: @"%@", [showResult objectForKey:@"resultCode"]],
      @"msg" : [showResult objectForKey:@"msg"]?:@"",
      @"data" : [showResult objectForKey:@"token"]?:@""
  };
  self->_eventSink(dict);
  [self showResultLog: showResult];
}

#pragma mark -  格式化数据utils统一输出日志
- (void)showResultLog:(id __nullable)showResult  {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *desc = nil;
        if ([showResult isKindOfClass:NSString.class]) {
            desc = (NSString *)showResult;
        } else {
            desc = [showResult description];
            // if (desc != nil) {
            //     desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
            // }
        }
        // NSLog( @"打印日志---->>%@", desc );
    });
}

#pragma mark -  Apple授权登录
// 处理授权
- (void)handleAuthorizationAppleIDButtonPress:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSLog(@"点击授权---开始授权");
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        NSLog(@"该系统版本不可用Apple登录");
        NSDictionary *resultData = @{
            @"code": @500,
            @"msg" : @"该系统版本不可用Apple登录",
            @"user" : @"",
            @"familyName" : @"",
            @"givenName" : @"",
            @"email" : @"",
            @"identityTokenStr": @"",
            @"authorizationCodeStr": @""
        };

        if (_eventSink) {
            _eventSink(resultData);
        }
    }
}


#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
//    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"授权完成---开始返回数据");
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        // NSLog(@"后台参数--%@\n\n%@", identityTokenStr, authorizationCodeStr);
//        NSLog(@"后台参数identityTokenStr---%@", identityTokenStr);
//        NSLog(@"后台参数authorizationCodeStr---%@", authorizationCodeStr);
        
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
//        [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
//        NSLog(@"user--%@", user);
//        NSLog(@"familyName--%@", familyName);
//        NSLog(@"givenName--%@", givenName);
//        NSLog(@"email--%@", email);
      
        NSDictionary *resultData = @{
            @"code": @200,
            @"msg" : @"获取成功",
            @"user" : user,
            @"familyName" : familyName != nil ? familyName : @"",
            @"givenName" : givenName != nil ? givenName : @"",
            @"email" : email != nil ? email : @"",
            @"identityTokenStr": identityTokenStr,
            @"authorizationCodeStr": authorizationCodeStr
        };

        if (_eventSink) {
            _eventSink(resultData);
        }
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        NSLog(@"user--%@", user);
        NSLog(@"password--%@", password);
        
        NSDictionary *resultData = @{
            @"code": @200,
            @"msg" : @"获取成功",
            @"user" : user,
            @"familyName" : @"",
            @"givenName" : @"",
            @"email" : @"",
            @"identityTokenStr": @"",
            @"authorizationCodeStr": @""
        };
      
        if (_eventSink) {
            _eventSink(resultData);
        }
    }else{
        NSLog(@"授权信息均不符");
        NSDictionary *resultData = @{
            @"code": @500,
            @"msg" : @"授权信息均不符",
            @"user" : @"",
            @"familyName" : @"",
            @"givenName" : @"",
            @"email" : @"",
            @"identityTokenStr": @"",
            @"authorizationCodeStr": @""
        };
      
        if (_eventSink) {
            _eventSink(resultData);
        }
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"苹果登录授权失败：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@", errorMsg);
    NSDictionary *resultData = @{
        @"code": @500,
        @"msg" : errorMsg,
        @"user" : @"",
        @"familyName" : @"",
        @"givenName" : @"",
        @"email" : @"",
        @"identityTokenStr": @"",
        @"authorizationCodeStr": @""
    };
  
    if (_eventSink) {
        _eventSink(resultData);
    }
}

#pragma mark - 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    NSLog(@"88888888888");
    // 返回window
    return [UIApplication sharedApplication].windows.lastObject;
}

#pragma mark - 获取到跟视图
- (UIViewController *)getRootViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}

#pragma mark  ======在view上添加UIViewController========
- (UIViewController *)findCurrentViewController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end
