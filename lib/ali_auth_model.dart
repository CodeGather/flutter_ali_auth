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

  /// 自定义返回按钮参数
  final CustomView? customReturnBtn;

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

  // final bool? isCheckboxCustomViewClick;

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

  /// 设置checkbox未勾选时，点击登录按钮toast是否隐藏 (android 独有)
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
  final List<int>? dialogCornerRadiusArray;
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

  /// /// ------- 十二、二次弹窗设置 --------- ///
  /// 设置二次隐私协议弹窗是否需要显示。false（默认值）
  final bool privacyAlertIsNeedShow;

  /// 设置二次隐私协议弹窗点击按钮是否需要执行登录 true（默认值）
  final bool privacyAlertIsNeedAutoLogin;

  /// 设置二次隐私协议弹窗背景蒙层是否显示。true（默认值）
  final bool privacyAlertMaskIsNeedShow;

  /// 设置二次隐私协议弹窗蒙层透明度。默认值0.3
  final double privacyAlertMaskAlpha;

  /// 设置二次隐私协议弹窗透明度。默认值1.0。
  final double privacyAlertAlpha;

  /// 设置二次隐私协议弹窗背景色（同意并继续按钮区域）。
  final String? privacyAlertBackgroundColor;

  /// 设置二次隐私协议弹窗显示自定义动画。
  final String? privacyAlertEntryAnimation;

  /// 设置二次隐私协议弹窗隐藏自定义动画。
  final String? privacyAlertExitAnimation;

  /// 设置二次隐私协议弹窗的四个圆角值。说明 顺序为左上、右上、右下、左下，需要填充4个值，不足4个值则无效，如果值小于等于0则为直角。
  final List<int>? privacyAlertCornerRadiusArray;

  /// 设置屏幕居中、居上、居下、居左、居右，默认居中显示。
  final Gravity? privacyAlertAlignment;

  /// 设置弹窗宽度。
  final int? privacyAlertWidth;

  /// 设置弹窗高度。
  final int? privacyAlertHeight;

  /// 设置弹窗水平偏移量。（单位：dp）
  final int? privacyAlertOffsetX;

  /// 设置弹窗竖直偏移量。（单位：dp）
  final int? privacyAlertOffsetY;

  /// 设置二次隐私协议弹窗标题背景颜色。
  final String? privacyAlertTitleBackgroundColor;

  /// 设置二次隐私协议弹窗标题支持居中、居左，默认居中显示。
  final Gravity? privacyAlertTitleAlignment;

  /// 设置标题文字水平偏移量。（单位：dp）
  final int? privacyAlertTitleOffsetX;

  /// 设置标题文字竖直偏移量。（单位：dp）
  final int? privacyAlertTitleOffsetY;

  /// 设置标题文字大小，默认值18 sp。
  final int privacyAlertTitleTextSize;

  /// 设置标题文字颜色。
  final String? privacyAlertTitleColor;

  /// 设置协议内容背景颜色。
  final String? privacyAlertContentBackgroundColor;

  /// 设置服务协议文字大小，默认值16 sp。
  final int? privacyAlertContentTextSize;

  /// 设置二次隐私协议弹窗协议文案支持居中、居左，默认居左显示。
  final Gravity? privacyAlertContentAlignment;

  /// 设置服务协议文字颜色。
  final String? privacyAlertContentColor;

  /// 设置服务协议非协议文字颜色。
  final String? privacyAlertContentBaseColor;

  /// 设置服务协议左右两侧间距。
  final int? privacyAlertContentHorizontalMargin;

  /// 设置服务协议上下间距。
  final int? privacyAlertContentVerticalMargin;

  /// 设置按钮背景图片路径。
  final String? privacyAlertBtnBackgroundImgPath;

  /// 设置按钮文字颜色。
  final String? privacyAlertBtnTextColor;

  /// 设置按钮文字大小，默认值18 sp。
  final int? privacyAlertBtnTextSize;

  /// 设置按钮宽度。（单位：dp）
  final int? privacyAlertBtnWidth;

  /// 设置按钮高度。（单位：dp）
  final int? privacyAlertBtnHeigth;

  /// 设置右上角的关闭按钮。true（默认值）：显示关闭按钮。
  final bool? privacyAlertCloseBtnShow;

  /// 关闭按钮图片路径。
  final String? privacyAlertCloseImagPath;

  /// 关闭按钮缩放类型。
  final ScaleType? privacyAlertCloseScaleType;

  /// 关闭按钮宽度。（单位：dp）
  final int? privacyAlertCloseImgWidth;

  /// 关闭按钮高度。（单位：dp）
  final int? privacyAlertCloseImgHeight;

  /// 设置二次隐私协议弹窗点击背景蒙层是否关闭弹窗。true（默认值）：表示关闭
  final bool tapPrivacyAlertMaskCloseAlert;

  /// 成功获取token后是否自动关闭授权页面
  final bool? autoQuitPage;

  /// /// ------- 十三、toast设置 --------- ///
  /// 为勾选用户协议时的提示文字
  final bool ?isHideToast;
  /// 为勾选用户协议时的提示文字
  final String ?toastText;
  /// toast的背景色
  final String ?toastBackground;
  /// 文字颜色
  final String ?toastColor;
  /// toast的padding
  final int ?toastPadding;
  /// 只有设置mode为top时才起作用，距离顶部的距离
  final int ?toastMarginTop;
  /// 只有设置mode为bottom时才起作用，距离低部的距离
  final int ?toastMarginBottom;
  /// toast的显示位置可用值 top、center、bottom
  final String ?toastPositionMode;
  /// 关闭的时长 默认3s
  final int ?toastDelay;

  const AliAuthModel(
    this.androidSk,
    this.iosSk, {
    this.isDebug = true,
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
    this.customReturnBtn,
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
    this.presentDirection,
    this.privacyAlertIsNeedShow = false,
    this.privacyAlertIsNeedAutoLogin = true,
    this.privacyAlertMaskIsNeedShow = true,
    this.privacyAlertMaskAlpha = 0.3,
    this.privacyAlertAlpha = 0.2,
    this.privacyAlertBackgroundColor,
    this.privacyAlertEntryAnimation,
    this.privacyAlertExitAnimation,
    this.privacyAlertCornerRadiusArray,
    this.privacyAlertAlignment,
    this.privacyAlertWidth,
    this.privacyAlertHeight,
    this.privacyAlertOffsetX,
    this.privacyAlertOffsetY,
    this.privacyAlertTitleBackgroundColor,
    this.privacyAlertTitleAlignment,
    this.privacyAlertTitleOffsetX,
    this.privacyAlertTitleOffsetY,
    this.privacyAlertTitleTextSize = 18,
    this.privacyAlertTitleColor,
    this.privacyAlertContentBackgroundColor,
    this.privacyAlertContentTextSize = 16,
    this.privacyAlertContentAlignment,
    this.privacyAlertContentColor,
    this.privacyAlertContentBaseColor,
    this.privacyAlertContentHorizontalMargin,
    this.privacyAlertContentVerticalMargin,
    this.privacyAlertBtnBackgroundImgPath,
    this.privacyAlertBtnTextColor,
    this.privacyAlertBtnTextSize = 18,
    this.privacyAlertBtnWidth,
    this.privacyAlertBtnHeigth,
    this.privacyAlertCloseBtnShow,
    this.privacyAlertCloseImagPath,
    this.privacyAlertCloseScaleType,
    this.privacyAlertCloseImgWidth,
    this.privacyAlertCloseImgHeight,
    this.tapPrivacyAlertMaskCloseAlert = true,
    this.autoQuitPage=true,
    this.isHideToast=false,
    this.toastText='请先阅读用户协议',
    this.toastBackground='#FF000000',
    this.toastColor='#FFFFFFFF',
    this.toastPadding=9,
    this.toastMarginTop=0,
    this.toastMarginBottom=0,
    this.toastPositionMode='bottom',
    this.toastDelay=3,
  })  : assert(androidSk != null || iosSk != null),
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
      'customReturnBtn': instance.customReturnBtn?.toJson() ?? {},
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
      'privacyAlertIsNeedShow': instance.privacyAlertIsNeedShow,
      'privacyAlertIsNeedAutoLogin': instance.privacyAlertIsNeedAutoLogin,
      'privacyAlertMaskIsNeedShow': instance.privacyAlertMaskIsNeedShow,
      'privacyAlertMaskAlpha': instance.privacyAlertMaskAlpha,
      'privacyAlertAlpha': instance.privacyAlertAlpha,
      'privacyAlertBackgroundColor': instance.privacyAlertBackgroundColor,
      'privacyAlertEntryAnimation': instance.privacyAlertEntryAnimation,
      'privacyAlertExitAnimation': instance.privacyAlertExitAnimation,
      'privacyAlertCornerRadiusArray': instance.privacyAlertCornerRadiusArray,
      'privacyAlertAlignment':
          EnumUtils.formatGravityValue(instance.privacyAlertAlignment),
      'privacyAlertWidth': instance.privacyAlertWidth,
      'privacyAlertHeight': instance.privacyAlertHeight,
      'privacyAlertOffsetX': instance.privacyAlertOffsetX,
      'privacyAlertOffsetY': instance.privacyAlertOffsetY,
      'privacyAlertTitleBackgroundColor':
          instance.privacyAlertTitleBackgroundColor,
      'privacyAlertTitleAlignment':
          EnumUtils.formatGravityValue(instance.privacyAlertTitleAlignment),
      'privacyAlertTitleOffsetX': instance.privacyAlertTitleOffsetX,
      'privacyAlertTitleOffsetY': instance.privacyAlertTitleOffsetY,
      'privacyAlertTitleTextSize': instance.privacyAlertTitleTextSize,
      'privacyAlertTitleColor': instance.privacyAlertTitleColor,
      'privacyAlertContentBackgroundColor':
          instance.privacyAlertContentBackgroundColor,
      'privacyAlertContentTextSize': instance.privacyAlertContentTextSize,
      'privacyAlertContentAlignment':
          EnumUtils.formatGravityValue(instance.privacyAlertContentAlignment),
      'privacyAlertContentColor': instance.privacyAlertContentColor,
      'privacyAlertContentBaseColor': instance.privacyAlertContentBaseColor,
      'privacyAlertContentHorizontalMargin':
          instance.privacyAlertContentHorizontalMargin,
      'privacyAlertContentVerticalMargin':
          instance.privacyAlertContentVerticalMargin,
      'privacyAlertBtnBackgroundImgPath':
          instance.privacyAlertBtnBackgroundImgPath,
      'privacyAlertBtnTextColor': instance.privacyAlertBtnTextColor,
      'privacyAlertBtnTextSize': instance.privacyAlertBtnTextSize,
      'privacyAlertBtnWidth': instance.privacyAlertBtnWidth,
      'privacyAlertBtnHeigth': instance.privacyAlertBtnHeigth,
      'privacyAlertCloseBtnShow': instance.privacyAlertCloseBtnShow,
      'privacyAlertCloseImagPath': instance.privacyAlertCloseImagPath,
      'privacyAlertCloseScaleType':
          instance.privacyAlertCloseScaleType?.index ?? 0,
      'privacyAlertCloseImgWidth': instance.privacyAlertCloseImgWidth,
      'privacyAlertCloseImgHeight': instance.privacyAlertCloseImgHeight,
      'tapPrivacyAlertMaskCloseAlert': instance.tapPrivacyAlertMaskCloseAlert,
      'isHiddenLoading': instance.isHiddenLoading,
      'autoQuitPage': instance.autoQuitPage ?? true,
      'isHideToast': instance.isHideToast,
      'toastText': instance.toastText,
      'toastBackground': instance.toastBackground,
      'toastColor': instance.toastColor,
      'toastPadding': instance.toastPadding,
      'toastMarginTop': instance.toastMarginTop,
      'toastMarginBottom': instance.toastMarginBottom,
      'toastPositionMode': instance.toastPositionMode,
      'toastDelay': instance.toastDelay,
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
