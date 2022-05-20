import 'ali_auth_enum.dart';

/// 登录窗口配置
class AliAuthModel {
  /// aliyun sk
  final String? androidSk;

  /// aliyun sk
  final String? iosSk;

  /// 是否开启debug模式
  final bool? isDebug;

  /// 是否延迟
  final bool? isDelay;

  /// 页面类型 必须
  final PageType? pageType;

  // /// 8. ⻚⾯相关函数
  //
  // /// 设置授权⻚进场动画
  // final String? authPageActIn;
  //
  // /// 设置授权⻚退出动画
  // final String? authPageActOut;
  //
  // /// 设置授权⻚背景图drawable资源的⽬录，不需要加后缀，⽐如图⽚在drawable中的存放⽬录是res/drawablexxhdpi/loading.png,则传⼊参数为"loading"，setPageBackgroundPath("loading")。
  // final String? pageBackgroundPath;
  //
  // /// dialog 蒙层的透明度
  // final double? dialogAlpha;
  //
  // /// 设置弹窗模式授权⻚宽度，单位dp,设置⼤于0即为弹窗模式
  // final int? dialogWidth;
  //
  // /// 设置弹窗模式授权⻚⾼度，单位dp，设置⼤于0即为弹窗模式
  // final int? dialogHeight;
  //
  // /// 设置弹窗模式授权⻚X轴偏移，单位dp
  // final int? dialogOffsetX;
  //
  // /// 设置弹窗模式授权⻚Y轴偏移,单位dp
  // final int? dialogOffsetY;
  //
  // /// 设置授权⻚是否居于底部
  // final bool? dialogBottom;
  //
  /// ------- 一、状态栏 --------- ///

  /// statusBarColor 设置状态栏颜⾊（系统版本 5.0 以上可设置）
  final String? statusBarColor;

  /// 设置状态栏文字颜色(系统版本6.0以上可设置黑色白色)，true为黑色
  final bool? isLightColor;

  /// 设置状态栏是否隐藏
  final bool? isStatusBarHidden;

  /// 设置状态栏U属性
  final UIFAG? statusBarUIFlag;

  /// 设置协议⻚状态栏颜⾊（系统版本 5.0 以上可设置）不设置则与授权⻚设置⼀致
  final String? webViewStatusBarColor;

  /// ------- 二、导航栏 --------- ///

  /// 设置默认导航栏是否隐藏
  final bool? navHidden;

  /// 设置导航栏主题色
  final String? navColor;

  /// 设置导航栏标题文案内容
  final String? navText;

  /// 设置导航栏标题文字颜色
  final String? navTextColor;

  /// 设置导航栏标题文字大小
  /// @Deprecated("即将删除的属性......")
  final int? navTextSize;

  /// 设置导航栏返回按钮图片路径
  final String? navReturnImgPath;

  /// 设置导航栏返回按钮隐藏
  final bool? navReturnHidden;

  /// 设置导航栏返回按钮宽度
  final int? navReturnImgWidth;

  /// 设置导航栏返回按钮隐藏高度
  final int? navReturnImgHeight;

  /// 设置导航栏返回按钮缩放模式
  final ScaleType? navReturnScaleType;

  /// 设置协议页顶部导航栏背景色不设置则与授权页设置一致
  final String? webNavColor;

  /// 设置协议页顶部导航栏标题颜色不设置则与授权页设置一致
  final String? webNavTextColor;

  /// 设置协议页顶部导航栏文字大小不设置则与授权页设置一
  final int? webNavTextSize;

  /// 设置协议页导航栏返回按钮图片路径不设置则与授权页设
  final String? webNavReturnImgPath;

  /// ------- 三、LOGO区 --------- ///

  /// 设置logo 图⽚
  final String? logoImgPath;

  /// 隐藏logo
  final bool? logoHidden;

  /// 设置logo 控件宽度
  final int? logoWidth;

  /// 设置logo 控件⾼度
  final int? logoHeight;

  /// 设置logo 控件相对导航栏顶部的位移，单位dp
  final int? logoOffsetY;

  /// 设置logo 控件相对底部的位移，单位dp
  // ignore: non_constant_identifier_names
  final int? logoOffsetY_B;

