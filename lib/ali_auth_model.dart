import 'dart:ui';

import 'package:flutter/material.dart';

/// 本机号码校验
const int SERVICE_TYPE_AUTH = 1;

/// 一键登录
const int SERVICE_TYPE_LOGIN = 2;

// ScaleType 可选类型
enum ScaleType {
  MATRIX,
  FIT_XY,
  FIT_START,
  FIT_CENTER,
  FIT_END,
  CENTER,
  CENTER_CROP,
  CENTER_INSIDE,
}

/// 登录窗口配置
class AliAuthModel {
  /// aliyun sk
  @required
  final String? sk;

  /// 是否使用dialog弹窗登录
  final bool? isDialog;

  /// 是否开启debug模式
  final bool? isDebug;

  /// 是否添加自定义背景布局
  final bool? customPageBackgroundLyout;

  /// 1、状态栏

  /// statusBarColor 设置状态栏颜⾊（系统版本 5.0 以上可设置）
  final String? statusBarColor;

  /// 设置状态栏是否隐藏
  final bool? statusBarHidden;

  /// 设置状态栏UI属性 View.SYSTEM_UI_FLAG_LOW_PROFILE View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  /// public static final int SYSTEM_UI_FLAG_FULLSCREEN = 4;
  /// public static final int SYSTEM_UI_FLAG_HIDE_NAVIGATION = 2;
  /// public static final int SYSTEM_UI_FLAG_IMMERSIVE = 2048;
  /// public static final int SYSTEM_UI_FLAG_IMMERSIVE_STICKY = 4096;
  /// public static final int SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN = 1024;
  /// public static final int SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION = 512;
  /// public static final int SYSTEM_UI_FLAG_LAYOUT_STABLE = 256;
  /// public static final int SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR = 16;
  /// public static final int SYSTEM_UI_FLAG_LIGHT_STATUS_BAR = 8192;
  final int? statusBarUIFlag;

  /// 设置状态栏字体颜⾊（系统版本 6.0 以上可21设置⿊⾊、⽩⾊）。true 为⿊⾊
  final bool? lightColor;

  /// 设置导航栏颜⾊
  final String? navColor;

  /// 设置导航栏标题⽂字
  final String? navText;

  /// 设置导航栏标题⽂字颜⾊
  final String? navTextColor;

  /// 设置导航栏标题⽂字⼤⼩
  final int? navTextSize;

  /// 设置导航栏返回键图⽚
  final String? navReturnImgPath;

  /// 设置导航栏返回键宽度
  final int? navReturnImgWidth;

  /// 设置导航栏返回键高度
  final int? navReturnImgHeight;

  /// 设置导航栏返回按钮隐藏
  final bool? navReturnHidden;

  /// 设置默认导航栏是否隐藏
  final bool? navHidden;

  /// 设置协议⻚状态栏颜⾊（系统版本 5.0 以上可设置）不设置则与授权⻚设置⼀致
  final String? webViewStatusBarColor;

  /// 设置协议⻚顶部导航栏背景⾊不设置则与授权⻚设置⼀致
  final String? webNavColor;

  /// 设置协议⻚顶部导航栏标题颜⾊不设置则与授权⻚设置⼀致
  final String? webNavTextColor;

  /// 设置协议⻚顶部导航栏⽂字⼤⼩22不设置则与授权⻚设置⼀致
  final int? webNavTextSize;

  /// 设置协议⻚导航栏返回按钮图⽚路径不设置则与授权⻚设置⼀致
  final String? webNavReturnImgPath;

  /// 设置返回按钮的自定义名称，注意需要将布局文件添加在android/res/layout文件夹中 如果想要插件自带的返回布局，请设置0
  final String? customNavReturnImageLayoutName;

  /// 设置底部虚拟按键背景⾊（系统版本 5.0 以上可设置）
  final String? bottomNavColor;

  /// 2、授权⻚Logo

  /// 隐藏logo
  final bool? logoHidden;

  /// 设置logo 图⽚
  final String? logoImgPath;

  /// 设置logo 控件宽度
  final int? logoWidth;

  /// 设置logo 控件⾼度
  final int? logoHeight;

  /// 设置logo 控件相对导航栏顶部的位移，单位dp
  final int? logoOffsetY;

  /// 设置logo图⽚缩放模式
  /// FIT_XY,
  /// FIT_START,
  /// FIT_CENTER,
  /// FIT_END,
  /// CENTER,
  /// CENTER_CROP,
  /// CENTER_INSIDE
  final String? logoScaleType;

  /// 3、授权⻚Slogan

  /// 隐藏slogan
  final bool? sloganHidden;

