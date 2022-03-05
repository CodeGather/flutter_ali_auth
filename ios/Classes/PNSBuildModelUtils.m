//
//  TXModel.m
//  AliComSDKDemo
//
//  Created by 沈超 on 2019/11/5.
//  Copyright © 2019 alicom. All rights reserved.
//

#import "PNSBuildModelUtils.h"
#import "NSDictionary+Utils.h"
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

+ (TXCustomModel *)buildFullScreenModel {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    
  model.navColor = [self colorWithHex:0x3971fe alpha: 1]; //UIColor[0xFF3A71FF];
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    //model.navIsHidden = NO;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    //model.hideNavBackItem = NO;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    // [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    model.navMoreView = rightBtn;
    
    model.privacyNavColor = [self colorWithHex:0x3971fe alpha: 1];
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.whiteColor;
    
    model.logoImage = [UIImage imageNamed:@"logo"];
    model.logoIsHidden = NO;
    //model.sloganIsHidden = NO;
    // model.sloganText = [[NSAttributedString alloc] initWithString:@"一键登录slogan文案" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    model.numberColor = [self colorWithHex:0x3971fe alpha: 1];
    model.numberFont = [UIFont systemFontOfSize:30.0];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
//    model.loginBtnBgImgs = @[
//      [UIImage imageNamed:@"button_click"],
//      [UIImage imageNamed:@"button_unclick"],
//      [UIImage imageNamed:@"button_click"]
//    ];
    //model.autoHideLoginLoading = NO;
    // model.privacyOne = @[@"《隐私1》",@"https://www.taobao.com/"];
    //model.privacyTwo = @[@"《隐私2》",@"https://www.taobao.com/"];
    model.privacyColors = @[UIColor.lightGrayColor, [self colorWithHex:0x3971fe alpha: 1]];
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:10.0];
    model.privacyPreText = @"点击一键登录并登录表示您已阅读并同意";
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    // 是否同意
    model.checkBoxIsHidden = YES;
    model.checkBoxWH = 17.0;
    // model.changeBtnTitle = [[NSAttributedString alloc] init];
    model.changeBtnTitle = [
       [NSAttributedString alloc] initWithString:@"切换到其他方式"
       attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:18.0]}
    ];
    model.changeBtnIsHidden = YES;
    model.prefersStatusBarHidden = YES;
    model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    //model.presentDirection = PNSPresentationDirectionBottom;
    
    //授权页默认控件布局调整
    //model.navBackButtonFrameBlock =
    //model.navTitleFrameBlock =
    model.navMoreViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat width = superViewSize.height;
        CGFloat height = width;
        return CGRectMake(superViewSize.width - 15 - width, 0, width, height);
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 20;
            return frame;
        }
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero; //横屏时模拟隐藏该控件
        } else {
            return CGRectMake(0, 140, superViewSize.width, frame.size.height);
        }
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 140;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 185;
        }
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero; //横屏时模拟隐藏该控件
        } else {
            return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
        }
    };
    //model.privacyFrameBlock =
    
    //添加自定义控件并对自定义控件进行布局
//    __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
//    [customBtn setBackgroundColor:UIColor.redColor];
//    customBtn.frame = CGRectMake(0, 0, 230, 40);
    // model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
    //      [superCustomView addSubview:customBtn];
    // };
    // model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
    //     CGRect frame = customBtn.frame;
    //     frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
    //     frame.origin.y = CGRectGetMinY(privacyFrame) - frame.size.height - 20;
    //     frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
    //     customBtn.frame = frame;
    // };
    return model;
}