  /// 设置logo图⽚缩放模式
  /// FIT_XY,
  /// FIT_START,
  /// FIT_CENTER,
  /// FIT_END,
  /// CENTER,
  /// CENTER_CROP,
  /// CENTER_INSIDE
  final ScaleType? logoScaleType;

  /// ------- 四、slogan区 --------- ///

  /// 设置是否隐藏slogan
  final bool? sloganHidden;

  /// 设置slogan ⽂字内容
  final String? sloganText;

  /// 设置slogan ⽂字颜⾊
  final String? sloganTextColor;

  /// 设置slogan ⽂字⼤⼩
  /// @Deprecated("即将删除的属性......")
  final int? sloganTextSize;

  /// 设置slogan 相对导航栏顶部的 位移，单位dp
  final int? sloganOffsetY;

  /// 设置slogan 相对底部的 位移，单位dp
  // ignore: non_constant_identifier_names
  final int? sloganOffsetY_B;

  /// ------- 五、掩码栏 --------- ///

  /// 设置⼿机号码字体颜⾊
  final String? numberColor;

  /// 设置⼿机号码字体⼤⼩
  /// @Deprecated("即将删除的属性......")
  final int? numberSize;

  /// 设置号码栏控件相对导航栏顶部的位移，单位 dp
  final int? numFieldOffsetY;

  /// 设置号码栏控件相对底部的位移，单位 dp
  // ignore: non_constant_identifier_names
  final int? numFieldOffsetY_B;

  /// 设置号码栏相对于默认位置的X轴偏移量，单位dp
  final int? numberFieldOffsetX;

  /// 设置⼿机号掩码的布局对⻬⽅式，只⽀持
  /// Gravity.CENTER_HORIZONTAL、
  /// Gravity.LEFT、
  /// Gravity.RIGHT三种对⻬⽅式
  final Gravity? numberLayoutGravity;

  /// ------- 六、登录按钮 --------- ///

  /// 设置登录按钮⽂字
  final String? logBtnText;

  /// 设置登录按钮⽂字颜⾊
  final String? logBtnTextColor;

  /// 设置登录按钮⽂字⼤⼩
  /// @Deprecated("即将删除的属性......")
  final int? logBtnTextSize;

  /// 设置登录按钮宽度，单位 dp
  final int? logBtnWidth;

  /// 设置登录按钮⾼度，单位dp
  final int? logBtnHeight;

  /// 设置登录按钮相对于屏幕左右边缘边距
  final int? logBtnMarginLeftAndRight;

  /// login_btn_bg_xml
  /// 设置登录按钮背景图⽚路径 是一个逗号拼接的图片路径 例如：'assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png'
  /// 如果设置错误或者找不到图片则使用默认样式
  final String? logBtnBackgroundPath;

  /// 设置登录按钮相对导航栏顶部的位移，单位 dp
  final int? logBtnOffsetY;

  /// 设置登录按钮相对底部的位移，单位 dp
  // ignore: non_constant_identifier_names
  final int? logBtnOffsetY_B;

  /// 设置登录loading dialog 背景图⽚路径24
  final String? loadingImgPath;

  /// 设置登陆按钮X轴偏移量，如果设置了setLogBtnMarginLeftAndRight，并且布局对⻬⽅式为左对⻬或者右对⻬,则会在margin的基础上再增加offsetX的偏移量，如果是居中对⻬，则仅仅会在居中的基础上再做offsetX的偏移。
  final int? logBtnOffsetX;

  /// 设置登陆按钮布局对⻬⽅式，
  /// 只⽀持Gravity.CENTER_HORIZONTAL、
  /// Gravity.LEFT、
  /// Gravity.RIGHT三种对⻬⽅式
  final Gravity? logBtnLayoutGravity;

  /// ------- 七、切换到其他方式 --------- ///

  /// 设置切换按钮点是否可⻅
  final bool? switchAccHidden;

  /// 设置切换按钮⽂字内容
  final String? switchAccText;

  /// 设置切换按钮⽂字颜⾊
  final String? switchAccTextColor;