  /// 设置slogan ⽂字内容
  final String? sloganText;

  /// 设置slogan ⽂字颜⾊
  final String? sloganTextColor;

  /// 设置slogan ⽂字⼤⼩
  final int? sloganTextSize;

  /// 设置slogan 相对导航栏顶部的 位移，单位dp
  final int? sloganOffsetY;

  /// 4、授权⻚号码栏

  /// 设置⼿机号码字体颜⾊
  final String? numberColor;

  /// 设置⼿机号码字体⼤⼩
  final int? numberSize;

  /// 设置号码栏控件相对导航栏顶部的位移，单位 dp
  final int? numFieldOffsetY;

  /// 设置号码栏相对于默认位置的X轴偏移量，单位dp
  final int? numberFieldOffsetX;

  /// 设置⼿机号掩码的布局对⻬⽅式，只⽀持Gravity.CENTER_HORIZONTAL、Gravity.LEFT、Gravity.RIGHT三种对⻬⽅式
  final int? numberLayoutGravity;

  /// 5. 授权⻚登录按钮

  /// 设置登录按钮⽂字
  final String? logBtnText;

  /// 设置登录按钮⽂字颜⾊
  final String? logBtnTextColor;

  /// 设置登录按钮⽂字⼤⼩
  final int? logBtnTextSize;

  /// 设置登录按钮宽度，单位 dp
  final int? logBtnWidth;

  /// 设置登录按钮⾼度，单位dp
  final int? logBtnHeight;

  /// 设置登录按钮相对于屏幕左右边缘边距
  final int? logBtnMarginLeftAndRight;

  /// 设置登录按钮背景图⽚路径 是一个逗号拼接的图片路径 例如：'assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png'
  /// 如果设置错误或者找不到图片则使用默认样式
  final String? logBtnBackgroundPath;

  /// 设置登录按钮相对导航栏顶部的位移，单位 dp
  final int? logBtnOffsetY;

  /// 设置登录loading dialog 背景图⽚路径24
  final String? loadingImgPath;

  /// 设置登陆按钮X轴偏移量，如果设置了setLogBtnMarginLeftAndRight，并且布局对⻬⽅式为左对⻬或者右对⻬,则会在margin的基础上再增加offsetX的偏移量，如果是居中对⻬，则仅仅会在居中的基础上再做offsetX的偏移。
  final int? logBtnOffsetX;

  /// 设置登陆按钮布局对⻬⽅式，只⽀持Gravity.CENTER_HORIZONTAL、Gravity.LEFT、Gravity.RIGHT三种对⻬⽅式
  final int? logBtnLayoutGravity;

  /// 6. 授权⻚隐私栏

  /// 设置开发者隐私条款 1 名称和URL(名称，url) String,String
  final String? appPrivacyOne;

  /// 设置开发者隐私条款 2 名称和URL(名称，url) String,String
  final String? appPrivacyTwo;

  /// 设置隐私条款名称颜⾊(基础⽂字颜⾊，协议⽂字颜⾊)
  final String? appPrivacyColor;

  /// 设置隐私条款相对导航栏顶部的位移，单位dp
  final int? privacyOffsetY;

  /// 设置隐私条款是否默认勾选
  final bool? privacyState;

  /// 设置隐私条款⽂字对⻬⽅式，单位Gravity.xxx
  final int? protocolGravity;

  /// 设置隐私条款⽂字⼤⼩，单位sp
  final int? privacyTextSize;

  /// 设置隐私条款距离⼿机左右边缘的边距，单位dp
  final int? privacyMargin;

  /// 设置开发者隐私条款前置⾃定义25⽂案
  final String? privacyBefore;

  /// 设置开发者隐私条款尾部⾃定义⽂案
  final String? privacyEnd;

  /// 设置复选框是否隐藏
  final bool? checkboxHidden;

  /// 勾选框大小宽高等比 17*17 -> 17
  final int? checkBoxWH;

  /// 切换标题
  final String? changeBtnTitle;

  /// 切换标题大小
  final int? changeBtnTitleSize;

  /// 切换标题颜色
  final String? changeBtnTitleColor;

  /// 是否隐藏切换标题
  final bool? changeBtnIsHidden;

  /// 设置复选框未选中时图⽚
  final String? uncheckedImgPath;

  /// 设置复选框选中时图⽚
  final String? checkedImgPath;

  /// 设置运营商协议前缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
  final String? vendorPrivacyPrefix;

  /// 设置运营商协议后缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
  final String? vendorPrivacySuffix;

