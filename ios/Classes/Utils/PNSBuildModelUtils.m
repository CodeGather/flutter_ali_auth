//
//  PNSBuildModelUtils.m
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//
#import "NSDictionary+Utils.h"

#import "CustomButton.h"
#import "MJExtension.h"
#import "AliAuthEnum.h"
#import "PNSBuildModelUtils.h"
#import "PNSBackgroundView.h"
#import "AliAuthPlugin.h"
#import <ATAuthSDK/ATAuthSDK.h>

#define TX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define TX_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IS_HORIZONTAL (TX_SCREEN_WIDTH > TX_SCREEN_WIDTH)

#define TX_Alert_NAV_BAR_HEIGHT      55.0
#define TX_Alert_HORIZONTAL_NAV_BAR_HEIGHT      41.0

//竖屏弹窗
#define TX_Alert_Default_Left_Padding         42
#define TX_Alert_Default_Top_Padding          115

/**横屏弹窗*/
#define TX_Alert_Horizontal_Default_Left_Padding      80.0

@implementation PNSBuildModelUtils

+ (TXCustomModel *)buildModelWithStyle:(NSDictionary *)dict
                                target:(id)target
                              selector:(SEL)selector {
  TXCustomModel *model = nil;
  /// 页面类型
  PNSBuildModelStyle style = [dict intValueForKey: @"pageType" defaultValue: 0];
  model = [self buildModelOption:dict target:target style:style selector:selector];
  return model;
}

#pragma mark - 全屏-竖屏
+ (TXCustomModel *)buildFullScreenPortraitModel:(NSDictionary *)viewConfig
                                                        target:(id)target
                                                      selector:(SEL)selector{
  TXCustomModel *model = [[TXCustomModel alloc] init];
  
  // JSON -> TXCustomModel
  // TXCustomModel *modelConfig = [TXCustomModel mj_objectWithKeyValues:viewConfig];
  
  // 1状态栏START
  model.prefersStatusBarHidden = [viewConfig boolValueForKey: @"isStatusBarHidden" defaultValue: NO];
  bool isLightColor = [viewConfig boolValueForKey: @"lightColor" defaultValue: NO];
  model.preferredStatusBarStyle = isLightColor ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
  // 1状态栏ENd
  
  /// 导航设置
  model.navIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
  model.navColor = [self getColor: [viewConfig stringValueForKey: @"navColor" defaultValue: @"#3971fe"]];

  model.navTitle = [
    [NSAttributedString alloc]
      initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
          attributes: @{
            NSForegroundColorAttributeName: UIColor.whiteColor,
            NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
          }
  ];
  
  /// 返回按钮 START
  bool isHiddenNavBack = [viewConfig boolValueForKey: @"navReturnHidden" defaultValue: NO];
  model.hideNavBackItem = isHiddenNavBack;
  /// 动态读取assets文件夹下的资源
  UIImage * navBackImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"navReturnImgPath" defaultValue: nil]];
  model.navBackImage = navBackImage?:[UIImage imageNamed:@"icon_close_light"];
  
  if (!isHiddenNavBack) {
    /// 自定义返回按钮
    model.navBackButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      UIImageView *imageView = [[UIImageView alloc]init];
      imageView.image = navBackImage;
      imageView.frame = CGRectMake(
                         CGRectGetMinX(frame),
                         CGRectGetMaxY(frame),
                         CGRectGetWidth(frame),
                         CGRectGetHeight(frame)
                       );
      frame.origin.y = [viewConfig floatValueForKey: @"navReturnOffsetY" defaultValue: 5];
      frame.origin.x = [viewConfig floatValueForKey: @"navReturnOffsetX" defaultValue: 15];
      
      frame.size.width = [viewConfig floatValueForKey: @"navReturnImgWidth" defaultValue: 40];
      frame.size.height = [viewConfig floatValueForKey: @"navReturnImgHeight" defaultValue: 40];
      return frame;
    };
  }
  /// 返回按钮 END
  
  /// 右侧按钮布局设置
  // UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
  // [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
  // model.navMoreView = rightBtn;
  
  /// 协议页面导航设置
  model.privacyNavColor = [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#000"]];
  UIImage * privacyNavBackImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"webNavReturnImgPath" defaultValue: nil]];
  if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
  }
  model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000"]];
  
  /// logo 设置
  model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: NO];
  UIImage * image = [self changeUriPathToImage: [viewConfig stringValueForKey: @"logoImgPath" defaultValue: nil]];
  if(image != nil){
    /// logo 默认水平居中
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      frame.size.width = [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80];
      frame.size.height = [viewConfig floatValueForKey: @"logoHeight" defaultValue: 80];
      frame.origin.y = [viewConfig floatValueForKey: @"logoOffsetY" defaultValue: screenSize.height > screenSize.width ? 30 : 15];
      frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80]) * 0.5;
      return frame;
    };
    model.logoImage = image;
  }
  
  /// slogan 设置 START
  model.sloganIsHidden = [viewConfig boolValueForKey: @"sloganHidden" defaultValue: NO];
  model.sloganText = [
    [NSAttributedString alloc]
    initWithString: [viewConfig stringValueForKey: @"sloganText" defaultValue: @"一键登录欢迎语"]
        attributes: @{
         NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555555"]],
         NSFontAttributeName: [
            UIFont systemFontOfSize: [viewConfig floatValueForKey: @"sloganTextSize" defaultValue: 19]
         ]
        }
  ];
  model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if (screenSize.height > screenSize.width) {
      frame.origin.y = [viewConfig floatValueForKey: @"sloganOffsetY" defaultValue: 20 + 80 + 20];
      return frame;
    } else {
      return CGRectZero;
    }
  };
  /// slogan 设置 END
  
  /// number 设置 START
  model.numberColor = [self getColor: [viewConfig stringValueForKey: @"numberColor" defaultValue: @"#555"]];
  model.numberFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"numberSize" defaultValue: 17]];
  model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.origin.y = [viewConfig floatValueForKey: @"numFieldOffsetY" defaultValue: 130 + 20 + 15];
      } else {
        frame.origin.y = 15 + 80 + 15;
      }
      return frame;
  };
  /// number 设置 END
  
  /// 登录按钮的设置 START
  model.loginBtnText = [
    [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"logBtnText" defaultValue: @"一键登录欢迎语"]
            attributes: @{
              NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"logBtnTextColor" defaultValue: @"#ff00ff"]],
              NSFontAttributeName: [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"logBtnTextSize" defaultValue: 23]]
            }
  ];
  /// 登录按钮背景设置
  NSArray *logBtnCustomBackgroundImagePath = [[viewConfig stringValueForKey: @"logBtnBackgroundPath" defaultValue: @","] componentsSeparatedByString:@","];
  if (logBtnCustomBackgroundImagePath.count == 3) {
    // login_btn_normal
    UIImage* login_btn_normal = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[0]];
    // login_btn_unable
    UIImage* login_btn_unable = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[1]];
    // login_btn_press
    UIImage* login_btn_press = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[2]];
    UIImage *defaultClick = [UIImage imageNamed:@"button_click"];
    UIImage *defaultUnClick = [UIImage imageNamed:@"button_unclick"];
      // fix '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
    if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && defaultUnClick != nil)) {
      // 登录按钮设置
      model.loginBtnBgImgs = @[
        login_btn_normal?:defaultClick,
        login_btn_unable?:defaultUnClick,
        login_btn_press?:defaultClick
      ];
    }
  }
  model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.size.width = [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300];
        frame.size.height = [viewConfig floatValueForKey: @"logBtnHeight" defaultValue: 40];
        frame.origin.y = [viewConfig floatValueForKey: @"logBtnOffsetY" defaultValue: 170 + 30 + 20];
        frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300]) * 0.5;
      } else {
        frame.origin.y = 110 + 30 + 20;
      }
      return frame;
  };
  /// 登录按钮的设置 END
  
  //model.autoHideLoginLoading = NO;
  
  /// 协议设置 START
  NSString *protocolOneURL = [viewConfig stringValueForKey: @"protocolOneURL" defaultValue: nil];
  if (protocolOneURL != nil) {
    model.privacyOne = @[
      [viewConfig stringValueForKey: @"protocolOneName" defaultValue: @"协议1"],
      protocolOneURL
    ];
  }
  NSString *protocolTwoURL = [viewConfig stringValueForKey: @"protocolTwoURL" defaultValue: nil];
  if (protocolTwoURL != nil) {
    model.privacyTwo = @[
      [viewConfig stringValueForKey: @"protocolTwoName" defaultValue: @"协议2"],
      protocolTwoURL
    ];
  }
  NSString *protocolThreeURL = [viewConfig stringValueForKey: @"protocolThreeURL" defaultValue: nil];
  if (protocolThreeURL != nil) {
    model.privacyThree = @[
      [viewConfig stringValueForKey: @"protocolThreeName" defaultValue: @"协议3"],
      protocolThreeURL
    ];
  }

  model.privacyAlertContentUnderline = [viewConfig boolValueForKey: @"privacyAlertProtocolNameUseUnderLine" defaultValue: NO];
  // 协议1内容颜色
  model.privacyOneColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnOneColor" defaultValue: @"#000000"]];
  // 协议2内容颜色
  model.privacyTwoColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnTwoColor" defaultValue: @"#000000"]];
  // 协议3内容颜色
  model.privacyThreeColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnThreeColor" defaultValue: @"#000000"]];
  // 运营商协议内容颜色
  model.privacyOperatorColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnColor" defaultValue: @"#000000"]];
  
  // 二次协议1内容颜色
  model.privacyAlertOneColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnOneColor" defaultValue: @"#000000"]];
  // 二次协议2内容颜色
  model.privacyAlertTwoColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnTwoColor" defaultValue: @"#000000"]];
  // 二次协议3内容颜色
  model.privacyAlertThreeColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnThreeColor" defaultValue: @"#000000"]];
  // 二次运营商协议内容颜色
  model.privacyAlertOperatorColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOperatorColor" defaultValue: @"#000000"]];
  
  /** 导航背景色*/
  model.privacyNavColor = [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#FFFFFF"]];
  /** 导航文字色 */
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];
  /** 字体大小  */
  model.privacyNavTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 12.0]];
  /** 返回按钮  */
  UIImage * webNavReturnImgPath = [self changeUriPathToImage: [viewConfig stringValueForKey: @"webNavReturnImgPath" defaultValue: nil]];
  if (webNavReturnImgPath != nil) {
    model.privacyNavBackImage = webNavReturnImgPath;
  }
  
  model.privacyAlignment = [viewConfig intValueForKey: @"protocolLayoutGravity" defaultValue: 1];;
  model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 12.0]];
  model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"点击一键登录并登录表示您已阅读并同意"];
  model.privacySufText = [viewConfig stringValueForKey: @"privacyEnd" defaultValue: @"思预云用户协议，隐私"];
  model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
  model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];
  
  /// 协议水平垂直设置
  model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.y = [viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1];
    }
    if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.x = [viewConfig floatValueForKey: @"privacyOffsetX" defaultValue: -1];
    }
    return frame;
  };
  // 0.2.3 - 1.12.4新增
  model.privacyVCIsCustomized = [viewConfig boolValueForKey: @"privacyVCIsCustomized" defaultValue: NO];
  // 是否使用授权页协议动画
  bool isPrivacyAnimation = [viewConfig boolValueForKey: @"isPrivacyAnimation" defaultValue: NO];
  if (isPrivacyAnimation) {
    CAKeyframeAnimation *privacyAnimation = [CAKeyframeAnimation animation];
    privacyAnimation.keyPath = @"transform.translation.x";
    privacyAnimation.values = @[@(0), @(-10), @(0)];
    privacyAnimation.repeatCount = 2;
    privacyAnimation.speed = 1;
    model.privacyAnimation = privacyAnimation;
  }
  /// 协议设置 END
  
  /// 切换到其他标题 START
  BOOL changeBrnStatus = [viewConfig boolValueForKey: @"switchAccHidden" defaultValue: NO];
  model.changeBtnIsHidden = changeBrnStatus;
  if (!changeBrnStatus) {
    model.changeBtnTitle = [
       [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"switchAccText" defaultValue: @"切换到其他方式"]
       attributes: @{
         NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"switchAccTextColor" defaultValue: @"#555555"]],
         NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"switchAccTextSize" defaultValue: 18]]
       }
    ];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        return CGRectMake(
          10,
          [viewConfig floatValueForKey: @"switchOffsetY" defaultValue: frame.origin.y],
          superViewSize.width - 20,
          30
        );
      } else {
        return CGRectZero; //横屏时模拟隐藏该控件
      }
    };
  }
  /// 切换到其他标题 END
  
  model.prefersStatusBarHidden = YES;
  model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
  
  /// 页面弹出方向 START
  model.presentDirection = [viewConfig intValueForKey: @"presentDirection" defaultValue: 0];
  /// 页面弹出方向 END
  
  /// 勾选统一按钮 START
  BOOL checkStatus = [viewConfig boolValueForKey: @"checkboxHidden" defaultValue: NO];
  model.checkBoxIsHidden = checkStatus;
  if (!checkStatus) {
    UIImage* unchecked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"uncheckedImgPath" defaultValue: nil]];
    UIImage* checked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"checkedImgPath" defaultValue: nil]];
    if (unchecked != nil && checked != nil) {
      model.checkBoxImages = @[
        unchecked,
        checked
      ];
    }
  }
  model.checkBoxIsChecked = [viewConfig boolValueForKey: @"privacyState" defaultValue: NO];
  model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxHeight" defaultValue: 17.0];
  /// 勾选统一按钮 END
  
  /// 自定义第三方按钮布局 START
  NSDictionary *customThirdView = [viewConfig dictValueForKey: @"customThirdView" defaultValue: nil];
  if (customThirdView != nil) {
    NSMutableArray * customArrayView = [NSMutableArray array]; /// 空数组，有意义
    NSArray * customArray = [customThirdView arrayValueForKey: @"viewItemPath" defaultValue: nil]; //空数组，有意义
    NSArray * customNameArray = [customThirdView arrayValueForKey: @"viewItemName" defaultValue: nil]; //空数组，有意义
    if(customArray != nil && customArray.count > 0){
      /// 第三方图标按钮的相关参数
      int width = [customThirdView intValueForKey: @"itemWidth" defaultValue: 70];
      int height = [customThirdView intValueForKey: @"itemHeight" defaultValue: 70];
      int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
      int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
      int textSize = [customThirdView intValueForKey: @"size" defaultValue: 30];
      NSString *color = [viewConfig stringValueForKey: @"color" defaultValue: @"#3C4E5F"];
      
      for (int i = 0 ; i < customArray.count; i++) {
        CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize: textSize];
        [button setTag: i];
        [button setTitle: customNameArray[i] forState:UIControlStateNormal];
        [button setTitleColor: [self getColor: color] forState:UIControlStateNormal];
        [button setBackgroundImage:[self changeUriPathToImage: customArray[i]] forState:UIControlStateNormal];
        [button addTarget:target action: selector forControlEvents:UIControlEventTouchUpInside];
    
        [customArrayView addObject: button];
      }
      /// 添加第三方图标
      model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        for (int i = 0 ; i < customArrayView.count; i++) {
          [superCustomView addSubview: customArrayView[i]];
        }
      };
      
      model.customViewLayoutBlock = ^(
        CGSize screenSize,       /// 全屏参数
        CGRect contentViewFrame, /// contentView参数
        CGRect navFrame,         /// 导航参数
        CGRect titleBarFrame,    /// title参数
        CGRect logoFrame,        /// logo区域参数
        CGRect sloganFrame,      /// slogan参数
        CGRect numberFrame,      /// 号码处参数
        CGRect loginFrame,       /// 登录按钮处的参数
        CGRect changeBtnFrame,   /// 切换到其他的参数
        CGRect privacyFrame      /// 协议区域的参数
      ) {
        NSUInteger count = customArrayView.count;
        NSInteger contentWidth = screenSize.width;
        for (int i = 0 ; i < count; i++) {
          UIButton *itemView = (UIButton *)customArrayView[i];
          NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          itemView.frame = CGRectMake( X, offsetY, itemView.frame.size.width, itemView.frame.size.height );
        }
      };
    }
  }
  /// 自定义第三方按钮布局 END
  
  /// 背景设置 START
  NSString * backgroundColor = [viewConfig stringValueForKey: @"backgroundColor" defaultValue: nil];
  if (![backgroundColor isEqual: nil]) {
    model.backgroundColor = [self getColor: backgroundColor];
  }
  NSString * backgroundImagePath = [viewConfig stringValueForKey: @"backgroundPath" defaultValue: nil];
  if (![backgroundImagePath isEqual: nil]) {
    model.backgroundImage = [self changeUriPathToImage: backgroundImagePath];
  }
  /// 背景设置 END
  
  return model;
}
#pragma mark - 全屏-横屏
+ (TXCustomModel *)buildFullScreenLandscapeModel:(NSDictionary *)dict
                                                         target:(id)target
                                                       selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 15 + 80 + 15;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20;
        return frame;
    };
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button1 setTitle:button1Title forState:UIControlStateNormal];
//    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setTitle:button2Title forState:UIControlStateNormal];
//    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:button1];
//        [superCustomView addSubview:button2];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                   CGRectGetMaxY(loginFrame) + 20,
//                                   CGRectGetWidth(loginFrame) * 0.5,
//                                   30);
//
//        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
//                                   CGRectGetMinY(button1.frame),
//                                   CGRectGetWidth(loginFrame) * 0.5,
//                                   30);
//    };
    return model;
}