  /// 设置切换按钮⽂字⼤⼩
  /// @Deprecated("即将删除的属性......")
  final int? switchAccTextSize;

  /// 设置换按钮相对导航栏顶部的位移，单位 dp
  final int? switchOffsetY;

  /// 设置换按钮相对底部的位移，单位 dp
  // ignore: non_constant_identifier_names
  final int? switchOffsetY_B;

  /// ------- 八、自定义控件区 --------- ///

  /// 是否隐藏第三方布局
  final bool? isHiddenCustom;

  /// 第三方图标相关参数只对iOS有效，android 请使用布局文件实现
  /// 第三方图标按钮居中布局
  /// 第三方布局图片路径
  final CustomThirdView? customThirdView;

  /// ------- 九、协议栏 --------- ///

  /// 自定义第一条名称
  final String? protocolOneName;

  /// 自定义第一条url
  final String? protocolOneURL;

  /// 自定义第二条名称
  final String? protocolTwoName;

  /// 自定义第二条url
  final String? protocolTwoURL;

  /// 自定义第三条名称
  final String? protocolThreeName;

  /// 自定义第三条url
  final String? protocolThreeURL;

  /// 自定义协议名称颜色
  final String? protocolCustomColor;

  /// 基础文字颜色
  final String? protocolColor;

  /// ------- 十、其它全屏属性 --------- ///

  /// 设置隐私条款相对导航栏顶部的位移，单位dp
  final int? privacyOffsetY;

  /// 设置隐私条款相对底部的位移，单位dp
  // ignore: non_constant_identifier_names
  final int? privacyOffsetY_B;

  /// 设置隐私条款是否默认勾选
  final bool? privacyState;

  /// 设置隐私条款文字对齐方式，单位Gravity.xx
  final Gravity? protocolLayoutGravity;

  /// 设置隐私条款文字大小
  final int? privacyTextSize;

  /// 设置隐私条款距离手机左右边缘的边距，单位dp
  final int? privacyMargin;

  /// 设置开发者隐私条款前置自定义文案
  final String? privacyBefore;

  /// 设置开发者隐私条款尾部自定义文案
  final String? privacyEnd;

  /// 设置复选框是否隐藏
  final bool? checkboxHidden;

  /// 设置复选框未选中时图片
  final String? uncheckedImgPath;

  /// 设置复选框未选中时图片
  final String? checkedImgPath;

  /// 复选框图片的宽度
  final int? checkBoxWidth;

  /// 复选框图片的高度
  final int? checkBoxHeight;

  /// 设置隐私栏的布局对齐方式，该接口控制了整个隐私栏
  final Gravity? protocolGravity;

  /// 设置隐私条款X的位移，单位dp
  final int? privacyOffsetX;

  /// 设置运营商协议后缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
  final String? vendorPrivacyPrefix;

  /// 设置运营商协议后缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
  final String? vendorPrivacySuffix;

  /// 设置checkbox未勾选时，点击登录按钮toast是否隐藏
  final bool? logBtnToastHidden;

  /// 设置底部虚拟按键背景⾊（系统版本 5.0 以上可设置）
  final String? bottomNavColor;

  /// 弹窗宽度
  final int? dialogWidth;

  /// 弹窗高度
  final int? dialogHeight;
  final bool? dialogBottom;
  final int? dialogOffsetX;
  final int? dialogOffsetY;
  final List<int> ? dialogCornerRadiusArray;
  final double? dialogAlpha;
  final String? pageBackgroundPath;

  /// 背景图片圆角
  final int? pageBackgroundRadius;
  final bool? webSupportedJavascript;
  final String? authPageActIn;
  final String? activityOut;
  final String? authPageActOut;
  final String? activityIn;
  final int? screenOrientation;
  final List<String>? privacyConectTexts;
  final int? privacyOperatorIndex;

  /// 暴露名
  final String? protocolAction;

  /// 包名
  final String? packageName;

  final String? loadingBackgroundPath;

  /// 是否隐藏loading
  final bool? isHiddenLoading;

  /// 底部虚拟导航栏
  final String? bottomNavBarColor;

  // 授权页面背景路径支持视频mp4，mov等、图片jpeg，jpg，png等、动图gif
  final String? backgroundPath;