  /// 设置隐私栏的布局对⻬⽅式，该接⼝控制了整个隐私栏（包含checkbox）在其⽗布局中的对⻬⽅式，⽽setProtocolGravity控制的是隐私协议⽂字内容在⽂本框中的对⻬⽅式
  final int? protocolLayoutGravity;

  /// 设置隐私栏X轴偏移量，单位dp
  final int? privacyOffsetX;

  /// 设置checkbox未勾选时，点击登录按钮toast是否显示
  final bool? logBtnToastHidden;

  /// 7. 切换⽅式控件

  /// 设置切换按钮点是否可⻅
  final bool? switchAccHidden;

  /// 设置切换按钮⽂字内容
  final String? switchAccText;

  /// 设置切换按钮⽂字颜⾊
  final String? switchAccTextColor;

  /// 设置切换按钮⽂字⼤⼩
  final int? switchAccTextSize;

  /// 设置换按钮相对导航栏顶部的位移，单位 dp
  final int? switchOffsetY;

  /// 8. 第三方配置

  /// 是否隐藏第三方布局
  final bool? isHiddenCustom;

  /// 第三方图标相关参数只对iOS有效，android 请使用布局文件实现
  /// 第三方图标按钮居中布局
  /// 第三方布局图片路径
  final String? customThirdImgPaths;

  /// 第三方图标宽度
  final int? customThirdImgWidth;

  /// 第三方图标高度
  final int? customThirdImgHeight;

  /// 第三方图标间距
  final int? customThirdImgSpace;

  /// 第三方按钮的Y 默认值距离第三方标题向下20 大于50的时候为相对于状态栏的距离 即为从顶部向下多少
  final int? customThirdImgOffsetY;

  /// 8. ⻚⾯相关函数

  /// 设置授权⻚进场动画
  final String? authPageActIn;

  /// 设置授权⻚退出动画
  final String? authPageActOut;

  /// 设置授权⻚背景图drawable资源的⽬录，不需要加后缀，⽐如图⽚在drawable中的存放⽬录是res/drawablexxhdpi/loading.png,则传⼊参数为"loading"，setPageBackgroundPath("loading")。
  final String? pageBackgroundPath;

  /// dialog 蒙层的透明度
  final double? dialogAlpha;

  /// 设置弹窗模式授权⻚宽度，单位dp,设置⼤于0即为弹窗模式
  final int? dialogWidth;

  /// 设置弹窗模式授权⻚⾼度，单位dp，设置⼤于0即为弹窗模式
  final int? dialogHeight;

  /// 设置弹窗模式授权⻚X轴偏移，单位dp
  final int? dialogOffsetX;

  /// 设置弹窗模式授权⻚Y轴偏移,单位dp
  final int? dialogOffsetY;

  /// 设置授权⻚是否居于底部
  final bool? dialogBottom;

  /// ios 弹窗设置参数
  /// 是否隐藏bar bar 为true 时 alertCloseItemIsHidden 也为true
  final bool? alertBarIsHidden;

  /// bar的背景色 默认颜色为白色 #FFFFFF
  final String? alertTitleBarColor;

  /// bar的关闭按钮
  final bool? alertCloseItemIsHidden;

  /// 关闭按钮的图片路径
  final String? alertCloseImage;

  /// 关闭按钮的图片X坐标
  final int? alertCloseImageX;

  /// 关闭按钮的图片Y坐标
  final int? alertCloseImageY;

  /// 关闭按钮的图片宽度
  final int? alertCloseImageW;

  /// 关闭按钮的图片高度
  final int? alertCloseImageH;

  /// 底部蒙层背景颜色，默认黑色
  final String? alertBlurViewColor;

  /// 底部蒙层背景透明度，默认0.5 0 ~ 1
  final double? alertBlurViewAlpha;

  /// 窗口圆角 顺序为左上，左下，右下，右上，需要填充4个值，不足4个值则无效，如果值<=0则为直角 */
  final String? alertCornerRadiusArray;