#pragma mark - 弹窗-竖屏
+ (TXCustomModel *)buildAlertPortraitMode:(NSDictionary *)viewConfig
                                                  target:(id)target
                                                selector:(SEL)selector {
  TXCustomModel *model = [[TXCustomModel alloc] init];
  
  // 1状态栏START
  model.prefersStatusBarHidden = [viewConfig boolValueForKey: @"isStatusBarHidden" defaultValue: NO];
  bool isLightColor = [viewConfig boolValueForKey: @"lightColor" defaultValue: NO];
  model.preferredStatusBarStyle = isLightColor ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
  // 1状态栏ENd
  
  model.alertBarIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
  model.alertTitleBarColor = [self getColor: [viewConfig stringValueForKey: @"alertTitleBarColor" defaultValue: @"#3971fe"]];
  model.alertTitle = [
    [NSAttributedString alloc]
      initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
          attributes: @{
            NSForegroundColorAttributeName: UIColor.whiteColor,
            NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
          }
  ];;
  model.alertCloseItemIsHidden = [viewConfig boolValueForKey: @"alertCloseItemIsHidden" defaultValue: NO];
  
  UIImage * alertCloseImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"alertCloseImage" defaultValue: nil]];
  model.alertCloseImage = alertCloseImage?:[UIImage imageNamed:@"icon_close_light"];
  
  model.alertCloseItemFrameBlock = ^CGRect(CGSize screenSize,CGSize superViewSize,CGRect frame) {
        if ([self isHorizontal:screenSize]) {
          //横屏时模拟隐藏该控件
          return CGRectZero;
        } else {
          frame.origin.x = [viewConfig intValueForKey: @"alertCloseImageX" defaultValue: 5];
          frame.origin.y = [viewConfig intValueForKey: @"alertCloseImageY" defaultValue: 5];
          frame.size.width = [viewConfig intValueForKey: @"alertCloseImageW" defaultValue: 30];
          frame.size.height = [viewConfig intValueForKey: @"alertCloseImageH" defaultValue: 30];
          return frame;
        }
  };
  
  model.alertBlurViewColor = [self getColor: [viewConfig stringValueForKey: @"alertBlurViewColor" defaultValue: @"#000000"]];
  model.alertBlurViewAlpha = [viewConfig floatValueForKey: @"dialogAlpha" defaultValue: 0.5];
  NSArray *alertCornerRadiusArray = [viewConfig arrayValueForKey: @"dialogCornerRadiusArray" defaultValue: @[@10, @10, @10, @10]];
  model.alertCornerRadiusArray = alertCornerRadiusArray;
      
  /// 协议页面导航设置
  model.privacyNavColor =  [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#000000"]];
  UIImage * privacyNavBackImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"webNavReturnImgPath" defaultValue: nil]];
  if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
  }
  model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];
  
  /// logo 设置 START
  model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: NO];
  UIImage * image = [self changeUriPathToImage: [viewConfig stringValueForKey: @"logoImgPath" defaultValue: nil]];
  if(image != nil){
    /// logo 默认水平居中
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      frame.size.width = [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80];
      frame.size.height = [viewConfig floatValueForKey: @"logoHeight" defaultValue: 80];
      frame.origin.y = [viewConfig floatValueForKey: @"logoOffsetY" defaultValue: screenSize.height > screenSize.width ? 30 : 15];
      frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80]) * 0.5;
      return frame;
    };
    model.logoImage = image;
  }
  /// logo 设置 END
  
  /// slogan 设置 START
  model.sloganIsHidden = [viewConfig boolValueForKey: @"sloganHidden" defaultValue: NO];
  model.sloganText = [
    [NSAttributedString alloc]
    initWithString: [viewConfig stringValueForKey: @"sloganText" defaultValue: @"一键登录欢迎语"]
        attributes: @{
         NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555555"]],
         NSFontAttributeName: [
            UIFont systemFontOfSize: [viewConfig floatValueForKey: @"sloganTextSize" defaultValue: 19]
         ]
        }
  ];
  model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if (screenSize.height > screenSize.width) {
      frame.origin.y = [viewConfig floatValueForKey: @"sloganOffsetY" defaultValue: 20 + 80 + 20];
      return frame;
    } else {
      return CGRectZero;
    }
  };
  /// slogan 设置 END
  
  /// number 设置 START
  model.numberColor = [self getColor: [viewConfig stringValueForKey: @"numberColor" defaultValue: @"#555"]];
  model.numberFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"numberSize" defaultValue: 17]];
  model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.origin.y = [viewConfig floatValueForKey: @"numFieldOffsetY" defaultValue: 130 + 20 + 15];
      } else {
        frame.origin.y = 15 + 80 + 15;
      }
      return frame;
  };
  /// number 设置 END
  
  /// 登录按钮 START
  model.loginBtnText = [
    [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"logBtnText" defaultValue: @"一键登录欢迎语"]
            attributes: @{
              NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"logBtnTextColor" defaultValue: @"#ff00ff"]],
              NSFontAttributeName: [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"logBtnTextSize" defaultValue: 23]]
            }
  ];
  NSArray *logBtnCustomBackgroundImagePath = [[viewConfig stringValueForKey: @"logBtnBackgroundPath" defaultValue: @","] componentsSeparatedByString:@","];
  if (logBtnCustomBackgroundImagePath.count == 3) {
    // login_btn_normal
    UIImage * login_btn_normal = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[0]];
    // login_btn_unable
    UIImage * login_btn_unable = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[1]];
    // login_btn_press
    UIImage * login_btn_press = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[2]];
    // default
    UIImage *defaultClick = [UIImage imageNamed:@"button_click"];
    UIImage *defaultUnClick = [UIImage imageNamed:@"button_unclick"];
    // fix '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
    if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && defaultUnClick != nil)) {
      // 登录按钮设置
      model.loginBtnBgImgs = @[
        login_btn_normal?:defaultClick,
        login_btn_unable?:defaultUnClick,
        login_btn_press?:defaultClick
      ];
    }
  }
  model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.size.width = [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300];
        frame.size.height = [viewConfig floatValueForKey: @"logBtnHeight" defaultValue: 40];
        frame.origin.y = [viewConfig floatValueForKey: @"logBtnOffsetY" defaultValue: 170 + 30 + 20];
        frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300]) * 0.5;
      } else {
        frame.origin.y = 110 + 30 + 20;
      }
      return frame;
  };
  /// 登录按钮 END
  model.privacyOne = @[
    [viewConfig stringValueForKey: @"protocolOneName" defaultValue: @""],
    [viewConfig stringValueForKey: @"protocolOneURL" defaultValue: @""]
  ];
  model.privacyTwo = @[
    [viewConfig stringValueForKey: @"protocolTwoName" defaultValue: @""],
    [viewConfig stringValueForKey: @"protocolTwoURL" defaultValue: @""]
  ];
  model.privacyThree = @[
    [viewConfig stringValueForKey: @"protocolThreeName" defaultValue: @""],
    [viewConfig stringValueForKey: @"protocolThreeURL" defaultValue: @""]
  ];
  NSArray *privacyColors = [[viewConfig stringValueForKey: @"appPrivacyColor" defaultValue: nil] componentsSeparatedByString:@","];
  if(privacyColors != nil && privacyColors.count > 1){
    model.privacyColors = @[
      [self getColor: privacyColors[0]],
      [self getColor: privacyColors[1]]
    ];
  }

  model.privacyAlertContentUnderline = [viewConfig boolValueForKey: @"privacyAlertProtocolNameUseUnderLine" defaultValue: NO];
  // 协议1内容颜色
  model.privacyOneColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnOneColor" defaultValue: @"#000000"]];
  // 协议2内容颜色
  model.privacyTwoColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnTwoColor" defaultValue: @"#000000"]];
  // 协议3内容颜色
  model.privacyThreeColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnThreeColor" defaultValue: @"#000000"]];
  // 运营商协议内容颜色
  model.privacyOperatorColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnColor" defaultValue: @"#000000"]];
  
  // 二次协议1内容颜色
  model.privacyAlertOneColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnOneColor" defaultValue: @"#000000"]];
  // 二次协议2内容颜色
  model.privacyAlertTwoColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnTwoColor" defaultValue: @"#000000"]];
  // 二次协议3内容颜色
  model.privacyAlertThreeColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnThreeColor" defaultValue: @"#000000"]];
  // 二次运营商协议内容颜色
  model.privacyAlertOperatorColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOperatorColor" defaultValue: @"#000000"]];
  
  model.privacyAlignment = [viewConfig intValueForKey: @"protocolLayoutGravity" defaultValue: 1];
  model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 12.0]];
  model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"点击一键登录并登录表示您已阅读并同意"];
  model.privacySufText = [viewConfig stringValueForKey: @"privacyEnd" defaultValue: @"思预云用户协议，隐私"];
  model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
  model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];
  /// 协议水平垂直设置
  model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.y = [viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1];
    }
    if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.x = [viewConfig floatValueForKey: @"privacyOffsetX" defaultValue: -1];
    }
    return frame;
  };
  
  // 勾选统一按钮
  BOOL checkStatus = [viewConfig boolValueForKey: @"checkboxHidden" defaultValue: NO];
  model.checkBoxIsHidden = checkStatus;
  if (!checkStatus) {
    UIImage* unchecked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"uncheckedImgPath" defaultValue: nil]];
    UIImage* checked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"checkedImgPath" defaultValue: nil]];
    if (unchecked != nil && checked != nil) {
      model.checkBoxImages = @[
        unchecked,
        checked
      ];
    }
  }
  model.checkBoxIsChecked = [viewConfig boolValueForKey: @"privacyState" defaultValue: NO];
  model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxHeight" defaultValue: 17.0];
  
  // 切换到其他标题
  model.changeBtnIsHidden = [viewConfig boolValueForKey: @"switchAccHidden" defaultValue: NO];
  model.changeBtnTitle = [
     [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"switchAccText" defaultValue: @"切换到其他方式"]
     attributes: @{
       NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"switchAccTextColor" defaultValue: @"#ccc"]],
       NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"switchAccTextSize" defaultValue: 18]]
     }
  ];
  model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if (screenSize.height > screenSize.width) {
      return CGRectMake(10, [viewConfig floatValueForKey: @"switchOffsetY" defaultValue: 18], superViewSize.width - 20, 30);
    } else {
      return CGRectZero; //横屏时模拟隐藏该控件
    }
  };
  
  /// 点击授权页背景是否关闭授权页，只有在弹窗模式下生效，默认NO
  model.tapAuthPageMaskClosePage=[viewConfig boolValueForKey: @"tapAuthPageMaskClosePage" defaultValue: NO];
  /// 页面弹出方向 START
  model.presentDirection = [viewConfig intValueForKey: @"presentDirection" defaultValue: 0];
  /// 页面弹出方向 END
  
  CGFloat ratio = MAX(TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT) / 667.0;
  //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
  model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
      CGFloat alertX = 0;
      CGFloat alertY = 0;
      CGFloat alertWidth = 0;
      CGFloat alertHeight = 0;
      if ([self isHorizontal:screenSize]) {
        alertX = ratio * TX_Alert_Horizontal_Default_Left_Padding;
        alertWidth = [viewConfig intValueForKey: @"dialogWidth" defaultValue: screenSize.width - alertX * 2];
        alertY = (screenSize.height - alertWidth * 0.5) * 0.5;
        alertHeight = [viewConfig intValueForKey: @"dialogHeight" defaultValue: screenSize.height - 2 * alertY];
      } else {
        alertWidth = [viewConfig intValueForKey: @"dialogWidth" defaultValue: screenSize.width / 2];
        alertHeight = [viewConfig intValueForKey: @"dialogHeight" defaultValue: screenSize.height / 2];
        alertX = [viewConfig intValueForKey: @"dialogOffsetX" defaultValue: (TX_SCREEN_WIDTH - alertWidth) / 2];
        alertY = [viewConfig intValueForKey: @"dialogOffsetY" defaultValue: (TX_SCREEN_HEIGHT - alertHeight) / 2];
      }
      return CGRectMake(alertX, alertY, alertWidth, alertHeight);
  };
  
  //授权页默认控件布局调整
  
  /// 自定义第三方按钮布局 START
  NSDictionary *customThirdView = [viewConfig dictValueForKey: @"customThirdView" defaultValue: nil];
  if (customThirdView != nil) {
    NSMutableArray * customArrayView = [NSMutableArray array]; /// 空数组，有意义
    NSArray * customArray = [customThirdView arrayValueForKey: @"viewItemPath" defaultValue: nil]; //空数组，有意义
    NSArray * customNameArray = [customThirdView arrayValueForKey: @"viewItemName" defaultValue: nil]; //空数组，有意义
    if(customArray != nil && customArray.count > 0){
      /// 第三方图标按钮的相关参数
      int width = [customThirdView intValueForKey: @"itemWidth" defaultValue: 50];
      int height = [customThirdView intValueForKey: @"itemHeight" defaultValue: 50];
      int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
      int textSize = [customThirdView intValueForKey: @"size" defaultValue: 20];
      int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
      NSString* color = [customThirdView stringValueForKey: @"color" defaultValue: @"#3c4E5F"];
      for (int i = 0 ; i < customArray.count; i++) {
        /// 动态生成imageView 并且加入到 imageView数组中以备使用
        CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize: textSize];
        [button setTag: i];
        [button setTitle: customNameArray[i] forState:UIControlStateNormal];
        [button setTitleColor: [self getColor: color] forState:UIControlStateNormal];
        [button setBackgroundImage:[self changeUriPathToImage: customArray[i]] forState:UIControlStateNormal];
        [button addTarget:target action: selector forControlEvents:UIControlEventTouchUpInside];
    
        [customArrayView addObject: button];
      }
      
      /// 添加第三方图标
      model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        for (int i = 0 ; i < customArrayView.count; i++) {
          [superCustomView addSubview: customArrayView[i]];
        }
        
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"触屏拍摄" forState:UIControlStateNormal];
////        UIImage *img = [self changeUriPathToImage: customArray[0]];
////        [btn setImage:img forState:UIControlStateNormal];//button的填充图片
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn.imageEdgeInsets = UIEdgeInsetsMake(- (btn.frame.size.height - btn.titleLabel.frame.size.height- btn.titleLabel.frame.origin.y),(btn.frame.size.width -btn.titleLabel.frame.size.width)/2.0f -btn.imageView.frame.size.width, 0, 0);
//        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.frame.size.height-btn.imageView.frame.size.height-btn.imageView.frame.origin.y, -btn.imageView.frame.size.width, 0, 0);
//        [superCustomView addSubview: btn];
//        btn.frame = CGRectMake( 10, 50, 300, 200 );
        