  /// /// ------- 十一、ios 弹窗设置参数 --------- ///
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

  final PNSPresentationDirection? presentDirection;

  const AliAuthModel(this.androidSk, this.iosSk,
      {this.isDebug = true,
      this.isDelay = false,
      this.pageType = PageType.fullPort,
      this.privacyOffsetX,
      this.statusBarColor,
      this.bottomNavColor,
      this.isLightColor,
      this.isStatusBarHidden,
      this.statusBarUIFlag,
      this.navColor,
      this.navText,
      this.navTextColor,
      this.navReturnImgPath,
      this.navReturnImgWidth,
      this.navReturnImgHeight,
      this.navReturnHidden,
      this.navReturnScaleType,
      this.navHidden,
      this.logoImgPath,
      this.logoHidden,
      this.numberColor,
      this.numberSize,
      this.switchAccHidden,
      this.switchAccTextColor,
      this.logBtnText,
      this.logBtnTextSize,
      this.logBtnTextColor,
      this.protocolOneName,
      this.protocolOneURL,
      this.protocolTwoName,
      this.protocolTwoURL,
      this.protocolThreeName,
      this.protocolThreeURL,
      this.protocolCustomColor,
      this.protocolColor,
      this.protocolLayoutGravity,
      this.sloganTextColor,
      this.sloganText,
      this.logBtnBackgroundPath,
      this.loadingImgPath,
      this.sloganOffsetY,
      this.logoOffsetY,
      // ignore: non_constant_identifier_names
      this.logoOffsetY_B,
      this.logoScaleType,
      this.numFieldOffsetY,
      // ignore: non_constant_identifier_names
      this.numFieldOffsetY_B,
      this.numberFieldOffsetX,
      this.numberLayoutGravity,
      this.switchOffsetY,
      // ignore: non_constant_identifier_names
      this.switchOffsetY_B,
      this.logBtnOffsetY,
      // ignore: non_constant_identifier_names
      this.logBtnOffsetY_B,
      this.logBtnWidth,
      this.logBtnHeight,
      this.logBtnOffsetX,
      this.logBtnMarginLeftAndRight,
      this.logBtnLayoutGravity,
      this.privacyOffsetY,
      // ignore: non_constant_identifier_names
      this.privacyOffsetY_B,
      // ignore: non_constant_identifier_names
      this.sloganOffsetY_B,
      this.checkBoxWidth,
      this.checkBoxHeight,
      this.checkboxHidden,
      this.navTextSize,
      this.logoWidth,
      this.logoHeight,
      this.switchAccTextSize,
      this.switchAccText,
      this.sloganTextSize,
      this.sloganHidden,
      this.uncheckedImgPath,
      this.checkedImgPath,
      this.privacyState,
      this.protocolGravity,
      this.privacyTextSize,
      this.privacyMargin,
      this.privacyBefore,
      this.privacyEnd,
      this.vendorPrivacyPrefix,
      this.vendorPrivacySuffix,
      this.dialogWidth,
      this.dialogHeight,
      this.dialogBottom,
      this.dialogOffsetX,
      this.dialogOffsetY,
      this.dialogCornerRadiusArray,
      this.pageBackgroundPath,
      this.pageBackgroundRadius,
      this.webViewStatusBarColor,
      this.webNavColor,
      this.webNavTextColor,
      this.webNavTextSize,
      this.webNavReturnImgPath,
      this.webSupportedJavascript,
      this.authPageActIn,
      this.activityOut,
      this.authPageActOut,
      this.activityIn,
      this.screenOrientation,
      this.logBtnToastHidden,
      this.dialogAlpha,
      this.privacyOperatorIndex,
      this.privacyConectTexts,
      this.protocolAction,
      this.packageName,
      this.loadingBackgroundPath,
      this.isHiddenLoading,
      this.isHiddenCustom,
      this.customThirdView,
      /**
         * "assets/background_gif.gif"
         * "assets/background_gif1.gif"
         * "assets/background_gif2.gif"
         * "assets/background_image.jpeg"
         * "assets/background_video.mp4"
         *
         * "https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-7/20187232061776607.gif"
         * "https://img.zcool.cn/community/01dda35912d7a3a801216a3e3675b3.gif",
         */
      this.backgroundPath = "assets/background_image.jpeg",
      this.bottomNavBarColor,
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
      this.presentDirection})
      : assert(androidSk != null || iosSk != null),
        assert(pageType != null),
        assert(isDelay != null);

