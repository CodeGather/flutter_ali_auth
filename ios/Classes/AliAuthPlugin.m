#import "AliAuthPlugin.h"
#import <UIKit/UIKit.h>

#import "AliAuthEnum.h"
#import "MJExtension.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import "MBProgressHUD.h"
#import "PNSBuildModelUtils.h"
#import "NSDictionary+Utils.h"
#import "UIColor+Hex.h"
#import <AuthenticationServices/AuthenticationServices.h>

#define TX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TX_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

bool bool_true = true;
bool bool_false = false;

// 打印长度比较大的字符串
//#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

/// 添加ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding 取消
/// authorizationController.delegate = self; authorizationController.presentationContextProvider = self; 警告信息
@interface AliAuthPlugin()<UIApplicationDelegate, FlutterStreamHandler, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation AliAuthPlugin{
  FlutterEventSink _eventSink;
  FlutterResult _result;
  FlutterMethodCall * _callData;
  TXCustomModel * _model;
  Boolean _isChecked;
  Boolean _isHideToast;
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

#pragma mark - IOS 主动发送通知让 flutter调用监听 eventChannel start
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  if (_eventSink == nil) {
    _eventSink = eventSink;
    /** 返回初始化状态 */
    NSString *version = [[TXCommonHandler sharedInstance] getVersion];
    
    NSDictionary *dict = @{ @"resultCode": @"500004", @"msg": version };
    [self showResultMsg: dict msg:version];
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
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
    // 获取当前上网卡运营商名称，比如中国移动、中国电信、中国联通
    result([[TXCommonUtils init] getCurrentCarrierName]);
  }
  // 初始化SDK
  else if ([@"initSdk" isEqualToString:call.method]) {
    _isHideToast = [call.arguments boolValueForKey: @"isHideToast" defaultValue: NO];
    if (_eventSink == nil) {
      result(@{ @"code": @"500001", @"msg": @"请先对插件进行监听！" });
    } else {
      if (_model == nil || ![call.arguments boolValueForKey: @"isDelay" defaultValue: NO]) {
        [self initSdk];
      }
    }
  }
  // 延时登录获取非延时登录
  else if ([@"login" isEqualToString:call.method]) {
    if(_model == nil){
      NSDictionary *dict = @{ @"resultCode": @"500003" };
      [self showResult: dict];
      return;
    }
    self->_isChecked = NO;
    [self loginWithModel: _model complete:^{}];
  }
  else if ([@"checkEnvAvailable" isEqualToString:call.method]) {
    [self checkVerifyEnable:call result:result];
  }
  else if ([@"checkCellularDataEnable" isEqualToString:call.method]) {
    [self checkCellularDataEnable:call result:result];
  }
  else  if ([@"preLogin" isEqualToString:call.method]) {
    [self getPreLogin:call result:result];
  }
  else if ([@"quitPage" isEqualToString:call.method]) {
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
  }
  else if ([@"appleLogin" isEqualToString:call.method]) {
    [self handleAuthorizationAppleIDButtonPress:call result:result];
  }
  else if ([@"openPage" isEqualToString:call.method]) {
    // 1.初始化flutter控制器，并指定路由 “home”，flutter中根据该路由标识显示对应的界面
    FlutterViewController* flutterViewController = [
      [FlutterViewController alloc] initWithProject:nil
      initialRoute:[call.arguments stringValueForKey: @"pageRoute" defaultValue: @"/"]
      nibName:nil
      bundle:nil
    ];
    // 2. 跳转
    flutterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self findCurrentViewController] presentViewController:flutterViewController animated: YES completion:nil];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - 初始化SDK以及相关布局
- (void)initSdk {
  NSDictionary *dic = _callData.arguments;
  // _model = [TXCustomModel mj_objectWithKeyValues: dic];
  if ([[dic stringValueForKey: @"iosSk" defaultValue: @""] isEqualToString:@""]) {
    NSDictionary *dict = @{ @"resultCode": @"500000" };
    [self showResult: dict];
  }
  else {
    NSString *secret = [dic stringValueForKey: @"iosSk" defaultValue: @""];
    /** 不管是否延时登录都需要，先初始化model */
    _model = [PNSBuildModelUtils buildModelWithStyle: dic target:self selector:@selector(btnClick:)];
    //1. 初始化sdk，设置secret
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:secret complete:^(NSDictionary * _Nonnull resultDic) {
      //2. 调用check接口检查及准备接口调用环境
      [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable checkDic) {
        if ([PNSCodeSuccess isEqualToString:[checkDic objectForKey:@"resultCode"]] == YES) {
          //3. 调用取号接口，加速授权页的弹起
          [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout: 5.0 complete:^(NSDictionary * _Nonnull resultDic) {
            //4. 预取号成功后判断是否延时登录，否则立即登录
            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == YES) {
              if (![dic boolValueForKey: @"isDelay" defaultValue: NO]) {
                [self loginWithModel: self->_model complete:^{}];
              }
            }else{
                [self showResult: resultDic];
            }
          }];
        } else {
          NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:checkDic];
          [result setValue:@(bool_false) forKey: @"token"];
          [self showResult: result];
        }
      }];
    }];
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
      [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:5.0 complete:^(NSDictionary * _Nonnull resultDic) {
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
    [self resultData: dict];
  }];
}