  AliAuthModel(
    this.sk,
    this.isDialog,
    this.isDebug,
    this.customPageBackgroundLyout,
    this.statusBarColor,
    this.statusBarHidden,
    this.statusBarUIFlag,
    this.lightColor,
    this.navColor,
    this.navText,
    this.navTextColor,
    this.navTextSize,
    this.navReturnImgPath,
    this.navReturnImgWidth,
    this.navReturnImgHeight,
    this.navReturnHidden,
    this.navHidden,
    this.webViewStatusBarColor,
    this.webNavColor,
    this.webNavTextColor,
    this.webNavTextSize,
    this.webNavReturnImgPath,
    this.customNavReturnImageLayoutName,
    this.bottomNavColor,
    this.logoHidden,
    this.logoImgPath,
    this.logoWidth,
    this.logoHeight,
    this.logoOffsetY,
    this.logoScaleType,
    this.sloganHidden,
    this.sloganText,
    this.sloganTextColor,
    this.sloganTextSize,
    this.sloganOffsetY,
    this.numberColor,
    this.numberSize,
    this.numFieldOffsetY,
    this.numberFieldOffsetX,
    this.numberLayoutGravity,
    this.logBtnText,
    this.logBtnTextColor,
    this.logBtnTextSize,
    this.logBtnWidth,
    this.logBtnHeight,
    this.logBtnMarginLeftAndRight,
    this.logBtnBackgroundPath,
    this.logBtnOffsetY,
    this.loadingImgPath,
    this.logBtnOffsetX,
    this.logBtnLayoutGravity,
    this.appPrivacyOne,
    this.appPrivacyTwo,
    this.appPrivacyColor,
    this.privacyOffsetY,
    this.protocolGravity,
    this.privacyTextSize,
    this.privacyMargin,
    this.privacyBefore,
    this.privacyEnd,
    this.privacyState,
    this.checkboxHidden,
    this.checkBoxWH,
    this.changeBtnTitle,
    this.changeBtnTitleSize,
    this.changeBtnTitleColor,
    this.changeBtnIsHidden,
    this.uncheckedImgPath,
    this.checkedImgPath,
    this.vendorPrivacyPrefix,
    this.vendorPrivacySuffix,
    this.protocolLayoutGravity,
    this.privacyOffsetX,
    this.logBtnToastHidden,
    this.switchAccHidden,
    this.switchAccText,
    this.switchAccTextColor,
    this.switchAccTextSize,
    this.switchOffsetY,
    this.isHiddenCustom,
    this.customThirdImgPaths,
    this.customThirdImgWidth,
    this.customThirdImgHeight,
    this.customThirdImgSpace,
    this.customThirdImgOffsetY,
    this.authPageActIn,
    this.authPageActOut,
    this.pageBackgroundPath,
    this.dialogAlpha,
    this.dialogWidth,
    this.dialogHeight,
    this.dialogOffsetX,
    this.dialogOffsetY,
    this.dialogBottom,
    this.alertBarIsHidden,
    this.alertTitleBarColor,
    this.alertCloseItemIsHidden,
    this.alertCloseImage,
    this.alertCloseImageX,
    this.alertCloseImageY,
    this.alertCloseImageW,
    this.alertCloseImageH,
    this.alertBlurViewColor,
    this.alertBlurViewAlpha,
    this.alertCornerRadiusArray,
  );
  factory AliAuthModel.fromJson(Map<String, dynamic> srcJson) =>
      _$AliAuthModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$AliAuthModelToJson(this);
}

