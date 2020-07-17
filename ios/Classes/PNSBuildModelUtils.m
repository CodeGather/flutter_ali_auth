//
//  TXModel.m
//  AliComSDKDemo
//
//  Created by 沈超 on 2019/11/5.
//  Copyright © 2019 alicom. All rights reserved.
//

#import "PNSBuildModelUtils.h"
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

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

/// 是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}


@end