+ (TXCustomModel *)buildAlertModel {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    //model.alertCloseItemIsHidden = YES;
    model.alertTitleBarColor = [self colorWithHex:0x3971fe alpha: 1];
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键绑定" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    
    model.privacyNavColor = [self colorWithHex:0x3971fe alpha: 1];
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.whiteColor;
    
    model.logoImage = [UIImage imageNamed:@"logo"];
    //model.logoIsHidden = NO;
    //model.sloganIsHidden = NO;
    // model.sloganText = [[NSAttributedString alloc] initWithString:@"一键登录slogan文案" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    model.numberColor = [self colorWithHex:0x3971fe alpha: 1];
    model.numberFont = [UIFont systemFontOfSize:30.0];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
//    model.loginBtnBgImgs = @[
//      [UIImage imageNamed:@"button_click"],
//      [UIImage imageNamed:@"button_unclick"],
//      [UIImage imageNamed:@"button_click"]
//    ];
    //model.autoHideLoginLoading = NO;
    //model.privacyOne = @[@"《隐私1》",@"https://www.taobao.com/"];
    //model.privacyTwo = @[@"《隐私2》",@"https://www.taobao.com/"];
    model.privacyColors = @[UIColor.lightGrayColor, [self colorWithHex:0x3971fe alpha: 1]];
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:10.0];
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    //model.checkBoxIsHidden = NO;
    model.checkBoxWH = 17.0;
    model.checkBoxIsHidden = YES;
    model.changeBtnIsHidden = YES;
    // model.changeBtnTitle = [[NSAttributedString alloc] init];
    model.changeBtnTitle = [[
       NSAttributedString alloc] initWithString:@"切换到其他方式"
       attributes:@{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:18.0] }
    ];
    //model.preferredStatusBarStyle = UIStatusBarStyleDefault;
    //model.presentDirection = PNSPresentationDirectionBottom;
    
    CGFloat ratio = MAX(TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT) / 667.0;
    
    //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat alertX = 0;
        CGFloat alertY = 0;
        CGFloat alertWidth = 0;
        CGFloat alertHeight = 0;
        if ([self isHorizontal:screenSize]) {
            alertX = ratio * TX_Alert_Horizontal_Default_Left_Padding;
            alertWidth = screenSize.width - alertX * 2;
            alertY = (screenSize.height - alertWidth * 0.5) * 0.5;
            alertHeight = screenSize.height - 2 * alertY;
        } else {
            alertX = TX_Alert_Default_Left_Padding * ratio;
            alertWidth = screenSize.width - alertX * 2;
            alertY = TX_Alert_Default_Top_Padding * ratio;
            alertHeight = screenSize.height - alertY * 2;
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
    //model.privacyFrameBlock =
    
//    //添加自定义控件并对自定义控件进行布局
//    __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    // [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
//    [customBtn setBackgroundColor:UIColor.redColor];
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//         [superCustomView addSubview:customBtn];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        CGFloat padding = 15;
//        CGFloat x = 0;
//        CGFloat y = 0;
//        CGFloat width = 0;
//        CGFloat height = 0;
//        if ([self isHorizontal:screenSize]) {
//            x = CGRectGetMaxX(loginFrame) + padding;
//            y = padding;
//            width = contentViewFrame.size.width - x - padding;
//            height = CGRectGetMinY(privacyFrame) - y - padding;
//        } else {
//            x = padding;
//            y = MAX(CGRectGetMaxY(changeBtnFrame), CGRectGetMaxY(loginFrame)) + padding;
//            width = contentViewFrame.size.width - 2 * x;
//            height = CGRectGetMinY(privacyFrame) - y - padding;
//        }
//        customBtn.frame = CGRectMake(x, y, width, height);
//    };
    return model;
}