//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAllScreen:)];
//        [superCustomView addGestureRecognizer:singleTap];
      };
      
      model.customViewLayoutBlock = ^(
        CGSize screenSize,       /// 全屏参数
        CGRect contentViewFrame, /// contentView参数
        CGRect navFrame,         /// 导航参数
        CGRect titleBarFrame,    /// title参数
        CGRect logoFrame,        /// logo区域参数
        CGRect sloganFrame,      /// slogan参数
        CGRect numberFrame,      /// 号码处参数
        CGRect loginFrame,       /// 登录按钮处的参数
        CGRect changeBtnFrame,   /// 切换到其他的参数
        CGRect privacyFrame      /// 协议区域的参数
      ) {
        NSUInteger count = customArrayView.count;
        NSInteger contentWidth = contentViewFrame.size.width;
        for (int i = 0; i < count; i++) {
          UIButton *itemView = (UIButton *)customArrayView[i];
          NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          itemView.frame = CGRectMake( X, offsetY, width, height );
        }
      };
    }
  }
  /// 自定义第三方按钮布局 END
  

  /// 背景设置 START
  NSString * backgroundColor = [viewConfig stringValueForKey: @"backgroundColor" defaultValue: nil];
  if (![backgroundColor isEqual: nil]) {
    model.backgroundColor = [self getColor: backgroundColor];
  }
  NSString * backgroundImagePath = [viewConfig stringValueForKey: @"pageBackgroundPath" defaultValue: nil];
  if (![backgroundImagePath isEqual: nil]) {
    model.backgroundImage = [self changeUriPathToImage: backgroundImagePath];
  }
  /// 背景设置 END
  return model;
}
#pragma mark - 弹窗-横屏
+ (TXCustomModel *)buildAlertLandscapeMode:(NSDictionary *)dict
                                                   target:(id)target
                                                 selector:(SEL)selector{
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoIsHidden = YES;
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.height = superViewSize.height * 0.8;
        frame.size.width = frame.size.height / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30 + 20 + 30;
        return frame;
    };
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button1 setTitle:button1Title forState:UIControlStateNormal];
//    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setTitle:button2Title forState:UIControlStateNormal];
//    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
//
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:button1];
//        [superCustomView addSubview:button2];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                   CGRectGetMaxY(loginFrame) + 20,
//                                   CGRectGetWidth(loginFrame) * 0.5,
//                                   30);
//
//        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
//                                   CGRectGetMinY(button1.frame),
//                                   CGRectGetWidth(loginFrame) * 0.5,
//                                   30);
//    };
    return model;
}