AliAuthModel _$AliAuthModelFromJson(Map<String, dynamic> json) {
  return AliAuthModel(
    json['sk'] as String?,
    json['isDialog'] as bool?,
    json['isDebug'] as bool?,
    json['customPageBackgroundLyout'] as bool?,
    json['statusBarColor'] as String?,
    json['statusBarHidden'] as bool?,
    json['statusBarUIFlag'] as int?,
    json['lightColor'] as bool?,
    json['navColor'] as String?,
    json['navText'] as String?,
    json['navTextColor'] as String?,
    json['navTextSize'] as int?,
    json['navReturnImgPath'] as String?,
    json['navReturnImgWidth'] as int?,
    json['navReturnImgHeight'] as int?,
    json['navReturnHidden'] as bool?,
    json['navHidden'] as bool?,
    json['webViewStatusBarColor'] as String?,
    json['webNavColor'] as String?,
    json['webNavTextColor'] as String?,
    json['webNavTextSize'] as int?,
    json['webNavReturnImgPath'] as String?,
    json['customNavReturnImageLayoutName'] as String?,
    json['bottomNavColor'] as String?,
    json['logoHidden'] as bool?,
    json['logoImgPath'] as String?,
    json['logoWidth'] as int?,
    json['logoHeight'] as int?,
    json['logoOffsetY'] as int?,
    json['logoScaleType'] as String?,
    json['sloganHidden'] as bool?,
    json['sloganText'] as String?,
    json['sloganTextColor'] as String?,
    json['sloganTextSize'] as int?,
    json['sloganOffsetY'] as int?,
    json['numberColor'] as String?,
    json['numberSize'] as int?,
    json['numFieldOffsetY'] as int?,
    json['numberFieldOffsetX'] as int?,
    json['numberLayoutGravity'] as int?,
    json['logBtnText'] as String?,
    json['logBtnTextColor'] as String?,
    json['logBtnTextSize'] as int?,
    json['logBtnWidth'] as int?,
    json['logBtnHeight'] as int?,
    json['logBtnMarginLeftAndRight'] as int?,
    json['logBtnBackgroundPath'] as String?,
    json['logBtnOffsetY'] as int?,
    json['loadingImgPath'] as String?,
    json['logBtnOffsetX'] as int?,
    json['logBtnLayoutGravity'] as int?,
    json['appPrivacyOne'] as String?,
    json['appPrivacyTwo'] as String?,
    json['appPrivacyColor'] as String?,
    json['privacyOffsetY'] as int?,
    json['protocolGravity'] as int?,
    json['privacyTextSize'] as int?,
    json['privacyMargin'] as int?,
    json['privacyBefore'] as String?,
    json['privacyEnd'] as String?,
    json['checkboxHidden'] as bool?,
    json['privacyState'] as bool?,
    json['checkBoxWH'] as int?,
    json['changeBtnTitle'] as String?,
    json['changeBtnTitleSize'] as int?,
    json['changeBtnTitleColor'] as String?,
    json['changeBtnIsHidden'] as bool?,
    json['uncheckedImgPath'] as String?,
    json['checkedImgPath'] as String?,
    json['vendorPrivacyPrefix'] as String?,
    json['vendorPrivacySuffix'] as String?,
    json['protocolLayoutGravity'] as int?,
    json['privacyOffsetX'] as int?,
    json['logBtnToastHidden'] as bool?,
    json['switchAccHidden'] as bool?,
    json['switchAccText'] as String?,
    json['switchAccTextColor'] as String?,
    json['switchAccTextSize'] as int?,
    json['switchOffsetY'] as int?,
    json['isHiddenCustom'] as bool?,
    json['customThirdImgPaths'] as String?,
    json['customThirdImgWidth'] as int?,
    json['customThirdImgHeight'] as int?,
    json['customThirdImgSpace'] as int?,
    json['customThirdImgOffsetY'] as int?,
    json['authPageActIn'] as String?,
    json['authPageActOut'] as String?,
    json['pageBackgroundPath'] as String?,
    json['dialogAlpha'] as double?,
    json['dialogWidth'] as int?,
    json['dialogHeight'] as int?,
    json['dialogOffsetX'] as int?,
    json['dialogOffsetY'] as int?,
    json['dialogBottom'] as bool?,
    json['alertBarIsHidden'] as bool?,
    json['alertTitleBarColor'] as String?,
    json['alertCloseItemIsHidden'] as bool?,
    json['alertCloseImage'] as String?,
    json['alertCloseImageX'] as int?,
    json['alertCloseImageY'] as int?,
    json['alertCloseImageW'] as int?,
    json['alertCloseImageH'] as int?,
    json['alertBlurViewColor'] as String?,
    json['alertBlurViewAlpha'] as double?,
    json['alertCornerRadiusArray'] as String?,
  );
}