#pragma mark - action 新版一键登录全屏（动态配置）
+ (TXCustomModel *)buildNewFullScreenModel: (NSDictionary *) viewConfig selector:(SEL)selector target: (id) target{
  TXCustomModel *model = [[TXCustomModel alloc] init];
  Boolean isDialog = [viewConfig boolValueForKey: @"isDialog" defaultValue: NO];
  /// 导航设置
  model.navIsHidden = [viewConfig boolValueForKey: @"navHidden" defaultValue: NO];
  model.navColor = [self getColor: [viewConfig stringValueForKey: @"navColor" defaultValue: @"0x3971fe"]];

//  [self colorWithHexString: [viewConfig stringValueForKey: @"navColor" defaultValue: @"0x3971fe"] alpha: 1];
  model.navTitle = [
    [NSAttributedString alloc]
      initWithString: [viewConfig stringValueForKey: @"navText" defaultValue: @"一键登录"]
          attributes: @{
            NSForegroundColorAttributeName: UIColor.whiteColor,
            NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"navTextSize" defaultValue: 20.0]]
          }
  ];
  
  /// 返回按钮
  bool isHiddenNavBack = [viewConfig boolValueForKey: @"navReturnHidden" defaultValue: NO];
  bool isCustomNavBack = [viewConfig boolValueForKey: @"customPageBackgroundLyout" defaultValue: NO];
  model.hideNavBackItem = isHiddenNavBack;
  /// 动态读取assets文件夹下的资源
  UIImage * navBackImage = [self changeUriPathToImage: viewConfig[@"navReturnImgPath"]];
  if(navBackImage != nil){
    model.navBackImage = navBackImage;
  }
  
  if (isCustomNavBack) {
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
  
  /// slogan 设置
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
  
  /// number 设置
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
  
  /// 登录按钮
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
//    model.loginBtnBgImgs = @[
//      [UIImage imageNamed:@"button_click"],
//      [UIImage imageNamed:@"button_unclick"],
//      [UIImage imageNamed:@"button_click"]
//    ];
  
  //model.autoHideLoginLoading = NO;
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
  model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxWH" defaultValue: 17.0];
  
  // 切换到其他标题
  BOOL changeBrnStatus = [viewConfig boolValueForKey: @"changeBtnIsHidden" defaultValue: NO];
  model.changeBtnIsHidden = changeBrnStatus;
  if (!changeBrnStatus) {
    model.changeBtnTitle = [
       [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"changeBtnTitle" defaultValue: @"切换到其他方式"]
       attributes: @{
         NSForegroundColorAttributeName: [self colorWithHexString: [viewConfig stringValueForKey: @"changeBtnTitleColor" defaultValue: @"#ccc"] alpha: 1],
         NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"changeBtnTitleSize" defaultValue: 18]]
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
  
  model.prefersStatusBarHidden = YES;
  model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
  //model.presentDirection = PNSPresentationDirectionBottom;
  
  if (isDialog){
    CGFloat ratio = MAX(TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT) / 667.0;
    
    //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat alertX = 0;
        CGFloat alertY = 0;
        CGFloat alertWidth = 0;
        CGFloat alertHeight = 0;
        if ([self isHorizontal:screenSize]) {
            alertX = ratio * TX_Alert_Horizontal_Default_Left_Padding;
            alertWidth = screenSize.width - alertX * 2;
            alertY = (screenSize.height - alertWidth * 0.5) * 0.5;
            alertHeight = screenSize.height - 2 * alertY;
        } else {
            alertX = TX_Alert_Default_Left_Padding * ratio;
            alertWidth = screenSize.width - alertX * 2;
            alertY = TX_Alert_Default_Top_Padding * ratio;
            alertHeight = screenSize.height - alertY * 2;
        }
        return CGRectMake(alertX, alertY, alertWidth, alertHeight);
    };
  }
    //授权页默认控件布局调整
//    model.navMoreViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        CGFloat width = superViewSize.height;
//        CGFloat height = width;
//        return CGRectMake(superViewSize.width - 15 - width, 0, width, height);
//    };
//    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 20;
//            return frame;
//        }
//        return frame;
//    };
//    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            return CGRectZero; //横屏时模拟隐藏该控件
//        } else {
//            return CGRectMake(0, 140, superViewSize.width, frame.size.height);
//        }
//    };
//    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 140;
//        }
//        return frame;
//    };
//    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 185;
//        }
//        return frame;
//    };
//    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            return CGRectZero; //横屏时模拟隐藏该控件
//        } else {
//            return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
//        }
//    };
  
  /// 自定义按钮布局
  bool customView = [viewConfig boolValueForKey: @"isHiddenCustom" defaultValue: NO];
  if (!customView) {
    NSArray *customArray = [[viewConfig stringValueForKey: @"customThirdImgPaths" defaultValue: nil] componentsSeparatedByString:@","];
    NSMutableArray * customArrayView = [NSMutableArray array];//空数组，有意义
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
      int width = [viewConfig intValueForKey: @"customThirdImgWidth" defaultValue: 70];
      int height = [viewConfig intValueForKey: @"customThirdImgHeight" defaultValue: 70];
      int offsetY = [viewConfig intValueForKey: @"customThirdImgOffsetY" defaultValue: 20];
      int space = [viewConfig intValueForKey: @"customThirdImgSpace" defaultValue: 30];
      
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
        NSInteger contentWidth = isDialog ? contentViewFrame.size.width : screenSize.width;
        for (int i = 0 ; i < count; i++) {
          UIImageView *itemView = (UIImageView *)customArrayView[i];
  //        int X = ((screenSize.width - width * count) / (count + 1)) * (i + 1) + (width * i); /// 平均分布
          NSInteger X = (contentWidth- (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          NSInteger Y = offsetY > 50 ? offsetY : CGRectGetMaxY(changeBtnFrame) + offsetY;
          itemView.frame = CGRectMake( X, Y, width, height );
        }
      };
    }
  }
 
  return model;
}