  Map<String, dynamic> toJson() => _$AliAuthModelToJson(this);
}

Map<String, dynamic> _$AliAuthModelToJson(AliAuthModel instance) =>
    <String, dynamic>{
      'androidSk': instance.androidSk,
      'iosSk': instance.iosSk,
      'isDebug': instance.isDebug,
      'isDelay': instance.isDelay,
      'pageType': instance.pageType?.index ?? 0,
      'statusBarColor': instance.statusBarColor,
      'bottomNavColor': instance.bottomNavColor,
      'isLightColor': instance.isLightColor,
      'isStatusBarHidden': instance.isStatusBarHidden,
      'statusBarUIFlag': EnumUtils.formatUiFagValue(instance.statusBarUIFlag),
      'navColor': instance.navColor,
      'navText': instance.navText,
      'navTextColor': instance.navTextColor,
      'navReturnImgPath': instance.navReturnImgPath,
      'navReturnImgWidth': instance.navReturnImgWidth,
      'navReturnImgHeight': instance.navReturnImgHeight,
      'navReturnHidden': instance.navReturnHidden,
      'navReturnScaleType': instance.navReturnScaleType?.index ?? 0,
      'navHidden': instance.navHidden,
      'logoImgPath': instance.logoImgPath,
      'logoHidden': instance.logoHidden,
      'numberColor': instance.numberColor,
      'numberSize': instance.numberSize,
      'switchAccHidden': instance.switchAccHidden,
      'switchAccTextColor': instance.switchAccTextColor,
      'logBtnText': instance.logBtnText,
      'logBtnTextSize': instance.logBtnTextSize,
      'logBtnTextColor': instance.logBtnTextColor,
      'sloganTextColor': instance.sloganTextColor,
      'sloganText': instance.sloganText,
      'logBtnBackgroundPath': instance.logBtnBackgroundPath,
      'loadingImgPath': instance.loadingImgPath,
      'sloganOffsetY': instance.sloganOffsetY,
      'logoOffsetY': instance.logoOffsetY,
      'logoOffsetY_B': instance.logoOffsetY_B,
      'logoScaleType': instance.logoScaleType?.index ?? 2,
      'numFieldOffsetY': instance.numFieldOffsetY,
      'numFieldOffsetY_B': instance.numFieldOffsetY_B,
      'numberFieldOffsetX': instance.numberFieldOffsetX,
      'numberLayoutGravity':
          EnumUtils.formatGravityValue(instance.numberLayoutGravity),
      'switchOffsetY': instance.switchOffsetY,
      'switchOffsetY_B': instance.switchOffsetY_B,
      'logBtnOffsetY': instance.logBtnOffsetY,
      'logBtnOffsetY_B': instance.logBtnOffsetY_B,
      'logBtnWidth': instance.logBtnWidth,
      'logBtnHeight': instance.logBtnHeight,
      'logBtnOffsetX': instance.logBtnOffsetX,
      'logBtnMarginLeftAndRight': instance.logBtnMarginLeftAndRight,
      'logBtnLayoutGravity':
          EnumUtils.formatGravityValue(instance.logBtnLayoutGravity),
      'sloganOffsetY_B': instance.sloganOffsetY_B,
      'checkBoxWidth': instance.checkBoxWidth,
      'checkBoxHeight': instance.checkBoxHeight,
      'checkboxHidden': instance.checkboxHidden,
      'navTextSize': instance.navTextSize,
      'logoWidth': instance.logoWidth,
      'logoHeight': instance.logoHeight,
      'switchAccTextSize': instance.switchAccTextSize,
      'switchAccText': instance.switchAccText,
      'sloganTextSize': instance.sloganTextSize,
      'sloganHidden': instance.sloganHidden,
      'uncheckedImgPath': instance.uncheckedImgPath,
      'checkedImgPath': instance.checkedImgPath,
      'vendorPrivacyPrefix': instance.vendorPrivacyPrefix,
      'vendorPrivacySuffix': instance.vendorPrivacySuffix,
      'dialogWidth': instance.dialogWidth,
      'dialogHeight': instance.dialogHeight,
      'dialogBottom': instance.dialogBottom,
      'dialogOffsetX': instance.dialogOffsetX,
      'dialogOffsetY': instance.dialogOffsetY,
      'dialogAlpha': instance.dialogAlpha,
      'dialogCornerRadiusArray': instance.dialogCornerRadiusArray,
      'webViewStatusBarColor': instance.webViewStatusBarColor,
      'webNavColor': instance.webNavColor,
      'webNavTextColor': instance.webNavTextColor,
      'webNavTextSize': instance.webNavTextSize,
      'webNavReturnImgPath': instance.webNavReturnImgPath,
      'webSupportedJavascript': instance.webSupportedJavascript,
      'authPageActIn': instance.authPageActIn,
      'activityOut': instance.activityOut,
      'authPageActOut': instance.authPageActOut,
      'activityIn': instance.activityIn,
      'screenOrientation': instance.screenOrientation,
      'logBtnToastHidden': instance.logBtnToastHidden,
      'pageBackgroundPath': instance.pageBackgroundPath,
      'pageBackgroundRadius': instance.pageBackgroundRadius,
      'protocolOneName': instance.protocolOneName,
      'protocolOneURL': instance.protocolOneURL,
      'protocolTwoName': instance.protocolTwoName,
      'protocolTwoURL': instance.protocolTwoURL,
      'protocolColor': instance.protocolColor,
      'protocolLayoutGravity':
          EnumUtils.formatGravityValue(instance.protocolLayoutGravity),
      'protocolThreeName': instance.protocolThreeName,
      'protocolThreeURL': instance.protocolThreeURL,
      'protocolCustomColor': instance.protocolCustomColor,
      'protocolAction': instance.protocolAction,
      'privacyState': instance.privacyState,
      'protocolGravity': EnumUtils.formatGravityValue(instance.protocolGravity),
      'privacyOffsetY': instance.privacyOffsetY,
      'privacyOffsetY_B': instance.privacyOffsetY_B,
      'privacyTextSize': instance.privacyTextSize,
      'privacyMargin': instance.privacyMargin,
      'privacyBefore': instance.privacyBefore,
      'privacyEnd': instance.privacyEnd,
      'packageName': instance.packageName,
      'privacyOperatorIndex': instance.privacyOperatorIndex,
      'privacyConectTexts': instance.privacyConectTexts ?? [",", "", "和"],
      'backgroundPath': instance.backgroundPath,
      'isHiddenCustom': instance.isHiddenCustom,
      'customThirdView': instance.customThirdView?.toJson() ?? {},
      'bottomNavBarColor': instance.bottomNavBarColor,
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
      'presentDirection': instance.presentDirection,
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
/// dialogBottom 为false时 默认水平垂直居中
/// 如果需要修改弹窗的圆角背景可修改android/app/src/main/res/drawable/dialog_background_color.xml 文件
/// 'appPrivacyOne'、'appPrivacyTwo' 字段中的逗号拼接处请勿使用多余的空格，以免出现未知错误

/**
 *
 * 全屏默认配置
this.isDebug = true,
this.isDelay=false,
this.pageType=PageType.fullPort,
this.privacyOffsetX,
this.statusBarColor = "#026ED2",
this.bottomNavColor = "#FFFFFF",
this.isLightColor = false,
this.isStatusBarHidden = false,
this.statusBarUIFlag = UIFAG.SYSTEM_UI_FLAG_FULLSCREEN,
this.navColor = "#026ED2",
this.navText = "阿里云一键登录插件演示",
this.navTextColor = "#ffffff",
this.navReturnImgPath = "assets/return_btn.png",
this.navReturnImgWidth = 30,
this.navReturnImgHeight = 30,
this.navReturnHidden = false,
this.navReturnScaleType = ScaleType.center,
this.navHidden = false,
this.logoImgPath = "assets/logo.png",
this.logoHidden = false,
this.numberColor = "#ffffff",
this.numberSize = 28,
this.switchAccHidden = false,
this.switchAccTextColor = "#FDFDFD",
this.logBtnText = "一键登录",
this.logBtnTextSize = 16,
this.logBtnTextColor = "#FFF000",
this.protocolOneName = "《通达理》",
this.protocolOneURL = "https://tunderly.com",
this.protocolTwoName = "《思预云》",
this.protocolTwoURL = "https://jokui.com",
this.protocolThreeName = "《思预云APP》",
this.protocolThreeURL = "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
this.protocolCustomColor = "#F3F3F3",
this.protocolColor = "#dddddd",
this.protocolLayoutGravity = Gravity.CENTER_HORIZONTAL,
this.sloganTextColor = "#ffffff",
this.sloganText = "欢迎使用21克的爱情制作的一键登录插件",
this.logBtnBackgroundPath = "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
this.loadingImgPath = "authsdk_waiting_icon",
this.sloganOffsetY = -1,
this.logoOffsetY = -1,
this.logoOffsetY_B = -1,
this.logoScaleType = ScaleType.fitXy,
this.numFieldOffsetY = -1,
this.numFieldOffsetY_B = -1,
this.numberFieldOffsetX = 0,
this.numberLayoutGravity = Gravity.CENTER_HORIZONTAL,
this.switchOffsetY = -1,
this.switchOffsetY_B = -1,
this.logBtnOffsetY = -1,
this.logBtnOffsetY_B = -1,
this.logBtnWidth = -1,
this.logBtnHeight = 51,
this.logBtnOffsetX = 0,
this.logBtnMarginLeftAndRight = 28,
this.logBtnLayoutGravity = Gravity.CENTER_HORIZONTAL,
this.privacyOffsetY = -1,
this.privacyOffsetY_B = 28,
this.sloganOffsetY_B = -1,
this.checkBoxWidth = 18,
this.checkBoxHeight = 18,
this.checkboxHidden = false,
this.navTextSize = 18,
this.logoWidth = 90,
this.logoHeight = 90,
this.switchAccTextSize = 16,
this.switchAccText = "切换到其他方式",
this.sloganTextSize = 16,
this.sloganHidden = false,
this.uncheckedImgPath = "assets/btn_unchecked.png",
this.checkedImgPath = "assets/btn_checked.png",
this.privacyState = false,
this.protocolGravity = Gravity.CENTER_HORIZONTAL,
this.privacyTextSize = 12,
this.privacyMargin = 28,
this.privacyBefore = "",
this.privacyEnd = "",
this.vendorPrivacyPrefix = "",
this.vendorPrivacySuffix = "",
this.dialogWidth = -1,
this.dialogHeight = -1,
this.dialogBottom = false,
this.dialogOffsetX = 0,
this.dialogOffsetY = 0,
this.pageBackgroundPath = "assets/background_image.jpeg",
this.webViewStatusBarColor = "#026ED2",
this.webNavColor = "#FF00FF",
this.webNavTextColor = "#F0F0F8",
this.webNavTextSize = -1,
this.webNavReturnImgPath = "assets/background_image.jpeg",
this.webSupportedJavascript = true,
this.authPageActIn = "in_activity",
this.activityOut = "out_activity",
this.authPageActOut = "in_activity",
this.activityIn = "out_activity",
this.screenOrientation = -1,
this.logBtnToastHidden = false,
this.dialogAlpha = 1.0,
this.privacyOperatorIndex = 0,
this.privacyConectTexts,
this.protocolAction,
this.packageName,
this.loadingBackgroundPath,
this.isHiddenLoading,

this.isHiddenCustom,
this.customThirdView,
/**
 * "assets/background_gif.gif"
 * "assets/background_gif1.gif"
 * "assets/background_gif2.gif"
 * "assets/background_image.jpeg"
 * "assets/background_video.mp4"
 *
 * "https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-7/20187232061776607.gif"
 * "https://img.zcool.cn/community/01dda35912d7a3a801216a3e3675b3.gif",
    */
    this.backgroundPath="assets/background_image.jpeg"
 */