Map<String, dynamic> _$AliAuthModelToJson(AliAuthModel instance) =>
    <String, dynamic>{
      'sk': instance.sk,
      'isDialog': instance.isDialog,
      'isDebug': instance.isDebug,
      'customPageBackgroundLyout': instance.customPageBackgroundLyout,
      'statusBarColor': instance.statusBarColor,
      'statusBarHidden': instance.statusBarHidden,
      'statusBarUIFlag': instance.statusBarUIFlag,
      'lightColor': instance.lightColor,
      'navColor': instance.navColor,
      'navText': instance.navText,
      'navTextColor': instance.navTextColor,
      'navTextSize': instance.navTextSize,
      'navReturnImgPath': instance.navReturnImgPath,
      'navReturnImgWidth': instance.navReturnImgWidth,
      'navReturnImgHeight': instance.navReturnImgHeight,
      'navReturnHidden': instance.navReturnHidden,
      'navHidden': instance.navHidden,
      'webViewStatusBarColor': instance.webViewStatusBarColor,
      'webNavColor': instance.webNavColor,
      'webNavTextColor': instance.webNavTextColor,
      'webNavTextSize': instance.webNavTextSize,
      'webNavReturnImgPath': instance.webNavReturnImgPath,
      'customNavReturnImageLayoutName': instance.customNavReturnImageLayoutName,
      'bottomNavColor': instance.bottomNavColor,
      'logoHidden': instance.logoHidden,
      'logoImgPath': instance.logoImgPath,
      'logoWidth': instance.logoWidth,
      'logoHeight': instance.logoHeight,
      'logoOffsetY': instance.logoOffsetY,
      'logoScaleType': instance.logoScaleType,
      'sloganHidden': instance.sloganHidden,
      'sloganText': instance.sloganText,
      'sloganTextColor': instance.sloganTextColor,
      'sloganTextSize': instance.sloganTextSize,
      'sloganOffsetY': instance.sloganOffsetY,
      'numberColor': instance.numberColor,
      'numberSize': instance.numberSize,
      'numFieldOffsetY': instance.numFieldOffsetY,
      'numberFieldOffsetX': instance.numberFieldOffsetX,
      'numberLayoutGravity': instance.numberLayoutGravity,
      'logBtnText': instance.logBtnText,
      'logBtnTextColor': instance.logBtnTextColor,
      'logBtnTextSize': instance.logBtnTextSize,
      'logBtnWidth': instance.logBtnWidth,
      'logBtnHeight': instance.logBtnHeight,
      'logBtnMarginLeftAndRight': instance.logBtnMarginLeftAndRight,
      'logBtnBackgroundPath': instance.logBtnBackgroundPath,
      'logBtnOffsetY': instance.logBtnOffsetY,
      'loadingImgPath': instance.loadingImgPath,
      'logBtnOffsetX': instance.logBtnOffsetX,
      'logBtnLayoutGravity': instance.logBtnLayoutGravity,
      'appPrivacyOne': instance.appPrivacyOne,
      'appPrivacyTwo': instance.appPrivacyTwo,
      'appPrivacyColor': instance.appPrivacyColor,
      'privacyOffsetY': instance.privacyOffsetY,
      'privacyState': instance.privacyState,
      'protocolGravity': instance.protocolGravity,
      'privacyTextSize': instance.privacyTextSize,
      'privacyMargin': instance.privacyMargin,
      'privacyBefore': instance.privacyBefore,
      'privacyEnd': instance.privacyEnd,
      'checkboxHidden': instance.checkboxHidden,
      'checkBoxWH': instance.checkBoxWH,
      'changeBtnTitle': instance.changeBtnTitle,
      'changeBtnTitleSize': instance.changeBtnTitleSize,
      'changeBtnTitleColor': instance.changeBtnTitleColor,
      'changeBtnIsHidden': instance.changeBtnIsHidden,
      'uncheckedImgPath': instance.uncheckedImgPath,
      'checkedImgPath': instance.checkedImgPath,
      'vendorPrivacyPrefix': instance.vendorPrivacyPrefix,
      'vendorPrivacySuffix': instance.vendorPrivacySuffix,
      'protocolLayoutGravity': instance.protocolLayoutGravity,
      'privacyOffsetX': instance.privacyOffsetX,
      'logBtnToastHidden': instance.logBtnToastHidden,
      'switchAccHidden': instance.switchAccHidden,
      'switchAccText': instance.switchAccText,
      'switchAccTextColor': instance.switchAccTextColor,
      'switchAccTextSize': instance.switchAccTextSize,
      'switchOffsetY': instance.switchOffsetY,
      'isHiddenCustom': instance.isHiddenCustom,
      'customThirdImgPaths': instance.customThirdImgPaths,
      'customThirdImgWidth': instance.customThirdImgWidth,
      'customThirdImgHeight': instance.customThirdImgHeight,
      'customThirdImgSpace': instance.customThirdImgSpace,
      'customThirdImgOffsetY': instance.customThirdImgOffsetY,
      'authPageActIn': instance.authPageActIn,
      'authPageActOut': instance.authPageActOut,
      'pageBackgroundPath': instance.pageBackgroundPath,
      'dialogAlpha': instance.dialogAlpha,
      'dialogWidth': instance.dialogWidth,
      'dialogHeight': instance.dialogHeight,
      'dialogOffsetX': instance.dialogOffsetX,
      'dialogOffsetY': instance.dialogOffsetY,
      'dialogBottom': instance.dialogBottom,
      'alertBarIsHidden': instance.alertBarIsHidden,
      'alertTitleBarColor': instance.alertTitleBarColor,
      'alertCloseItemIsHidden': instance.alertCloseItemIsHidden,
      'alertCloseImage': instance.alertCloseImage,
      'alertCloseImageX': instance.alertCloseImageX,
      'alertCloseImageY': instance.alertCloseImageY,
      'alertCloseImageW': instance.alertCloseImageW,
      'alertCloseImageH': instance.alertCloseImageH,
      'alertBlurViewColor': instance.alertBlurViewColor,
      'alertBlurViewAlpha': instance.alertBlurViewAlpha,
      'alertCornerRadiusArray': instance.alertCornerRadiusArray,
    };

