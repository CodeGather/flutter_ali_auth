//
//  AliAuthEnum.m
//  ali_auth
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//

#import "AliAuthEnum.h"

@implementation AliAuthEnum : NSObject
static NSDictionary * StatusAll = nil;
+ (NSDictionary *)initData {
  if (StatusAll == nil) {
    StatusAll = @{
        @"500000": @"参数获取异常！",
        @"500001": @"密钥不能为空, 请先检查密钥是否设置！",
        @"500002": @"校验成功，可进行一键登录！",
        @"500003": @"该接口为延时登录接口，请先初始化后再次调用该接口！",
        @"500004": @"插件启动监听成功, 当前SDK版本: %@",
        @"600000": @"获取token成功！",
        @"600001": @"唤起授权页成功！",
        @"600002": @"唤起授权⻚失败！建议切换到其他登录⽅式",
        @"600004": @"获取运营商配置信息失败！创建⼯单联系⼯程师",
        @"600005": @"⼿机终端不安全！切换到其他登录⽅式",
        @"600007": @"未检测到sim卡！⽤户检查 SIM 卡后,",
        @"600008": @"蜂窝⽹络未开启！⽤户开启移动⽹络后重试",
        @"600009": @"⽆法判断运营商! 创建⼯单联系⼯程师",
        @"600010": @"未知异常创建！⼯单联系⼯程师",
        @"600011": @"获取token失败！切换到其他登录⽅式",
        @"600012": @"预取号失败！",
        @"600013": @"运营商维护升级！该功能不可⽤创建⼯单联系⼯程师",
        @"600014": @"运营商维护升级！该功能已达最⼤调⽤次创建⼯单联系⼯程师",
        @"600015": @"接⼝超时！切换到其他登录⽅式",
        @"600016": @"当前状态预取号成功！",
        @"600017": @"AppID、Appkey解析失败! 秘钥未设置或者设置错误，请先检查秘钥信息，如果⽆法解决问题创建⼯单联系⼯程师",
        @"600018": @"请先初始化SDK！",
        @"600019": @"用户点击第三方按钮！",
        @"600021": @"点击登录时检测到运营商已切换！⽤户退出授权⻚，重新登录",
        @"600023": @"加载⾃定义控件异常！检查⾃定义控件添加是否正确",
        @"600024": @"终端环境检查⽀持认证",
        @"600025": @"终端检测参数错误检查传⼊参数类型与范围是否正确",
        @"600026": @"授权⻚已加载时不允许调⽤加速或预取号接⼝检查是否有授权⻚拉起后，去调⽤preLogin或者accelerateAuthPage的接⼝，该⾏为不允许",
        @"700000": @"用户取消登录",
        @"700001": @"用户切换其他登录方式",
        @"700002": @"用户点击登录按钮",
        @"700003": @"用户勾选协议选项",
        @"700004": @"用户点击协议富文本"
      };
  }
  return StatusAll;
}

+ (NSDictionary *)keyPair {
  return @{
    /// 1、状态栏
    @"isStatusBarHidden": @"prefersStatusBarHidden",
    @"lightColor": @"preferredStatusBarStyle",
    /// 2、导航栏
    @"navHidden": @"navIsHidden",
    @"backgroundColor": @"alertContentViewColor",
    @"navReturnImgPath": @"navBackImage",
    @"navReturnHidden": @"hideNavBackItem",
    /// 3、Logo
    @"logoImgPath": @"logoImage",
    @"logoHidden": @"logoIsHidden",
    /// 4、Slogan
    @"sloganHidden": @"sloganIsHidden",
    /// 5、掩码栏
    @"numberSize": @"numberFont",
    /// 6、登录按钮
    /// 7、切换到其他方式
    @"switchAccHidden": @"changeBtnIsHidden",
    @"switchAccText": @"changeBtnTitle",
    /// 9、协议栏
    @"checkboxHidden": @"checkBoxIsHidden",
    @"checkBoxHeight": @"checkBoxWH",
    @"privacyState": @"checkBoxIsChecked", 
    @"privacyTextSize": @"privacyFont",
    @"protocolGravity": @"privacyAlignment",
    @"protocolOwnOneColor": @"privacyOneColor",
    @"protocolOwnTwoColor": @"privacyTwoColor",
    @"protocolOwnThreeColor": @"privacyThreeColor",
    @"protocolOwnColor": @"privacyOperatorColor",
    @"privacyBefore": @"privacyPreText",
    @"privacyEnd": @"privacySufText",
    @"vendorPrivacyPrefix": @"privacyOperatorPreText",
    @"vendorPrivacySuffix": @"privacyOperatorSufText",
    @"privacyConectTexts": @"privacyConectTexts",
    /// 协议详情
    @"webNavColor": @"privacyNavColor",
    @"webNavTextColor": @"privacyNavTitleColor",
    @"webNavTextSize": @"privacyNavTitleFont",
    @"webNavReturnImgPath": @"privacyNavBackImage",
    ///
    @"pageBackgroundPath": @"backgroundImage",
    /// 弹窗
    @"dialogCornerRadiusArray": @"alertCornerRadiusArray",
    @"alertCloseImagePath": @"alertCloseImage",
    /// 二次
    @"privacyAlertIsNeedAutoLogin": @"privacyAlertIsNeedAutoLogin",
    @"privacyAlertTitleTextSize": @"privacyAlertTitleFont",
    @"privacyAlertContentVerticalMargin": @"privacyAlertLineSpaceDp",
    @"privacyAlertBtnText": @"privacyAlertBtnContent",
    @"privacyAlertBtnTextSize": @"privacyAlertButtonFont",
    @"privacyAlertCloseImagPath": @"privacyAlertCloseButtonImage",
    @"privacyAlertContentTextSize": @"privacyAlertContentFont",
    @"privacyAlertBtnBackgroundImgPath": @"privacyAlertBtnBackgroundImages",
    @"privacyAlertCloseBtnShow": @"privacyAlertCloseButtonIsNeedShow",
    @"privacyAlertBefore": @"privacyAlertPreText",
    @"privacyAlertEnd": @"privacyAlertSufText",
    @"privacyAlertProtocolNameUseUnderLine": @"privacyAlertContentUnderline",
  };
}

#pragma mark --枚举，消息提示框的位置
typedef NS_ENUM(NSInteger, MBProgressHUBPosition) {
    MBProgressHUBPositionTop,            //头部
    MBProgressHUBPositionCenter,         //中心
    MBProgressHUBPositionBottom          //底部
};
@end