#pragma mark - 底部弹窗
+ (TXCustomModel *)buildSheetPortraitModel:(NSDictionary *)viewConfig
                                                   target:(id)target
                                                 selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @0, @0, @10];
  
    // 1状态栏START
    model.prefersStatusBarHidden = [viewConfig boolValueForKey: @"isStatusBarHidden" defaultValue: NO];
    bool isLightColor = [viewConfig boolValueForKey: @"lightColor" defaultValue: NO];
    model.preferredStatusBarStyle = isLightColor ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    // 1状态栏ENd
    
    model.alertBarIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
    model.alertTitleBarColor = [self getColor: [viewConfig stringValueForKey: @"alertTitleBarColor" defaultValue: @"#3971fe"]];
    model.alertTitle = [
      [NSAttributedString alloc]
        initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
            attributes: @{
              NSForegroundColorAttributeName: UIColor.whiteColor,
              NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
            }
    ];;
  
    /// 关闭按钮
    model.alertCloseItemIsHidden = [viewConfig boolValueForKey: @"alertCloseItemIsHidden" defaultValue: NO];
    UIImage * alertCloseImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"alertCloseImage" defaultValue: nil]];
    model.alertCloseImage = alertCloseImage?:[UIImage imageNamed:@"icon_close_light"];
    model.alertCloseItemFrameBlock = ^CGRect(CGSize screenSize,CGSize superViewSize,CGRect frame) {
        if ([self isHorizontal:screenSize]) {
          //横屏时模拟隐藏该控件
          return CGRectZero;
        } else {
          frame.origin.x = [viewConfig intValueForKey: @"alertCloseImageX" defaultValue: 5];
          frame.origin.y = [viewConfig intValueForKey: @"alertCloseImageY" defaultValue: 5];
          frame.size.width = [viewConfig intValueForKey: @"alertCloseImageW" defaultValue: 30];
          frame.size.height = [viewConfig intValueForKey: @"alertCloseImageH" defaultValue: 30];
          return frame;
        }
    };
    /// 关闭按钮
  
    /// 3logo 设置 START
    model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: NO];
    UIImage * image = [self changeUriPathToImage: [viewConfig stringValueForKey: @"logoImgPath" defaultValue: nil]];
    if(image != nil){
      /// logo 默认水平居中
      model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80];
        frame.size.height = [viewConfig floatValueForKey: @"logoHeight" defaultValue: 80];
        frame.origin.y = [viewConfig floatValueForKey: @"logoOffsetY" defaultValue: screenSize.height > screenSize.width ? 30 : 15];
        frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logoWidth" defaultValue: 80]) * 0.5;
        return frame;
      };
      model.logoImage = image;
    }
    /// 3logo 设置 END
  
    /// 4slogan 设置 START
    model.sloganIsHidden = [viewConfig boolValueForKey: @"sloganHidden" defaultValue: NO];
    model.sloganText = [
      [NSAttributedString alloc]
      initWithString: [viewConfig stringValueForKey: @"sloganText" defaultValue: @"一键登录欢迎语"]
          attributes: @{
           NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555555"]],
           NSFontAttributeName: [
              UIFont systemFontOfSize: [viewConfig floatValueForKey: @"sloganTextSize" defaultValue: 19]
           ]
          }
    ];
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.origin.y = [viewConfig floatValueForKey: @"sloganOffsetY" defaultValue: 20 + 80 + 20];
        return frame;
      } else {
        return CGRectZero;
      }
    };
    /// 4slogan 设置 END
  
    /// 5number 设置 START
    model.numberColor = [self getColor: [viewConfig stringValueForKey: @"numberColor" defaultValue: @"#555"]];
    model.numberFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"numberSize" defaultValue: 17]];
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
          frame.origin.y = [viewConfig floatValueForKey: @"numFieldOffsetY" defaultValue: 130 + 20 + 15];
        } else {
          frame.origin.y = 15 + 80 + 15;
        }
        return frame;
    };
    /// 5number 设置 END
  
    /// 6登录按钮 START
    model.loginBtnText = [
      [NSAttributedString alloc]
          initWithString: [viewConfig stringValueForKey: @"logBtnText" defaultValue: @"一键登录欢迎语"]
              attributes: @{
                NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"logBtnTextColor" defaultValue: @"#ff00ff"]],
                NSFontAttributeName: [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"logBtnTextSize" defaultValue: 23]]
              }
    ];
    NSArray *logBtnCustomBackgroundImagePath = [[viewConfig stringValueForKey: @"logBtnBackgroundPath" defaultValue: @","] componentsSeparatedByString:@","];
    if (logBtnCustomBackgroundImagePath.count == 3) {
      // login_btn_normal
      UIImage * login_btn_normal = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[0]];
      // login_btn_unable
      UIImage * login_btn_unable = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[1]];
      // login_btn_press
      UIImage * login_btn_press = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[2]];
      // default
      UIImage *defaultClick = [UIImage imageNamed:@"button_click"];
      UIImage *defaultUnClick = [UIImage imageNamed:@"button_unclick"];
      // fix '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
      if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && defaultUnClick != nil)) {
        // 登录按钮设置
        model.loginBtnBgImgs = @[
          login_btn_normal?:defaultClick,
          login_btn_unable?:defaultUnClick,
          login_btn_press?:defaultClick
        ];
      }
    }
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
          frame.size.width = [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300];
          frame.size.height = [viewConfig floatValueForKey: @"logBtnHeight" defaultValue: 40];
          frame.origin.y = [viewConfig floatValueForKey: @"logBtnOffsetY" defaultValue: 170 + 30 + 20];
          frame.origin.x = (superViewSize.width - [viewConfig floatValueForKey: @"logBtnWidth" defaultValue: 300]) * 0.5;
        } else {
          frame.origin.y = 110 + 30 + 20;
        }
        return frame;
    };
    /// 6登录按钮 END
  
    /// 7切换到其他标题 START
    model.changeBtnIsHidden = ![viewConfig boolValueForKey: @"switchAccHidden" defaultValue: NO];
    model.changeBtnTitle = [
       [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"switchAccText" defaultValue: @"切换到其他方式"]
       attributes: @{
         NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"switchAccTextColor" defaultValue: @"#ccc"]],
         NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"switchAccTextSize" defaultValue: 18]]
       }
    ];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        return CGRectMake(10, [viewConfig floatValueForKey: @"switchOffsetY" defaultValue: frame.origin.y], superViewSize.width - 20, 30);
      } else {
        return CGRectZero; //横屏时模拟隐藏该控件
      }
    };
    /// 7切换到其他标题 END

    /// 8自定义第三方按钮布局 START
    NSDictionary *customThirdView = [viewConfig dictValueForKey: @"customThirdView" defaultValue: nil];
    if (customThirdView != nil) {
      NSMutableArray * customArrayView = [NSMutableArray array]; /// 空数组，有意义
      NSArray * customArray = [customThirdView arrayValueForKey: @"viewItemPath" defaultValue: nil]; //空数组，有意义
      NSArray * customNameArray = [customThirdView arrayValueForKey: @"viewItemName" defaultValue: nil]; //空数组，有意义
      if(customArray != nil && customArray.count > 0){
        /// 第三方图标按钮的相关参数
        int width = [customThirdView intValueForKey: @"itemWidth" defaultValue: 50];
        int height = [customThirdView intValueForKey: @"itemHeight" defaultValue: 50];
        int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
        int textSize = [customThirdView intValueForKey: @"size" defaultValue: 20];
        int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
        NSString* color = [customThirdView stringValueForKey: @"color" defaultValue: @"#3c4E5F"];
        for (int i = 0 ; i < customArray.count; i++) {
          /// 动态生成imageView 并且加入到 imageView数组中以备使用
          CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
          button.titleLabel.textAlignment = NSTextAlignmentCenter;
          button.titleLabel.font = [UIFont systemFontOfSize: textSize];
          [button setTag: i];
          [button setTitle: customNameArray[i] forState:UIControlStateNormal];
          [button setTitleColor: [self getColor: color] forState:UIControlStateNormal];
          [button setBackgroundImage:[self changeUriPathToImage: customArray[i]] forState:UIControlStateNormal];
          [button addTarget:target action: selector forControlEvents:UIControlEventTouchUpInside];
      
          [customArrayView addObject: button];
        }
        
        /// 添加第三方图标
        model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
          for (int i = 0 ; i < customArrayView.count; i++) {
            [superCustomView addSubview: customArrayView[i]];
          }
        };
        
        model.customViewLayoutBlock = ^(
          CGSize screenSize,       /// 全屏参数
          CGRect contentViewFrame, /// contentView参数
          CGRect navFrame,         /// 导航参数
          CGRect titleBarFrame,    /// title参数
          CGRect logoFrame,        /// logo区域参数
          CGRect sloganFrame,      /// slogan参数
          CGRect numberFrame,      /// 号码处参数
          CGRect loginFrame,       /// 登录按钮处的参数
          CGRect changeBtnFrame,   /// 切换到其他的参数
          CGRect privacyFrame      /// 协议区域的参数
        ) {
          NSUInteger count = customArrayView.count;
          NSInteger contentWidth = contentViewFrame.size.width;
          for (int i = 0; i < count; i++) {
            UIButton *itemView = (UIButton *)customArrayView[i];
            NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
            itemView.frame = CGRectMake( X, offsetY, width, height );
          }
        };
      }
    }
    /// 8自定义第三方按钮布局 END
  
    /// 9勾选统一按钮 START
    BOOL checkStatus = [viewConfig boolValueForKey: @"checkboxHidden" defaultValue: NO];
    model.checkBoxIsHidden = checkStatus;
    if (!checkStatus) {
      UIImage* unchecked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"uncheckedImgPath" defaultValue: nil]];
      UIImage* checked = [self changeUriPathToImage: [viewConfig stringValueForKey: @"checkedImgPath" defaultValue: nil]];
      if (unchecked != nil && checked != nil) {
        model.checkBoxImages = @[
          unchecked,
          checked
        ];
      }
    }
    model.checkBoxIsChecked = [viewConfig boolValueForKey: @"privacyState" defaultValue: NO];
    model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxHeight" defaultValue: 17.0];
    /// 9勾选统一按钮 END
    ///
    model.privacyOne = [[viewConfig stringValueForKey: @"appPrivacyOne" defaultValue: nil] componentsSeparatedByString:@","];
    model.privacyTwo = [[viewConfig stringValueForKey: @"appPrivacyTwo" defaultValue: nil] componentsSeparatedByString:@","];
    NSArray *privacyColors = [[viewConfig stringValueForKey: @"appPrivacyColor" defaultValue: nil] componentsSeparatedByString:@","];
    if(privacyColors != nil && privacyColors.count > 1){
      model.privacyColors = @[
        [self getColor: privacyColors[0]],
        [self getColor: privacyColors[1]]
      ];
    }

    model.privacyAlertContentUnderline = [viewConfig boolValueForKey: @"privacyAlertProtocolNameUseUnderLine" defaultValue: NO];
    // 协议1内容颜色
    model.privacyOneColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnOneColor" defaultValue: @"#000000"]];
    // 协议2内容颜色
    model.privacyTwoColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnTwoColor" defaultValue: @"#000000"]];
    // 协议3内容颜色
    model.privacyThreeColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnThreeColor" defaultValue: @"#000000"]];
    // 运营商协议内容颜色
    model.privacyOperatorColor = [self getColor: [viewConfig stringValueForKey: @"protocolOwnColor" defaultValue: @"#000000"]];
    
    // 二次协议1内容颜色
    model.privacyAlertOneColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnOneColor" defaultValue: @"#000000"]];
    // 二次协议2内容颜色
    model.privacyAlertTwoColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnTwoColor" defaultValue: @"#000000"]];
    // 二次协议3内容颜色
    model.privacyAlertThreeColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOwnThreeColor" defaultValue: @"#000000"]];
    // 二次运营商协议内容颜色
    model.privacyAlertOperatorColor = [self getColor: [viewConfig stringValueForKey: @"privacyAlertOperatorColor" defaultValue: @"#000000"]];
    
    model.privacyAlignment = [viewConfig intValueForKey: @"protocolLayoutGravity" defaultValue: 1];;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 12.0]];
    model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"点击一键登录并登录表示您已阅读并同意"];
    model.privacySufText = [viewConfig stringValueForKey: @"privacyEnd" defaultValue: @"思预云用户协议，隐私"];
    model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
    model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];
    /// 协议水平垂直设置
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
        frame.origin.y = [viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1];
      }
      if ([viewConfig floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
        frame.origin.x = [viewConfig floatValueForKey: @"privacyOffsetX" defaultValue: -1];
      }
      return frame;
    };
    /// 协议
  
  
    /// 协议页面导航设置
    model.privacyNavColor =  [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#000000"]];
    UIImage * privacyNavBackImage = [self changeUriPathToImage: [viewConfig stringValueForKey: @"webNavReturnImgPath" defaultValue: nil]];
    if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
    }
    model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
    model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];

  
    /// 授权页面配置
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = [viewConfig floatValueForKey: @"dialogHeight" defaultValue: 460];
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };
  
    /// 点击授权页背景是否关闭授权页，只有在弹窗模式下生效，默认NO
    model.tapAuthPageMaskClosePage=[viewConfig boolValueForKey: @"tapAuthPageMaskClosePage" defaultValue: NO];
    
    /// 背景设置 START
    NSString * backgroundColor = [viewConfig stringValueForKey: @"backgroundColor" defaultValue: nil];
    if (![backgroundColor isEqual: nil]) {
      model.backgroundColor = [self getColor: backgroundColor];
    }
    NSString * backgroundImagePath = [viewConfig stringValueForKey: @"pageBackgroundPath" defaultValue: nil];
    if (![backgroundImagePath isEqual: nil]) {
      model.backgroundImage = [self changeUriPathToImage: backgroundImagePath];
    }
    /// 背景设置 END
    return model;
}

