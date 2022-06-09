//
//  PNSBuildModelUtils.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "NSDictionary+Utils.h"

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
  /// _model = [TXCustomModel mj_objectWithKeyValues: dic];
  PNSBuildModelStyle style = [dict intValueForKey: @"pageType" defaultValue: 0];
  switch (style) {
      case PNSBuildModelStylePortrait:
          model = [self buildFullScreenPortraitModel:dict
                                                             target:target
                                                           selector:selector];
          break;
      case PNSBuildModelStyleLandscape:
          model = [self buildFullScreenLandscapeModel:dict
                                                              target:target
                                                            selector:selector];
          break;
//        case PNSBuildModelStyleAutorotate:
//            model = [self buildFullScreenAutorotateModelWithButton1Title:button1Title
//                                                                 target:target
//                                                               selector:selector
//                                                            button2Title:button2Title
//                                                                 target2:target2
//                                                               selector2:selector2];
//            break;
      case PNSBuildModelStyleAlertPortrait:
          model = [self buildAlertPortraitMode:dict
                                                       target:target
                                                     selector:selector];
          break;
      case PNSBuildModelStyleAlertLandscape:
          model = [self buildAlertLandscapeMode:dict
                                                        target:target
                                                      selector:selector];
          break;
//        case PNSBuildModelStyleAlertAutorotate:
//            model = [self buildAlertAutorotateModeWithButton1Title:button1Title
//                                                           target:target
//                                                         selector:selector
//                                                      button2Title:button2Title
//                                                           target2:target2
//                                                         selector2:selector2];
//            break;
      case PNSBuildModelStyleSheetPortrait:
          model = [self buildSheetPortraitModel:dict
                                                        target:target
                                                      selector:selector];
          break;
      case PNSDIYAlertPortraitFade:
          model = [self buildAlertFadeModel:dict
                                                    target:target
                                                  selector:selector];
          break;
//        case PNSDIYAlertPortraitBounce:
//            model = [self buildAlertBounceModelWithButton1Title:button1Title
//                                                        target:target
//                                                      selector:selector
//                                                   button2Title:button2Title
//                                                        target2:target2
//                                                      selector2:selector2];
//            break;
      case PNSDIYAlertPortraitDropDown:
          model = [self buildAlertDropDownModel:dict
                                                        target:target
                                                      selector:selector];
          break;
//        case PNSDIYPortraitFade:
//            model = [self buildFadeModel:button1Title
//                                                 target:target
//                                               selector:selector
//                                            button2Title:button2Title
//                                                 target2:target2
//                                               selector2:selector2];
//            break;
//        case PNSDIYPortraitScale:
//            model = [self buildScaleModel:button1Title
//                                                  target:target
//                                                selector:selector
//                                             button2Title:button2Title
//                                                  target2:target2
//                                                selector2:selector2];
//            break;
      case PNSBuildModelStyleVideoBackground:
          model = [self buildVideoBackgroundModel:dict
                                                          target:target
                                                        selector:selector];
          break;
      case PNSBuildModelStyleGifBackground:
          model = [self buildGifBackgroundModel:dict
                                                        target:target
                                                      selector:selector];
          break;
      default:
          break;
  }
  return model;
}

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