/// 初始配置&注意事项
/// 所有关于路径的字段需要在android/app/src/main/res/drawable 或者 drawable-xxxxxx 目录下有对应资源
/// 所有设置的大小都为dp 或者 单位 如果px 单位需要转换
/// 所有颜色设置为 十六进制颜色代码 加上两位数的透明度 例如 #00ffffff 为透明  #ffffff为白色
/// 当设置参数isdialog为false时 dialog 相关设置参数设置无效
/// 默认开启自定义第三方布局 加载文件为android/app/src/main/res/layout/custom_login.xml 名称的xml布局文件 如果自定义，修改改文件即可
/// 在自定义登录布局中点击事件返回的状态吗统一为returnCode：700005 returnData：点击的第几个按钮 // 具体看md
/// 参数dialogOffsetX dialogOffsetY 设置为-1 默认为居中
/// 关于弹窗的梦层设置 android/app/src/main/res/value/style.xml authsdk_activity_dialog参数设置
/// 当开启customPageBackgroundLyout 参数时 请确保layout 文件夹下有custom_page_background 名称布局文件，否则加载默认布局文件
/// ios 当开启customPageBackgroundLyout时 navReturnImgPath navReturnImgWidth/navReturnImgHeight理论最大高度45左右参数为必须参数否则报错
/// 'appPrivacyOne'、'appPrivacyTwo' 字段中的逗号拼接处请勿使用多余的空格，以免出现未知错误
AliAuthModel getConfig() {
  return AliAuthModel.fromJson({
    'isDialog': false,
    'isDebug': true,
    'customPageBackgroundLyout': true,
    'isHiddenCustom': true,
    'statusBarColor': "#00ffffff",
    'statusBarHidden': false,
    'statusBarUIFlag': 1024,
    'lightColor': true,
    'navColor': "#00ff00ff",
    'navText': '一键登录',
    'navTextColor': "#00333333",
    'navTextSize': -1,
    'navReturnImgPath': 'icon_close',
    'customNavReturnImageLayoutName': '0',
    'navReturnHidden': false,
    'navReturnImgWidth': 30,
    'navReturnImgHeight': 30,
    'navReturnOffsetX': 15,
    'navReturnOffsetY': 5,
    'navHidden': false,
    'webViewStatusBarColor': "#ffff00",
    'webNavColor': "#00ffff",
    'webNavTextColor': "#ff0000",
    'webNavTextSize': 15,
    'bottomNavColor': "#ffffff",
    'logoHidden': false,
    'logoImgPath': 'assets/taobao.png',
    'logoWidth': 100,
    'logoHeight': 100,
    'logoOffsetY': 20,
    'logoScaleType': "CENTER",
    'sloganHidden': false,
    'sloganText': '一键登录欢迎语',
    'sloganTextColor': "#555555",
    'sloganTextSize': 30,
    'sloganOffsetY': 150,
    'numberColor': "#555fff",
    'numberSize': 23,
    'numFieldOffsetY': 240,
    'numberFieldOffsetX': 0,
    'numberLayoutGravity': 0,
    'logBtnText': '一键登录',
    'logBtnTextColor': '#ffffff',
    'logBtnTextSize': 20,
    'logBtnWidth': 300,
    'logBtnHeight': 40,
    'logBtnMarginLeftAndRight': 33,
    'logBtnBackgroundPath':
        'assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png',
    'logBtnOffsetY': 300,
    'loadingImgPath': '',
    'logBtnOffsetX': 0,
    'logBtnLayoutGravity': 10,
    'appPrivacyOne': '思预云用户协议,https://www.baidu.com',
    'appPrivacyTwo': '用户隐私,https://www.baidu.com',
    'appPrivacyColor': '#445588,#3971fe',
    'privacyOffsetY': 560,
    'privacyState': true,
    'protocolGravity': 0,
    'privacyTextSize': 11,
    'privacyMargin': 20,
    'privacyBefore': '点击一键登录并登录表示您已阅读并同意',
    'privacyEnd': '思预云用户协议，隐私',
    'checkboxHidden': false,
    'checkBoxWH': 17,
    'changeBtnTitle': '切换到其他',
    'changeBtnTitleSize': 17,
    'changeBtnTitleColor': '#ff0000',
    'changeBtnIsHidden': false,
    'uncheckedImgPath': '',
    'checkedImgPath': '',
    'vendorPrivacyPrefix': '《',
    'vendorPrivacySuffix': '》',
    'protocolLayoutGravity': 10,
    'privacyOffsetX': 0,
    'logBtnToastHidden': true,
    'switchAccHidden': false,
    'switchAccText': '其他手机号登录',
    'switchAccTextColor': '',
    'switchAccTextSize': 19,
    'switchOffsetY': -1,
    'customThirdImgPaths':
        'assets/taobao.png,assets/tianmao.png,assets/taobao.png',
    'customThirdImgWidth': 70,
    'customThirdImgHeight': 70,
    'customThirdImgSpace': 30,
    'customThirdImgOffsetY': 20,
    'authPageActIn': 'in_activity,out_activity',
    'authPageActOut': 'in_activity,out_activity',
    'pageBackgroundPath': 'page_background_color',
  });
}