#pragma mark - other
+ (TXCustomModel *)buildVideoOrGifBackgroundModel:(NSDictionary *)viewConfig
                                           target:(id)target
                                            style:(PNSBuildModelStyle)style
                                         selector:(SEL)selector {
  return [self buildModelOption: viewConfig target:target style: style selector:selector];
}

#pragma mark - DIY 动画
+ (TXCustomModel *)buildAlertFadeModel:(NSDictionary *)dict
                                               target:(id)target
                                             selector:(SEL)selector {
    
    TXCustomModel *model = [self buildAlertPortraitMode:dict
                                                                target:target
                                                              selector:selector];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @1.03;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    //背景本身就是渐变，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildAlertBounceModel:(NSDictionary *)dict
                                                 target:(id)target
                                               selector:(SEL)selector {
    
    TXCustomModel *model = [self buildAlertPortraitMode:dict
                                                                target:target
                                                              selector:selector];
    
    CAKeyframeAnimation *entryAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.values = @[@0.01, @1.2, @0.9, @1];
    entryAnimation.keyTimes = @[@0, @0.4, @0.6, @1];
    entryAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    entryAnimation.duration = 0.25;
    model.entryAnimation = entryAnimation;
    
    CAKeyframeAnimation *exitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.values = @[@1, @1.2, @0.01];
    exitAnimation.keyTimes = @[@0, @0.4, @1];
    exitAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    exitAnimation.duration = 0.25;
    model.exitAnimation = exitAnimation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildFullScreenAutorotateModel:(NSDictionary *)dict
                                                          target:(id)target
                                                        selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
  
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = screenSize.height > screenSize.width ? 30 : 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = superViewSize.width - 40;
            frame.size.height = 20;
            frame.origin.x = 20;
            frame.origin.y = 20 + 80 + 20;
            return frame;
        } else {
            return CGRectZero;
        }
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 130 + 20 + 15;
        } else {
            frame.origin.y = 15 + 80 + 15;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 170 + 30 + 20;
        } else {
            frame.origin.y = 110 + 30 + 20;
        }
        return frame;
    };
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button1 setTitle:button1Title forState:UIControlStateNormal];
//    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setTitle:button2Title forState:UIControlStateNormal];
//    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:button1];
//        [superCustomView addSubview:button2];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        if (screenSize.height > screenSize.width) {
//            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(loginFrame) + 20,
//                                       CGRectGetWidth(loginFrame),
//                                       30);
//
//            button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(button1.frame) + 15,
//                                       CGRectGetWidth(loginFrame),
//                                       30);
//        } else {
//            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(loginFrame) + 20,
//                                       CGRectGetWidth(loginFrame) * 0.5,
//                                       30);
//
//            button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
//                                       CGRectGetMinY(button1.frame),
//                                       CGRectGetWidth(loginFrame) * 0.5,
//                                       30);
//        }
//    };
    return model;
}