/** 检测是否开启蜂窝网络 */
- (void)checkCellularDataEnable:(FlutterMethodCall*)call result:(FlutterResult)result {
  bool status = [TXCommonUtils checkDeviceCellularDataEnable];
  NSDictionary *dict = @{
    @"code": @"1",
    @"msg" : @"蜂窝网络检测",
    @"data" : @(status)
  };
  result(dict);
}


#pragma mark - action 选中第三方按钮时回调
- (void)btnClick: (UIGestureRecognizer *) sender {
  UIButton *view = (UIButton *)sender;
  NSInteger index = view.tag;
  NSDictionary *dict = @{
    @"code": @"700005",
    @"msg" : @"点击第三方登录按钮",
    @"data" : [NSNumber numberWithInteger: index]
  };
  [self resultData: dict];
  if (!self->_isChecked && !self->_isHideToast) {
    NSDictionary *dic = self -> _callData.arguments;
    [self showToast: [dic stringValueForKey: @"toastText" defaultValue: @"请先阅读用户协议"]];
  } else {
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated: YES complete:^(void) {}];
  }
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
    float timeout = 5.0; // self.tf_timeout.text.floatValue;
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

// 跳转Flutter混合原生view界面
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{    //获得参数
  NSLog(@"%@", @"我被点击了");
}

#pragma mark - action 一键登录公共方法
- (void)loginWithModel:(TXCustomModel *)model  complete:(void (^)(void))completion {
  float timeout = 5.0; //self.tf_timeout.text.floatValue;
  __weak typeof(self) weakSelf = self;
  
//  UIWindow *window = [[UIApplication sharedApplication].delegate window];
//  UIViewController * _vc = [[ViewController alloc] init];
//  window.rootViewController = _vc;
  
  UIViewController *_vc = [self findCurrentViewController];
  
//  UIButton *pushFlutterNativePageButton = [UIButton buttonWithType:UIButtonTypeSystem];
//  pushFlutterNativePageButton.frame = CGRectMake(100, 300, 300, 100);
//  [pushFlutterNativePageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//  [pushFlutterNativePageButton setTitle:@"跳转到Flutter混合原生view界面" forState:UIControlStateNormal];
//  [pushFlutterNativePageButton addTarget:self action:@selector(pushFlutterNativePage) forControlEvents:UIControlEventTouchUpInside];
//  [_vc.view addSubview:pushFlutterNativePageButton];
  
  // 每次登录时都设置没有登录状态
  self->_isChecked = false;
  
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
          
            //3. 调用获取登录Token接口，可以立马弹起授权页
            // 关闭loading
            [MBProgressHUD hideHUDForView:_vc.view animated:YES];
            [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:timeout controller:_vc model:model complete:^(NSDictionary * _Nonnull resultDic) {
              NSString *code = [resultDic objectForKey:@"resultCode"];
//              UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAllScreen:)];
//
//              UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vc.view.bounds.size.width, _vc.view.bounds.size.height)];
              //将手势添加到需要相应的view中去
              [[weakSelf findCurrentViewController].view hitTest:CGPointMake(_vc.view.bounds.size.width, _vc.view.bounds.size.height) withEvent:nil];
//              [[weakSelf findCurrentViewController].view addSubview:headerView];
              
              // 当存在isHiddenLoading时需要执行loading
              bool isHiddenLoading = [self->_callData.arguments boolValueForKey: @"isHiddenLoading" defaultValue: YES];
              if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code] && !isHiddenLoading) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showHUDAddedTo:[weakSelf findCurrentViewController].view animated:YES];
                  });
              } else if ([PNSCodeSuccess isEqualToString:code]) {
                bool autoQuitPage = [self->_callData.arguments boolValueForKey: @"autoQuitPage" defaultValue: YES];
                // 登录成功后是否自动关闭页面
                if (autoQuitPage) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                  });
                }
              } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
                // 通过switchCheck 参数动态控制 是否需要切换其他方式时需要勾选
                NSDictionary *dic = self -> _callData.arguments;
                if (!self->_isChecked && !self-> _isHideToast && [dic boolValueForKey: @"switchCheck" defaultValue: YES]) {
                  [self showToast: [dic stringValueForKey: @"toastText" defaultValue: @"请先阅读用户协议"]];
                  return;
                } else {
                  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                }
              } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) { // 点击同意协议
                self->_isChecked = [[resultDic objectForKey:@"isChecked"] boolValue];
              } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) { // 取消
                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
              } else if ([PNSCodeCarrierChanged isEqualToString:code]) { // 切换运营商
                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
              }
              [weakSelf showResult:resultDic];
            }];
        }];
    }];
}