/// dialogBottom 为false时 默认水平垂直居中
/// 如果需要修改弹窗的圆角背景可修改android/app/src/main/res/drawable/dialog_background_color.xml 文件
/// 'appPrivacyOne'、'appPrivacyTwo' 字段中的逗号拼接处请勿使用多余的空格，以免出现未知错误
AliAuthModel getDislogConfig() {
  final screenWidth =
      (window.physicalSize.width / window.devicePixelRatio * 0.8).floor();
  final screenHeight =
      (window.physicalSize.height / window.devicePixelRatio * 0.65).floor();
  int logBtnOffset = (screenHeight / 2).floor();
  return AliAuthModel.fromJson({
    'isDialog': true,
    'isDebug': true,
    'customPageBackgroundLyout': false,
    'isHiddenCustom': true,
    'statusBarColor': "#00000000",
    'statusBarHidden': true,
    'statusBarUIFlag': -1,
    'lightColor': true,
    'navColor': "#ff00ff",
    'navText': '一键登录',
    'navTextColor': "#333333",
    'navTextSize': -1,
    'navReturnImgPath': 'icon_close',
    'navReturnImgWidth': 30,
    'navReturnImgHeight': 30,
    'navReturnHidden': false,
    'navHidden': false,
    'logoHidden': false,
    'logoImgPath': 'assets/taobao.png',
    'logoWidth': 48,
    'logoHeight': 48,
    'logoOffsetY': 20,
    'logoScaleType': "CENTER",
    'sloganHidden': false,
    'sloganText': '一键登录欢迎语',
    'sloganTextColor': "#555555",
    'sloganTextSize': 11,
    'sloganOffsetY': logBtnOffset - 100,
    'numberColor': "#555fff",
    'numberSize': 15,
    'numFieldOffsetY': logBtnOffset - 50,
    'logBtnText': '一键登录',
    'logBtnTextColor': '#ffffff',
    'logBtnTextSize': 16,
    'logBtnHeight': 38,
    'logBtnMarginLeftAndRight': 15,
    'logBtnBackgroundPath':
        'assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png',
    'logBtnOffsetY': logBtnOffset,
    'loadingImgPath': '',
    'appPrivacyOne': '思预云用户协议,https://www.baidu.com',
    'appPrivacyTwo': '用户隐私,https://www.baidu.com',
    'appPrivacyColor': '#445588,#3971fe',
    'privacyState': false,
    'protocolGravity': 0,
    'privacyTextSize': 11,
    'privacyMargin': 20,
    'checkBoxWH': 17,
    'changeBtnTitle': '切换到其他',
    'changeBtnTitleSize': 18,
    'changeBtnTitleColor': '#ff0000',
    'changeBtnIsHidden': false,
    'vendorPrivacyPrefix': '《',
    'vendorPrivacySuffix': '》',
    'protocolLayoutGravity': 10,
    'switchAccTextSize': 11,
    'switchOffsetY': logBtnOffset + 50,
    'customThirdImgPaths':
        'assets/taobao.png,assets/tianmao.png,assets/taobao.png',
    'customThirdImgWidth': 40,
    'customThirdImgHeight': 40,
    'customThirdImgSpace': 20,
    'customThirdImgOffsetY': 20,
    'authPageActIn': 'in_activity,out_activity',
    'authPageActOut': 'in_activity,out_activity',
    'pageBackgroundPath': 'dialog_background_color',
    'dialogAlpha': 0.5,
    'dialogWidth': screenWidth,
    'dialogHeight': screenHeight,
    'dialogOffsetX': -1,
    'dialogOffsetY': -1,
    'dialogBottom': false,
    'alertBarIsHidden': false,
    'alertTitleBarColor': '#ffffff',
    'alertCloseItemIsHidden': false,
    'alertCloseImage': 'assets/close.png',
    'alertCloseImageX': 10,
    'alertCloseImageY': 10,
    'alertCloseImageW': 10,
    'alertCloseImageH': 10,
    'alertBlurViewColor': '#000',
    'alertBlurViewAlpha': 0.7,
    'alertCornerRadiusArray': '10,10,10,10',
  });
}