+ (TXCustomModel *)buildAlertAutorotateMode:(NSDictionary *)dict
                                                    target:(id)target
                                                  selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
  
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"自定义协议", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = superViewSize.width * 0.8;
            frame.size.height = frame.size.width / 0.618;
        } else {
            frame.size.height = superViewSize.height * 0.8;
            frame.size.width = frame.size.height / 0.618;
        }
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = 80;
            frame.size.height = 80;
            frame.origin.y = 20;
            frame.origin.x = (superViewSize.width - 80) * 0.5;
        } else {
            frame = CGRectZero;
        }
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.height = 20;
            frame.size.width = superViewSize.width - 40;
            frame.origin.x = 20;
            frame.origin.y = 20 + 80 + 20;
        } else {
            frame = CGRectZero;
        }
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 120 + 20 + 15;
        } else {
            frame.origin.y = 30;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 155 + 20 + 30;
        } else {
            frame.origin.y = 30 + 20 + 30;
        }
        return frame;
    };
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button1 setTitle:button1Title forState:UIControlStateNormal];
//    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setTitle:button2Title forState:UIControlStateNormal];
//    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
//
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:button1];
//        [superCustomView addSubview:button2];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        if (screenSize.height > screenSize.width) {
//            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(loginFrame) + 20,
//                                       CGRectGetWidth(loginFrame),
//                                       30);
//
//            button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(button1.frame) + 15,
//                                       CGRectGetWidth(loginFrame),
//                                       30);
//        } else {
//            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                       CGRectGetMaxY(loginFrame) + 20,
//                                       CGRectGetWidth(loginFrame) * 0.5,
//                                       30);
//
//            button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
//                                       CGRectGetMinY(button1.frame),
//                                       CGRectGetWidth(loginFrame) * 0.5,
//                                       30);
//        }
//    };
    return model;
}

+ (TXCustomModel *)buildAlertDropDownModel:(NSDictionary *)dict
                                                   target:(id)target
                                                 selector:(SEL)selector {
    
    TXCustomModel *model = [self buildAlertPortraitMode:dict
                                                 target:target
                                               selector:selector];
    
    //提前设置好弹窗大小，弹窗是依赖于全屏布局，所以其父视图大小即为屏幕大小
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.8;
    CGFloat height = width / 0.618;
    CGFloat x = (UIScreen.mainScreen.bounds.size.width - width) * 0.5;
    CGFloat y = (UIScreen.mainScreen.bounds.size.height - height) * 0.5;
    CGRect contentViewFrame = CGRectMake(x, y, width, height);
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return contentViewFrame;
    };
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(-CGRectGetMaxY(contentViewFrame)), @20, @-10, @0];
    animation.keyTimes = @[@0, @0.5, @0.75, @1];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.25;
    model.entryAnimation = animation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildFadeModel:(NSDictionary *)dict
                                          target:(id)target
                                        selector:(SEL)selector {
    
    TXCustomModel *model = [self buildFullScreenPortraitModel:dict
                                                                      target:target
                                                                    selector:selector];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    entryAnimation.fromValue = @0.5;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    return model;
}

+ (TXCustomModel *)buildScaleModel:(NSDictionary *)dict
                                           target:(id)target
                                         selector:(SEL)selector {
    
    TXCustomModel *model = [self buildFullScreenPortraitModel:dict
                                                                      target:target
                                                                    selector:selector];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @0;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    model.exitAnimation = exitAnimation;
    
    return model;
}

#pragma mark  assets -> 自定义图片view
+ (UIImageView *)customView: (NSString *)path
                   selector:(SEL)selector
                     target: (id) target
                      index: (int) index
{
  UIImage * image = [self changeUriPathToImage: path];
  
  /// 自定义布局 图片不支持圆角，如需圆角请使用圆角图片
  UIImageView *imageView = [[UIImageView alloc]init];
  imageView.image = image;
  imageView.tag = index;
  imageView.frame = CGRectMake( 0, 0, 50, 50 );
  /// 设置控件背景颜色
  /// imageView.backgroundColor = [UIColor orangeColor];
  imageView.clipsToBounds = YES;
  /// imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.contentMode = UIViewContentModeScaleToFill;
  /// imageView.contentMode = UIViewContentModeScaleAspectFit;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  
  [imageView addGestureRecognizer:tapGesture];
  imageView.userInteractionEnabled = YES;
  
  return imageView;
}