#pragma mark -  toast
- (void)showToast:(NSString*) message {
  NSDictionary *dic = _callData.arguments;
  UIView *view = [self findCurrentViewController].view;
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: view animated:YES];
  // Set the text mode to show only text.
  hud.mode = MBProgressHUDModeText;
  hud.label.text = NSLocalizedString(message, @"温馨提示");
  // 内边剧
  hud.margin = [dic floatValueForKey: @"toastPadding" defaultValue: 10];
  // 文本颜色
  hud.contentColor = [UIColor colorWithHex: [dic stringValueForKey: @"toastColor" defaultValue: @"#FFFFFF"] defaultValue: @"#FFFFFF"];
  // 弹窗背景
  hud.bezelView.color = [UIColor colorWithHex: [dic stringValueForKey: @"toastBackground" defaultValue: @"#000000"] defaultValue: @"#000000"];
  // 弹窗背景样式
  hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
  
  CGFloat offSetY = view.bounds.size.height / 2;
  NSString* toastPosition = [dic stringValueForKey: @"toastPositionMode" defaultValue: @"bottom"];
  if ([toastPosition  isEqual: @"top"]) {
    CGFloat top = [dic floatValueForKey: @"toastMarginTop" defaultValue: 30.f];
    offSetY = - offSetY + view.window.safeAreaInsets.top + top;
  } else if ([toastPosition  isEqual: @"bottom"]) {
    CGFloat bottom = [dic floatValueForKey: @"toastMarginBottom" defaultValue: 30.f];
    offSetY = offSetY - view.window.safeAreaInsets.bottom - bottom;
  } else if ([toastPosition  isEqual: @"center"]) {
    offSetY = 0;
  }
  // 设置上下的位置
  hud.offset = CGPointMake(0.f, offSetY);
  [hud hideAnimated:YES afterDelay: [dic floatValueForKey: @"toastDelay" defaultValue: 3]];
}

-(void) resultData:(NSDictionary *)dict{
  if (_eventSink != nil) {
       _eventSink(dict);
    }
}

#pragma mark -  格式化数据utils返回数据
- (void)showResult:(id __nullable)showResult {
  // 当存在isHiddenLoading时需要执行关闭
  if (![self->_callData.arguments boolValueForKey: @"isHiddenLoading" defaultValue: YES]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideHUDForView: [self findCurrentViewController].view animated:YES];
    });
  }
  
  NSDictionary *dict = @{
      @"code": [NSString stringWithFormat: @"%@", [showResult objectForKey:@"resultCode"]],
      @"msg" : [AliAuthEnum initData][[showResult objectForKey:@"resultCode"]]?:@"",
      @"data" : [showResult objectForKey: @"token"]?:@""
  };

  [self resultData: dict];
  [self showResultLog: showResult];
}

#pragma mark -  格式化数据utils返回数据
- (void)showResultMsg:(id __nullable)showResult msg: (NSString*)msg {
  NSString *resultMsg = [NSString stringWithFormat: [AliAuthEnum initData][[showResult objectForKey:@"resultCode"]], msg]?:@"";
  NSDictionary *dict = @{
      @"code": [NSString stringWithFormat: @"%@", [showResult objectForKey:@"resultCode"]],
      @"msg" : resultMsg,
      @"data" : [showResult objectForKey: @"token"]?:@""
  };

  [self resultData: dict];
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
    }
    else{
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

      [self resultData: resultData];
    }
}


#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
//    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"授权完成---开始返回数据");
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
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

      [self resultData: resultData];
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = (ASPasswordCredential*)authorization.credential;
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
      
      [self resultData: resultData];
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
      
      [self resultData: resultData];
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
  
  [self resultData: resultData];
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
  
//    UIViewController * vc = [[ViewController alloc] init];
//    window.rootViewController = vc;
//  UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAllScreen:)];
//  [window addGestureRecognizer:singleTap];
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

- (void) clickAllScreen:(UITapGestureRecognizer *) recognizer {
  NSLog(@"点击事件屏蔽");
}

@end