#pragma mark - 全屏相关
+ (TXCustomModel *)buildFullScreenPortraitModel:(NSDictionary *)viewConfig
                                                        target:(id)target
                                                      selector:(SEL)selector{
  TXCustomModel *model = [[TXCustomModel alloc] init];
  /// 导航设置
  model.navIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
  model.navColor = [self getColor: [viewConfig stringValueForKey: @"navColor" defaultValue: @"0x3971fe"]];

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
  UIImage * navBackImage = [self changeUriPathToImage: viewConfig[@"navReturnImgPath"]];
  if(navBackImage != nil){
    model.navBackImage = navBackImage;
  }
  
  if (!isHiddenNavBack) {
    /// 自定义返回按钮
    model.navBackButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      UIImageView *imageView = [[UIImageView alloc]init];
      imageView.image = navBackImage;
      imageView.frame = CGRectMake(CGRectGetMinX(frame),
                                         CGRectGetMaxY(frame),
                                         CGRectGetWidth(frame),
                                   CGRectGetHeight(frame));
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
  UIImage * privacyNavBackImage = [self changeUriPathToImage: viewConfig[@"webNavReturnImgPath"]];
  if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
  }
  model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000"]];
  
  /// logo 设置
  model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: NO];
  UIImage * image = [self changeUriPathToImage: viewConfig[@"logoImgPath"]];
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
         NSForegroundColorAttributeName: [self colorWithHexString: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555"] alpha: 1],
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
    if ((login_btn_normal != nil || defaultClick != nil) && (login_btn_unable != nil || defaultUnClick != nil) && (login_btn_press != nil || defaultClick != nil)) {
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
  model.privacyOne = @[
    [viewConfig stringValueForKey: @"protocolOneName" defaultValue: nil],
    [viewConfig stringValueForKey: @"protocolOneURL" defaultValue: nil]
  ];
  model.privacyTwo = @[
    [viewConfig stringValueForKey: @"protocolTwoName" defaultValue: nil],
    [viewConfig stringValueForKey: @"protocolTwoURL" defaultValue: nil]
  ];
  model.privacyThree = @[
    [viewConfig stringValueForKey: @"protocolThreeName" defaultValue: nil],
    [viewConfig stringValueForKey: @"protocolThreeURL" defaultValue: nil]
  ];
  model.privacyColors = @[
    [self getColor: [viewConfig stringValueForKey: @"protocolColor" defaultValue: @"#F00F00"]],
    [self getColor: [viewConfig stringValueForKey: @"protocolCustomColor" defaultValue: @"#FDFDFD"]]
  ];
  
  /** 导航背景色*/
  model.privacyNavColor = [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#FFFFFF"]];
  /** 导航文字色 */
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];
  /** 字体大小  */
  model.privacyNavTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 12.0]];
  /** 返回按钮  */
  UIImage * webNavReturnImgPath = [self changeUriPathToImage: viewConfig[@"webNavReturnImgPath"]];
  if (webNavReturnImgPath != nil) {
    model.privacyNavBackImage = webNavReturnImgPath;
  }
  
  model.privacyAlignment = NSTextAlignmentCenter;
  model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 12.0]];
  model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"点击一键登录并登录表示您已阅读并同意"];
  model.privacySufText = [viewConfig stringValueForKey: @"privacyEnd" defaultValue: @"思预云用户协议，隐私"];
  model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
  model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];
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
         NSForegroundColorAttributeName: [self colorWithHexString: [viewConfig stringValueForKey: @"switchAccTextColor" defaultValue: @"#ccc"] alpha: 1],
         NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"switchAccTextSize" defaultValue: 18]]
       }
    ];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if (screenSize.height > screenSize.width) {
        return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
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
    if(customArray != nil && customArray.count > 0){
      for (int i = 0 ; i < customArray.count; i++) {
        /// 动态生成imageView 并且加入到 imageView数组中以备使用
        UIImageView *itemView = [
         self customView: customArray[i]
                selector: selector
                  target: target
                   index: i
         ];
        [customArrayView addObject: itemView];
      }
      /// 添加第三方图标
      model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        for (int i = 0 ; i < customArrayView.count; i++) {
          [superCustomView addSubview: customArrayView[i]];
        }
      };
      /// 第三方图标按钮的相关参数
      int width = [viewConfig intValueForKey: @"itemWidth" defaultValue: 70];
      int height = [viewConfig intValueForKey: @"itemHeight" defaultValue: 70];
      int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
      int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
      
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
          UIImageView *itemView = (UIImageView *)customArrayView[i];
          NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          NSInteger Y = offsetY > 50 ? CGRectGetMaxY(navFrame) + offsetY : CGRectGetMaxY(changeBtnFrame) + offsetY;
          itemView.frame = CGRectMake( X, Y, width, height );
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

#pragma mark - 弹窗

+ (TXCustomModel *)buildAlertPortraitMode:(NSDictionary *)viewConfig
                                                  target:(id)target
                                                selector:(SEL)selector {
  TXCustomModel *model = [[TXCustomModel alloc] init];
  model.alertBarIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
  model.alertTitleBarColor = [self getColor: [viewConfig stringValueForKey: @"navTextColor" defaultValue: @"0x3971fe"]];
  model.alertTitle = [
    [NSAttributedString alloc]
      initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
          attributes: @{
            NSForegroundColorAttributeName: UIColor.whiteColor,
            NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
          }
  ];;
  model.alertCloseItemIsHidden = [viewConfig boolValueForKey: @"alertCloseItemIsHidden" defaultValue: NO];
  
  UIImage * alertCloseImage = [self changeUriPathToImage: viewConfig[@"alertCloseImage"]];
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
  UIImage * privacyNavBackImage = [self changeUriPathToImage: viewConfig[@"webNavReturnImgPath"]];
  if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
  }
  model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];
  
  /// logo 设置 START
  model.logoIsHidden = [viewConfig boolValueForKey: @"logoHidden" defaultValue: NO];
  UIImage * image = [self changeUriPathToImage: viewConfig[@"logoImgPath"]];
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
         NSForegroundColorAttributeName: [self colorWithHexString: [viewConfig stringValueForKey: @"sloganTextColor" defaultValue: @"#555"] alpha: 1],
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
    UIImage *buttonUnclick = [UIImage imageNamed:@"button_unclick"];
    // fix '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
    if ((login_btn_normal != nil && login_btn_unable != nil && login_btn_press != nil) || (defaultClick != nil && buttonUnclick != nil)) {
      // 登录按钮设置
      model.loginBtnBgImgs = @[
        login_btn_normal?:defaultClick,
        login_btn_unable?:buttonUnclick,
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
  
  model.privacyOne = [[viewConfig stringValueForKey: @"appPrivacyOne" defaultValue: nil] componentsSeparatedByString:@","];
  model.privacyTwo = [[viewConfig stringValueForKey: @"appPrivacyTwo" defaultValue: nil] componentsSeparatedByString:@","];
  NSArray *privacyColors = [[viewConfig stringValueForKey: @"appPrivacyColor" defaultValue: nil] componentsSeparatedByString:@","];
  if(privacyColors != nil && privacyColors.count > 1){
    model.privacyColors = @[
      [self colorWithHexString: privacyColors[0] alpha: 1],
      [self colorWithHexString: privacyColors[1] alpha: 1]
    ];
  }
  
  model.privacyAlignment = NSTextAlignmentCenter;
  model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size: [viewConfig floatValueForKey: @"privacyTextSize" defaultValue: 12.0]];
  model.privacyPreText = [viewConfig stringValueForKey: @"privacyBefore" defaultValue: @"点击一键登录并登录表示您已阅读并同意"];
  model.privacySufText = [viewConfig stringValueForKey: @"privacyEnd" defaultValue: @"思预云用户协议，隐私"];
  model.privacyOperatorPreText = [viewConfig stringValueForKey: @"vendorPrivacyPrefix" defaultValue: @"《"];
  model.privacyOperatorSufText = [viewConfig stringValueForKey: @"vendorPrivacySuffix" defaultValue: @"》"];
  
  // 勾选统一按钮
  BOOL checkStatus = [viewConfig boolValueForKey: @"checkBoxHidden" defaultValue: NO];
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
      return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
    } else {
      return CGRectZero; //横屏时模拟隐藏该控件
    }
  };
    
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
  //model.alertTitleBarFrameBlock =
  //model.alertTitleFrameBlock =
  //model.alertCloseItemFrameBlock =
  model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([self isHorizontal:screenSize]) {
          return CGRectZero; //横屏时模拟隐藏该控件
      } else {
          frame.origin.y = 10;
          return frame;
      }
  };
  model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([self isHorizontal:screenSize]) {
          return CGRectZero; //横屏时模拟隐藏该控件
      } else {
          frame.origin.y = 110;
          return frame;
      }
  };
  model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([self isHorizontal:screenSize]) {
          frame.origin.y = 20;
          frame.origin.x = (superViewSize.width * 0.5 - frame.size.width) * 0.5 + 18.0;
      } else {
          frame.origin.y = 140;
      }
      return frame;
  };
  model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([self isHorizontal:screenSize]) {
          frame.origin.y = 60;
          frame.size.width = superViewSize.width * 0.5; //登录按钮最小宽度是其父视图的一半，再小就不生效了
      } else {
          frame.origin.y = 180;
      }
      return frame;
  };
  model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
      if ([self isHorizontal:screenSize]) {
          return CGRectZero; //横屏时模拟隐藏该控件
      } else {
          return CGRectMake(10, 240, superViewSize.width - 20, 30);
      }
  };
   
  
  /// 自定义第三方按钮布局 START
  NSDictionary *customThirdView = [viewConfig dictValueForKey: @"customThirdView" defaultValue: nil];
  if (customThirdView != nil) {
    NSMutableArray * customArrayView = [NSMutableArray array]; /// 空数组，有意义
    NSArray * customArray = [customThirdView arrayValueForKey: @"viewItemPath" defaultValue: nil]; //空数组，有意义
    if(customArray != nil && customArray.count > 0){
      for (int i = 0 ; i < customArray.count; i++) {
        /// 动态生成imageView 并且加入到 imageView数组中以备使用
        UIImageView *itemView = [
         self customView: customArray[i]
                selector: selector
                  target: target
                   index: i
         ];
        [customArrayView addObject: itemView];
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
      /// 第三方图标按钮的相关参数
      int width = [viewConfig intValueForKey: @"itemWidth" defaultValue: 50];
      int height = [viewConfig intValueForKey: @"itemHeight" defaultValue: 50];
      int offsetY = [customThirdView intValueForKey: @"top" defaultValue: 20];
      int space = [customThirdView intValueForKey: @"space" defaultValue: 30];
      
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
          UIImageView *itemView = (UIImageView *)customArrayView[i];
          NSInteger X = (contentWidth - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          NSInteger Y = CGRectGetMaxY(titleBarFrame) + 10 + offsetY;
          itemView.frame = CGRectMake( X, Y, width, height );
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

+ (void) clickAllScreen:(UITapGestureRecognizer *) recognizer {
  NSLog(@"点击事件屏蔽");
}
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

#pragma mark - 底部弹窗

+ (TXCustomModel *)buildSheetPortraitModel:(NSDictionary *)dict
                                                   target:(id)target
                                                 selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @0, @0, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = 460;
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
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
//                                   CGRectGetWidth(loginFrame),
//                                   30);
//
//        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                   CGRectGetMaxY(button1.frame) + 15,
//                                   CGRectGetWidth(loginFrame),
//                                   30);
//    };
    return model;
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

#pragma mark - other
+ (TXCustomModel *)buildVideoBackgroundModel:(NSDictionary *)dict
                                                     target:(id)target
                                                   selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    //model.navIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.navColor = [UIColor clearColor];
    model.navTitle = [[NSAttributedString alloc] init];
    model.logoIsHidden = YES;
    model.numberColor = [UIColor whiteColor];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    PNSBackgroundView *backgroundView = [[PNSBackgroundView alloc] init];
    backgroundView.videoUrl = [NSBundle.mainBundle URLForResource:@"background_video" withExtension:@"mp4"];
    [backgroundView show];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:backgroundView];
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 50;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 130;
        return frame;
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        backgroundView.frame = CGRectMake(0,
                                          -CGRectGetMaxY(navFrame),
                                          contentViewFrame.size.width,
                                          contentViewFrame.size.height);
    };
    return model;
}

+ (TXCustomModel *)buildGifBackgroundModel:(NSDictionary *)dict
                                                   target:(id)target
                                                 selector:(SEL)selector {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    //model.navIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.navColor = [UIColor clearColor];
    model.navTitle = [[NSAttributedString alloc] init];
    model.logoIsHidden = YES;
    model.numberColor = [UIColor whiteColor];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    PNSBackgroundView *backgroundView = [[PNSBackgroundView alloc] init];
    backgroundView.gifUrl = [NSBundle.mainBundle URLForResource:@"background_gif" withExtension:@"gif"];
    [backgroundView show];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:backgroundView];
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 50;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 130;
        return frame;
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        backgroundView.frame = CGRectMake(0,
                                          -CGRectGetMaxY(navFrame),
                                          contentViewFrame.size.width,
                                          contentViewFrame.size.height);
    };
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


#pragma mark  ======获取flutterVc========
+(FlutterViewController *)flutterVC{
  return (FlutterViewController *)[self findCurrentViewController];
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
  NSString* path = [self changeUriToPath: key];
  UIImage * image = [UIImage imageWithContentsOfFile: path];
  return image;
}

/// 是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}
@end