#pragma mark - build model
+ (TXCustomModel *)buildModelOption:(NSDictionary *)dict
                             target:(id)target
                              style:(PNSBuildModelStyle)style
                           selector:(SEL)selector {
  NSLog(@"%@", dict);
  TXCustomModel *model = [TXCustomModel mj_objectWithKeyValues: dict];
  for (NSString *key in dict) {
    if (key && key.length > 0 && dict[key] != nil) {
      NSString *newKey = [AliAuthEnum keyPair][key]?:key;
      @try {
          /// 分为两种情况数组和字符串
          if ([dict[key] isKindOfClass:[NSArray class]]) {
            NSArray *array = [dict arrayValueForKey: key defaultValue: [NSArray array]];
            // 使用for循环遍历数组
            NSMutableArray *mutableArray = [array mutableCopy];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              // 处理数组中的每个元素，并获取其下标
              // NSLog(@"Item at index %lu: %@", (unsigned long)idx, obj);
              /// 处理图片路径
              if ([key containsString:@"Path"]) {
                mutableArray[idx] = [self changeUriPathToImage: obj];
              } else if ([key containsString:@"Color"]) {
                mutableArray[idx] = [self getColor: obj];
              } else {
                mutableArray[idx] = obj;
              }
            }];
            [model setValue: array forKey:newKey];
          } else {
              /// 处理图片路径
              if ([key containsString:@"Path"]) {
                  /// 为路径时需要转换
                  UIImage *btn = [self changeUriPathToImage: dict[key]];
                  if ([dict[key] containsString:@","]) {
                  } else if ([key isEqual:@"privacyAlertBtnBackgroundImgPath"] && btn != nil) {
                    [model setValue: @[btn, btn] forKey: newKey];
                  } else if (btn != nil) {
                    [model setValue: btn forKey:newKey];
                  }
              } else if ([key containsString:@"Color"]) {
                  if ([key isEqual:@"lightColor"]) {
                    if (@available(iOS 13.0, *)) {
                      // UIStatusBarStyleLightContent Light content, for use on dark backgrounds
                      // UIStatusBarStyleDarkContent Dark content, for use on light backgrounds
                      [model setValue: @([dict boolValueForKey: key defaultValue: NO] ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent) forKey:newKey];
                    } else {
                      [model setValue: @([dict boolValueForKey: key defaultValue: NO] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent) forKey:newKey];
                    }
                  } else {
                    [model setValue: [self getColor: [dict stringValueForKey: key defaultValue: @"#23effe"]] forKey:newKey];
                  }
              } else if ([key containsString:@"Size"]) {
                [model setValue: [UIFont systemFontOfSize: [dict floatValueForKey: key defaultValue: 17]] forKey:newKey];
              } else {
                [model setValue: dict[key] ?: @"" forKey:newKey];
              }
          }
        }
        @catch (NSException *exception) {
            // 捕获并处理异常
            NSLog(@"捕获到异常：%@-%@", key, exception);
        }
        @finally {
            // 无论是否抛出异常，这里的代码都会执行
            // 通常用于清理资源或执行一些必要的收尾工作
            // NSLog(@"执行清理工作");
        }
      }
  }
  // NSLog(@"%@", model);
  #pragma mark 其他配置
  // 判断背景类型
  PNSBackgroundView *backgroundView = nil;
  if (PNSBuildModelStyleGifBackground == style || PNSBuildModelStyleVideoBackground == style) {
    backgroundView = [[PNSBackgroundView alloc] init];
    NSURL *backgroundUrl = [NSURL fileURLWithPath:[self changeUriToPath: [dict stringValueForKey: @"pageBackgroundPath" defaultValue: nil]]];
    backgroundView.gifUrl = [NSURL fileURLWithPath: @""];
    backgroundView.videoUrl = [NSURL fileURLWithPath: @""];
    if (PNSBuildModelStyleGifBackground == style) {
      backgroundView.gifUrl = backgroundUrl;
    } else {
      backgroundView.videoUrl = backgroundUrl;
    }
    [backgroundView show];
  }
  if (PNSDIYAlertPortraitFade == style) 
  {
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @1.03;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
  } 
  else if (PNSDIYAlertPortraitDropDown == style) {
    //提前设置好弹窗大小，弹窗是依赖于全屏布局，所以其父视图大小即为屏幕大小
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.8;
    CGFloat height = width / 0.618;
    CGFloat x = (UIScreen.mainScreen.bounds.size.width - width) * 0.5;
    CGFloat y = (UIScreen.mainScreen.bounds.size.height - height) * 0.5;
    CGRect contentViewFrame = CGRectMake(x, y, width, height);
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return contentViewFrame;
    };
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(-CGRectGetMaxY(contentViewFrame)), @20, @-10, @0];
    animation.keyTimes = @[@0, @0.5, @0.75, @1];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.25;
    model.entryAnimation = animation;
  }
  #pragma mark 0、公共样式
  #pragma mark 1、状态栏
  #pragma mark 2、导航栏
  NSAttributedString *attrs = [
    [NSAttributedString alloc]
      initWithString: [dict stringValueForKey: @"navText" defaultValue: @"一键登录授权页面"]
          attributes: @{
            NSForegroundColorAttributeName: [self getColor: [dict stringValueForKey: @"navTextColor" defaultValue: @"#000000"]],
            NSFontAttributeName : [UIFont systemFontOfSize: [dict floatValueForKey: @"navTextSize" defaultValue: 20.0]]
          }
  ];
  /// 弹窗标题设置不一致
  if (PNSBuildModelStyleAlertPortrait == style || PNSBuildModelStyleAlertLandscape == style || PNSBuildModelStyleSheetPortrait == style){
    model.alertTitle = attrs;
  } else {
    model.navTitle = attrs;
  }
  if (model.navIsHidden) {
    /// 动态读取assets文件夹下的资源
    UIImage * navBackImage = model.navBackImage?:[UIImage imageNamed:@"icon_close_light"];
    model.navBackImage = navBackImage;
    if (!model.hideNavBackItem) {
      /// 自定义返回按钮
      model.navBackButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = navBackImage;
        imageView.frame = CGRectMake(
           CGRectGetMinX(frame),
           CGRectGetMaxY(frame),
           CGRectGetWidth(frame),
           CGRectGetHeight(frame)
         );
        frame.origin.y = [dict floatValueForKey: @"navReturnOffsetY" defaultValue: 5];
        frame.origin.x = [dict floatValueForKey: @"navReturnOffsetX" defaultValue: 15];
        frame.size.width = [dict floatValueForKey: @"navReturnImgWidth" defaultValue: 40];
        frame.size.height = [dict floatValueForKey: @"navReturnImgHeight" defaultValue: 40];
        return frame;
      };
    }
  }
  #pragma mark 3、Logo
  if(!model.logoIsHidden && model.logoImage){
    /// logo 默认水平居中
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      frame.size.width = [dict floatValueForKey: @"logoWidth" defaultValue: 80];
      frame.size.height = [dict floatValueForKey: @"logoHeight" defaultValue: 80];
      frame.origin.y = [dict floatValueForKey: @"logoOffsetY" defaultValue: screenSize.height > screenSize.width ? 30 : 15];
      frame.origin.x = (superViewSize.width - [dict floatValueForKey: @"logoWidth" defaultValue: 80]) * 0.5;
      return frame;
    };
  }
  #pragma mark 4、Slogan
  if (!model.sloganIsHidden) {
    model.sloganText = [
      [NSAttributedString alloc]
      initWithString: [dict stringValueForKey: @"sloganText" defaultValue: @"思预云欢迎您使用一键登录"]
          attributes: @{
           NSForegroundColorAttributeName: [self getColor: [dict stringValueForKey: @"sloganTextColor" defaultValue: @"#555555"]],
           NSFontAttributeName: [
              UIFont systemFontOfSize: [dict floatValueForKey: @"sloganTextSize" defaultValue: 19]
           ]
          }
    ];
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.origin.y = [dict floatValueForKey: @"sloganOffsetY" defaultValue: 20 + 80 + 20];
        return frame;
      } else {
        return CGRectZero;
      }
    };
  }
  #pragma mark 5、掩码栏
  model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.origin.y = [dict floatValueForKey: @"numFieldOffsetY" defaultValue: 130 + 20 + 15];
      } else {
        frame.origin.y = 15 + 80 + 15;
      }
      return frame;
  };
  
  #pragma mark 6、登录按钮
  model.loginBtnText = [
    [NSAttributedString alloc]
        initWithString: [dict stringValueForKey: @"logBtnText" defaultValue: @"一键登录"]
            attributes: @{
              NSForegroundColorAttributeName: [self getColor: [dict stringValueForKey: @"logBtnTextColor" defaultValue: @"#ff00ff"]],
              NSFontAttributeName: [UIFont systemFontOfSize: [dict floatValueForKey: @"logBtnTextSize" defaultValue: 23]]
            }
  ];
  NSArray *logBtnCustomBackgroundImagePath = [[dict stringValueForKey: @"logBtnBackgroundPath" defaultValue: @","] componentsSeparatedByString:@","];
  if (logBtnCustomBackgroundImagePath.count == 3) {
    // login_btn_normal
    UIImage* login_btn_normal = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[0]];
    // login_btn_unable
    UIImage* login_btn_unable = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[1]];
    // login_btn_press
    UIImage* login_btn_press = [self changeUriPathToImage: logBtnCustomBackgroundImagePath[2]];
    UIImage *defaultClick = [UIImage imageNamed:@"button_click"];
    UIImage *defaultUnClick = [UIImage imageNamed:@"button_unclick"];
      // fix '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
    if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && defaultUnClick != nil)) {
      // 登录按钮设置
      model.loginBtnBgImgs = @[
        login_btn_normal?:defaultClick,
        login_btn_unable?:defaultUnClick,
        login_btn_press?:defaultClick
      ];
    }
  }
  model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        frame.size.width = [dict floatValueForKey: @"logBtnWidth" defaultValue: 300];
        frame.size.height = [dict floatValueForKey: @"logBtnHeight" defaultValue: 40];
        frame.origin.y = [dict floatValueForKey: @"logBtnOffsetY" defaultValue: 170 + 30 + 20];
        frame.origin.x = (superViewSize.width - [dict floatValueForKey: @"logBtnWidth" defaultValue: 300]) * 0.5;
      } else {
        frame.origin.y = 110 + 30 + 20;
      }
      return frame;
  };
  #pragma mark 7、切换到其他方式
  if (!model.changeBtnIsHidden) {
    model.changeBtnTitle = [
       [NSAttributedString alloc] initWithString: [dict stringValueForKey: @"switchAccText" defaultValue: @"切换到其他方式"]
       attributes: @{
         NSForegroundColorAttributeName: [self getColor: [dict stringValueForKey: @"switchAccTextColor" defaultValue: @"#555555"]],
         NSFontAttributeName : [UIFont systemFontOfSize: [dict floatValueForKey: @"switchAccTextSize" defaultValue: 18]]
       }
    ];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        return CGRectMake(
          10,
          [dict floatValueForKey: @"switchOffsetY" defaultValue: frame.origin.y],
          superViewSize.width - 20,
          30
        );
      } else {
        return CGRectZero; //横屏时模拟隐藏该控件
      }
    };
  }
  #pragma mark 8、自定义控件区（如其他方式登录）
  NSDictionary *customThirdView = [dict dictValueForKey: @"customThirdView" defaultValue: nil];
  if (customThirdView != nil) {
    NSMutableArray * customArrayView = [NSMutableArray array]; /// 空数组，有意义
    NSArray * customArray = [customThirdView arrayValueForKey: @"viewItemPath" defaultValue: nil]; //空数组，有意义
    NSArray * customNameArray = [customThirdView arrayValueForKey: @"viewItemName" defaultValue: nil]; //空数组，有意义
    if(customArray != nil && customArray.count > 0){
      /// 第三方图标按钮的相关参数
      int width = [customThirdView intValueForKey: @"itemWidth" defaultValue: 70];
      int height = [customThirdView intValueForKey: @"itemHeight" defaultValue: 70];
      int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
      int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
      int textSize = [customThirdView intValueForKey: @"size" defaultValue: 17];
      NSString *color = [customThirdView stringValueForKey: @"color" defaultValue: @"#3C4E5F"];
      
      for (int i = 0 ; i < customArray.count; i++) {
        CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize: textSize];
        [button setTag: i];
        [button setTitle: customNameArray[i] forState:UIControlStateNormal];
        [button setTitleColor: [self getColor: color] forState:UIControlStateNormal];
        [button setBackgroundImage:[self changeUriPathToImage: customArray[i]] forState:UIControlStateNormal];
        [button addTarget:target action: selector forControlEvents:UIControlEventTouchUpInside];
        [customArrayView addObject: button];
      }
      /// 添加第三方图标
      model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        if (backgroundView != nil) {
          [superCustomView addSubview: backgroundView];
        }
        for (int i = 0 ; i < customArrayView.count; i++) {
          [superCustomView addSubview: customArrayView[i]];
        }
      };
      
      model.customViewLayoutBlock = ^(
        CGSize screenSize,       /// 全屏参数
        CGRect contentViewFrame, /// contentView参数
        CGRect navFrame,         /// 导航参数
        CGRect titleBarFrame,    /// title参数
        CGRect logoFrame,        /// logo区域参数
        CGRect sloganFrame,      /// slogan参数
        CGRect numberFrame,      /// 号码处参数
        CGRect loginFrame,       /// 登录按钮处的参数
        CGRect changeBtnFrame,   /// 切换到其他的参数
        CGRect privacyFrame      /// 协议区域的参数
      ) {
        if (backgroundView != nil) {
          backgroundView.frame = CGRectMake(0, -CGRectGetMaxY(navFrame), contentViewFrame.size.width, contentViewFrame.size.height);
        }
        NSUInteger count = customArrayView.count;
        NSInteger contentWidth = screenSize.width;
        /// 弹窗模式需要重新获取他的宽度
        if (PNSBuildModelStyleAlertPortrait == style || PNSBuildModelStyleAlertLandscape == style){
          contentWidth = [dict intValueForKey: @"dialogWidth" defaultValue: 0];
        }
        for (int i = 0 ; i < count; i++) {
          UIButton *itemView = (UIButton *)customArrayView[i];
          NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          itemView.frame = CGRectMake( X, offsetY, itemView.frame.size.width, itemView.frame.size.height );
        }
      };
    }
  }
  #pragma mark 9、协议栏
  if (!model.checkBoxIsHidden) {
    UIImage* unchecked = [self changeUriPathToImage: [dict stringValueForKey: @"uncheckedImgPath" defaultValue: nil]];
    UIImage* checked = [self changeUriPathToImage: [dict stringValueForKey: @"checkedImgPath" defaultValue: nil]];
    if (unchecked != nil && checked != nil) {
      model.checkBoxImages = @[
        unchecked,
        checked
      ];
    }
  }
  /// 协议1，[协议名称,协议Url]
  model.privacyOne = @[
    [dict stringValueForKey: @"protocolOneName" defaultValue: @""],
    [dict stringValueForKey: @"protocolOneURL" defaultValue: @""]
  ];
  /// 协议2，[协议名称,协议Url]
  model.privacyTwo = @[
    [dict stringValueForKey: @"protocolTwoName" defaultValue: @""],
    [dict stringValueForKey: @"protocolTwoURL" defaultValue: @""]
  ];
  /// 协议3，[协议名称,协议Url]
  model.privacyThree = @[
    [dict stringValueForKey: @"protocolThreeName" defaultValue: @""],
    [dict stringValueForKey: @"protocolThreeURL" defaultValue: @""]
  ];
  /// 扩大选区
  model.expandAuthPageCheckedScope = YES;
  model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if ([dict floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.y = [dict floatValueForKey: @"privacyOffsetY" defaultValue: -1];
    }
    if ([dict floatValueForKey: @"privacyOffsetY" defaultValue: -1] > -1) {
      frame.origin.x = [dict floatValueForKey: @"privacyOffsetX" defaultValue: -1];
    }
    return frame;
  };
  #pragma mark 10、弹窗样式
  if (PNSBuildModelStyleAlertPortrait == style || PNSBuildModelStyleAlertLandscape == style || PNSBuildModelStyleSheetPortrait == style) {
    model.alertCloseImage = model.alertCloseImage?:[UIImage imageNamed:@"icon_close_light"];
    model.alertCloseItemFrameBlock = ^CGRect(CGSize screenSize,CGSize superViewSize,CGRect frame) {
        if ([self isHorizontal:screenSize]) {
          //横屏时模拟隐藏该控件
          return CGRectZero;
        } else {
          frame.origin.x = [dict intValueForKey: @"alertCloseImageX" defaultValue: 5];
          frame.origin.y = [dict intValueForKey: @"alertCloseImageY" defaultValue: 5];
          frame.size.width = [dict intValueForKey: @"alertCloseImageW" defaultValue: 30];
          frame.size.height = [dict intValueForKey: @"alertCloseImageH" defaultValue: 30];
          return frame;
        }
    };
    
    if (PNSBuildModelStyleAlertPortrait == style) {
      CGFloat ratio = MAX(TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT) / 667.0;
      //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
      model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
          CGFloat alertX = 0;
          CGFloat alertY = 0;
          CGFloat alertWidth = 0;
          CGFloat alertHeight = 0;
          if ([self isHorizontal:screenSize]) {
            alertX = ratio * TX_Alert_Horizontal_Default_Left_Padding;
            alertWidth = [dict intValueForKey: @"dialogWidth" defaultValue: screenSize.width - alertX * 2];
            alertY = (screenSize.height - alertWidth * 0.5) * 0.5;
            alertHeight = [dict intValueForKey: @"dialogHeight" defaultValue: screenSize.height - 2 * alertY];
          } else {
            alertWidth = [dict intValueForKey: @"dialogWidth" defaultValue: screenSize.width / 2];
            alertHeight = [dict intValueForKey: @"dialogHeight" defaultValue: screenSize.height / 2];
            alertX = [dict intValueForKey: @"dialogOffsetX" defaultValue: (TX_SCREEN_WIDTH - alertWidth) / 2];
            alertY = [dict intValueForKey: @"dialogOffsetY" defaultValue: (TX_SCREEN_HEIGHT - alertHeight) / 2];
          }
          return CGRectMake(alertX, alertY, alertWidth, alertHeight);
      };
    } else if (PNSBuildModelStyleSheetPortrait == style) {
      model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
          frame.size.width = superViewSize.width;
          frame.size.height = [dict floatValueForKey: @"dialogHeight" defaultValue: 460];
          frame.origin.x = 0;
          frame.origin.y = superViewSize.height - frame.size.height;
          return frame;
      };
    }
  }
  
  #pragma mark 10、二次弹窗
  /// 弹窗大小
  model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    return CGRectMake(
        [dict floatValueForKey: @"privacyAlertOffsetX" defaultValue: 40],
        [dict floatValueForKey: @"privacyAlertOffsetY" defaultValue: frame.origin.y],
        [dict floatValueForKey: @"privacyAlertWidth" defaultValue: frame.size.width - 80],
        [dict floatValueForKey: @"privacyAlertHeight" defaultValue: 200]
    );
  };
  
  #pragma mark 屏幕方向
  if (model.privacyAlertIsNeedShow) {
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
  }
  
  // 设置后点击富文本不会直接跳转页面
  // model.privacyVCIsCustomized = YES;
  model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
  return model;
}