+ (TXCustomModel *)buildNewAlertModel: (NSDictionary *) viewConfig selector:(SEL)selector target: (id) target{
    TXCustomModel *model = [[TXCustomModel alloc] init];
    
  model.alertBarIsHidden = [viewConfig boolValueForKey: @"alertBarIsHidden" defaultValue: NO];
  model.alertTitleBarColor = [self getColor: [viewConfig stringValueForKey: @"alertTitleBarColor" defaultValue: @"0x3971fe"]];
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
  model.alertBlurViewAlpha = [viewConfig floatValueForKey: @"alertBlurViewAlpha" defaultValue: 0.5];
  NSString *radiuString = [viewConfig stringValueForKey: @"alertCornerRadiusArray" defaultValue: @"10,10,10,10"];
  NSArray *alertCornerRadiusArray = [radiuString componentsSeparatedByString: @","];
  model.alertCornerRadiusArray = [self _map: alertCornerRadiusArray]; //@[@10, @10, @10, @10];
    
  /// 协议页面导航设置
  model.privacyNavColor =  [self getColor: [viewConfig stringValueForKey: @"webNavColor" defaultValue: @"#000000"]];
  UIImage * privacyNavBackImage = [self changeUriPathToImage: viewConfig[@"webNavReturnImgPath"]];
  if(privacyNavBackImage != nil){
    model.privacyNavBackImage = privacyNavBackImage;
  }
  model.privacyNavTitleFont = [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"webNavTextSize" defaultValue: 18]];
  model.privacyNavTitleColor = [self getColor: [viewConfig stringValueForKey: @"webNavTextColor" defaultValue: @"#000000"]];
  
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
  
  
  /// slogan 设置
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
  
  /// number 设置
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
  
  /// 登录按钮
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
  model.checkBoxWH = [viewConfig floatValueForKey: @"checkBoxWH" defaultValue: 17.0];
  
  // 切换到其他标题
  model.changeBtnIsHidden = [viewConfig boolValueForKey: @"changeBtnIsHidden" defaultValue: NO];
  model.changeBtnTitle = [
     [NSAttributedString alloc] initWithString: [viewConfig stringValueForKey: @"changeBtnTitle" defaultValue: @"切换到其他方式"]
     attributes: @{
       NSForegroundColorAttributeName: [self getColor: [viewConfig stringValueForKey: @"changeBtnTitleColor" defaultValue: @"#ccc"]],
       NSFontAttributeName : [UIFont systemFontOfSize: [viewConfig floatValueForKey: @"changeBtnTitleSize" defaultValue: 18]]
     }
  ];
  model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    if (screenSize.height > screenSize.width) {
      return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
    } else {
      return CGRectZero; //横屏时模拟隐藏该控件
    }
  };
  
    //model.preferredStatusBarStyle = UIStatusBarStyleDefault;
    //model.presentDirection = PNSPresentationDirectionBottom;
    
    CGFloat ratio = MAX(TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT) / 667.0;
    
    //实现该block，并且返回的frame的x或y大于0，则认为是弹窗谈起授权页
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat alertX = 0;
        CGFloat alertY = 0;
        CGFloat alertWidth = 0;
        CGFloat alertHeight = 0;
        if ([self isHorizontal:screenSize]) {
            alertX = ratio * TX_Alert_Horizontal_Default_Left_Padding;
            alertWidth = screenSize.width - alertX * 2;
            alertY = (screenSize.height - alertWidth * 0.5) * 0.5;
            alertHeight = screenSize.height - 2 * alertY;
        } else {
            alertX = TX_Alert_Default_Left_Padding * ratio;
            alertWidth = screenSize.width - alertX * 2;
            alertY = TX_Alert_Default_Top_Padding * ratio;
            alertHeight = screenSize.height - alertY * 2;
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
    //model.privacyFrameBlock =
    
//    //添加自定义控件并对自定义控件进行布局
//    __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    // [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
//    [customBtn setBackgroundColor:UIColor.redColor];
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//         [superCustomView addSubview:customBtn];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        CGFloat padding = 15;
//        CGFloat x = 0;
//        CGFloat y = 0;
//        CGFloat width = 0;
//        CGFloat height = 0;
//        if ([self isHorizontal:screenSize]) {
//            x = CGRectGetMaxX(loginFrame) + padding;
//            y = padding;
//            width = contentViewFrame.size.width - x - padding;
//            height = CGRectGetMinY(privacyFrame) - y - padding;
//        } else {
//            x = padding;
//            y = MAX(CGRectGetMaxY(changeBtnFrame), CGRectGetMaxY(loginFrame)) + padding;
//            width = contentViewFrame.size.width - 2 * x;
//            height = CGRectGetMinY(privacyFrame) - y - padding;
//        }
//        customBtn.frame = CGRectMake(x, y, width, height);
//    };
  
  /// 自定义按钮布局
  
  bool customView = [viewConfig boolValueForKey: @"isHiddenCustom" defaultValue: NO];
  if (!customView) {
    NSArray *customArray = [[viewConfig stringValueForKey: @"customThirdImgPaths" defaultValue: nil] componentsSeparatedByString:@","];
    NSMutableArray * customArrayView = [NSMutableArray array];//空数组，有意义
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
      int width = [viewConfig intValueForKey: @"customThirdImgWidth" defaultValue: 70];
      int height = [viewConfig intValueForKey: @"customThirdImgHeight" defaultValue: 70];
      int offsetY = [viewConfig intValueForKey: @"customThirdImgOffsetY" defaultValue: 20];
      int space = [viewConfig intValueForKey: @"customThirdImgSpace" defaultValue: 30];
      
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
        for (int i = 0 ; i < count; i++) {
          UIImageView *itemView = (UIImageView *)customArrayView[i];
          // int X = ((screenSize.width - width * count) / (count + 1)) * (i + 1) + (width * i); /// 平均分布
          NSInteger X = (contentViewFrame.size.width - (width * count + space * (count - 1))) / 2 + (space + width) * i; /// 两端评分
          NSInteger Y = offsetY > 50 ? offsetY : CGRectGetMaxY(changeBtnFrame) + offsetY;
          itemView.frame = CGRectMake( X, Y, width, height );
        }
      };
    }
  }
  return model;
}

+ (NSArray *)_map:(NSArray *)hanlde {
    NSMutableArray *arr = NSMutableArray.array;
    for (int i = 0 ; i < hanlde.count; i++) {
      NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
      f.numberStyle = NSNumberFormatterDecimalStyle;
      NSNumber *new = [f numberFromString: hanlde[i]];
      [arr addObject:new];
    }
    return arr.copy;
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
  //设置控件背景颜色
  imageView.backgroundColor = [UIColor orangeColor];
  imageView.clipsToBounds = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.contentMode = UIViewContentModeScaleToFill;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  
  [imageView addGestureRecognizer:tapGesture];
  imageView.userInteractionEnabled = YES;
  
  return imageView;
}

#pragma mark  assets -> 转换成真实路径
+ (NSString *) changeUriToPath:(NSString *) key{
  NSString* keyPath = [[self flutterVC] lookupKeyForAsset: key];
  NSString* path = [[NSBundle mainBundle] pathForResource: keyPath ofType:nil];
  return path;
}

+ (UIImage *) changeUriPathToImage:(NSString *) key{
  NSString* path = [self changeUriToPath: key];
  UIImage * image = [UIImage imageWithContentsOfFile: path];
  return image;
}

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

/// 是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}

@end