/**
 16进制颜色转换为UIColor
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @return 16进制字符串对应的颜色
 */
+(UIColor *) getColor:(NSString *)hexColor{
  if (hexColor.length < 8) {
    return [self colorWithHexString: hexColor alpha: 1];
  }
  
  unsigned int alpha, red, green, blue;
  NSRange range;
  range.length =2;

  range.location =1;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
  range.location =3;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
  range.location =5;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
  range.location =7;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
  return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
}

/**
 16进制颜色转换为UIColor
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

+ (void) clickAllScreen:(UITapGestureRecognizer *) recognizer {
  NSLog(@"点击事件屏蔽");
}

#pragma mark 处理参数
/**
 * 处理参数，对参数进行处理包含color、Path
 * @param parmas 字典数据
 * @return 处理后的数据
 */
+ (NSDictionary *) formatParmas: (NSDictionary *)parmas{
  NSArray *keysArray = [parmas allKeys];
  for (int i = 0; i < keysArray.count; i++) {
    NSString *key = keysArray[i];
    NSString *value = parmas[key];
    //根据键值处理字典中的每一项
    if ([key containsString: @"color"] && [value containsString: @"#"])
    {
      [parmas setValue: [self getColor: value] forKey: key];
    }
    // 判断是否时路径字段
    // 排除按钮状态的背景logBtnBackgroundPath
    else if (
       ![key containsString: @"logBtnBackgroundPath"] &&
       ([key containsString: @"path"] || [key containsString: @"Path"]) &&
       ![value containsString: @"http"] && ![value isEqual: nil] && ![value isEqual: @""])
    {
      [parmas setValue: [self changeUriToPath: value] forKey: key];
    }
  }
  
  return parmas;
}

#pragma mark  ======获取flutterVc========
+(FlutterViewController *)flutterVC{
  UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  if ([viewController isKindOfClass: [FlutterViewController class]]) {
    return (FlutterViewController *)viewController;
  } else {
    return (FlutterViewController *)[self findCurrentViewController];
  }
}
+ (UIViewController *)getRootViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}
#pragma mark  ======在view上添加UIViewController========
+ (UIViewController *)findCurrentViewController{
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

#pragma mark  assets -> 转换成真实路径
+ (NSString *) changeUriToPath:(NSString *) key{
  NSString* keyPath = [[self flutterVC] lookupKeyForAsset: key];
  NSString* path = [[NSBundle mainBundle] pathForResource: keyPath ofType:nil];
  return path;
}

#pragma mark  assets -> 真实路径转成UIImage
+ (UIImage *) changeUriPathToImage:(NSString *) key{
  if (key == nil || [key isEqual: @""]) return nil;
  // NSLog(@"路径为：%@", key);
  NSString* path = [self changeUriToPath: key];
  UIImage * image = [UIImage imageWithContentsOfFile: path];
  return image;
}

/// 是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}
@end
