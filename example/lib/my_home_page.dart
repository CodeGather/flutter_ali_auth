import 'dart:io';
import 'dart:ui';

import 'package:ali_auth/ali_auth.dart';
import 'package:ali_auth_example/my_router_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String status = "初始化中...";

  late CustomThirdView customThirdView;

  /// Android 密钥
  late String androidSk;

  /// iOS 密钥
  late String iosSk;

  /// 弹窗宽度
  late int screenWidth;

  /// 弹窗高度
  late int screenHeight;

  /// 弹窗宽度
  late int dialogWidth;

  /// 弹窗高度
  late int dialogHeight;

  /// 比例
  late int unit;

  /// 按钮高度
  late int logBtnHeight;

  @override
  void initState() {
    super.initState();

    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    /// 初始化第三方按钮数据
    setState(() {
      androidSk =
          "kReOFbE7mWUhefnT2BAGdKCGqgtnZbcPa/vGFc6z//ytIrOxZRndH0pdIeHM465OfdpHPMFxgPATR1EnKE7aonZ5hyEP1CE4Wz0QhWEWNTg7mmeq8hstbgFtjP8boZx/mPalQZmfD5heQ9E5Rahg4tWQfsCBENlQLgR/6vqtA8F3knXFa6awGegHj3C8bSXyCVj2OKxZFAvrZ1+1bd7TD2We3HyXsSJoDBLGuSqZIZ3VkExNC8jX4fL9uP5Ul9VVNSjahTn70u+9RYdB0BrtJpw+FPytOIsapzqdfrtqkFTk3v0+BcVJnA==";
      iosSk =
          "mjWr9sTsoXwmMx7qf0T2KQOQBpqkxeNW9I1ZNZ96ZCeBbeD9xYOUaC2mE9mcqog041VCot2sLcy9UArf+re517e5R9yowKCjf15VglZSP/HweRhOT8Cvci43zagyRqo40l85LTnZ5uJPaVauDLJB7hOTIkNPGm3fb621k6A6ZDh6aDGAKWyy0tPUPV/9RFrfeig9SURNe9Vl/Aok6SKg+SftM30uk2W8wdbV8gMVbU51Odnoapm2ZlAJYmCrdoXvROW5qc8pbQ8=";

      screenWidth =
          (PlatformDispatcher.instance.views.first.physicalSize.width /
                  PlatformDispatcher.instance.views.first.devicePixelRatio)
              .floor();
      screenHeight =
          (PlatformDispatcher.instance.views.first.physicalSize.height /
                  PlatformDispatcher.instance.views.first.devicePixelRatio)
              .floor();
      dialogWidth =
          (PlatformDispatcher.instance.views.first.physicalSize.width /
                  PlatformDispatcher.instance.views.first.devicePixelRatio *
                  0.8)
              .floor();
      dialogHeight =
          (PlatformDispatcher.instance.views.first.physicalSize.height /
                      PlatformDispatcher.instance.views.first.devicePixelRatio *
                      0.65)
                  .floor() -
              50;
      unit = dialogHeight ~/ 10;
      logBtnHeight = (unit * 1.1).floor();

      Map<String, dynamic> configMap = {
        "width": -1,
        "height": -1,
        "top": unit * 12 + 80,
        "space": 20,
        "size": 16,
        "color": "#026ED2",
        'itemWidth': 50,
        'itemHeight': 50,
        "viewItemName": ["支付宝", "淘宝", "微博"],
        "viewItemPath": [
          "assets/alipay.png",
          "assets/taobao.png",
          "assets/sina.png"
        ]
      };
      customThirdView = CustomThirdView.fromJson(configMap);
    });

    AliAuth.loginListen(onEvent: (onEvent) {
      if (kDebugMode) {
        print("----------------> $onEvent <----------------");
      }

      // EasyLoading.show(status: onEvent['msg'] ?? "", maskType: EasyLoadingMaskType.black);
      setState(() {
        status = onEvent.toString();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: // TODO: 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // TODO: 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // TODO: 应用程序不可见，后台
        /// 由于弹窗方式来回后台的切换导致弹窗背景透明度消失
        /// AliAuth.quitPage();
        break;
      case AppLifecycleState.detached: // TODO: Handle this case.
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    if (kDebugMode) {
      print('MyHomePage页面被销毁');
    }
    AliAuth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AliAuth插件演示'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            Text(status),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortConfig());
              },
              child: const Text("开始全屏登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortPrivacyConfig());
              },
              child: const Text("开始全屏登录二次认证"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortVideoConfig());
              },
              child: const Text("开始全屏Video登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortGifConfig());
              },
              child: const Text("开始全屏Gif登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortCustomConfig());
              },
              child: const Text("开始自定义界面登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getDialogConfig());
              },
              child: const Text("开始弹窗登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getDialogWebConfig());
              },
              child: const Text("开始弹窗自定义web协议页面登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getDialogButtomConfig());
              },
              child: const Text("开始底部弹窗登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortConfig(isDelay: true));
              },
              child: const Text("初始化全屏延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortVideoConfig(isDelay: true));
              },
              child: const Text("初始化全屏Video登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getFullPortGifConfig(isDelay: true));
              },
              child: const Text("初始化全屏Gif登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getDialogConfig(isDelay: true));
              },
              child: const Text("初始化弹窗延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.initSdk(getDialogButtomConfig(isDelay: true));
              },
              child: const Text("初始化底部弹窗延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.login();
              },
              child: const Text("开始延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final cellularStatus = await AliAuth.checkCellularDataEnable;
                setState(() {
                  status = "当前蜂窝网络开启状态：$cellularStatus";
                });
              },
              child: const Text("检测是否开启蜂窝网络"),
            ),
            ElevatedButton(
              onPressed: () {
                // 使用pushReplacementNamed 为了触发dispose
                // Navigator.of(context).pushReplacementNamed(
                //   "/routerPage"
                // );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const MyRouterPage();
                }));
              },
              child: const Text("跳转页面"),
            ),
            ElevatedButton(
              onPressed: () async {
                /// 通过isOnlyListen
                AliAuth.loginListen(
                  onEvent: (onEvent) {
                    if (kDebugMode) {
                      print("----------------> $onEvent <----------------");
                    }
                    setState(() {
                      status = onEvent.toString();
                    });
                  },
                  isOnlyOne: false,
                );
              },
              child: const Text("添加多个监听"),
            ),
            ElevatedButton(
              onPressed: () async {
                AliAuth.loginListen(
                  onEvent: (onEvent) {
                    if (kDebugMode) {
                      print("----------------> $onEvent <----------------");
                    }
                    setState(() {
                      status = onEvent.toString();
                    });
                  },
                );
              },
              child: const Text("只能添加一个监听"),
            ),

            /// 苹果专用，安卓调用报错
            Platform.isIOS
                ? ElevatedButton(
                    onPressed: () async {
                      await AliAuth.appleLogin;
                    },
                    child: const Text("开始Apple登录"),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () async {
                /// 传值实例
                /// await AliAuth.openPage("routerPage?{id:123}");
                await AliAuth.openPage("routerPage");
              },
              child: const Text("打开跳转页面"),
            )
          ],
        ),
      ),
    );
  }

  /// 全屏正常图片背景
  AliAuthModel getFullPortConfig({bool isDelay = false}) {
    customThirdView.top = unit * 10 + 80;
    return AliAuthModel(
      androidSk,
      iosSk,
      isDebug: true,
      autoQuitPage: true,
      isDelay: isDelay,
      pageType: PageType.fullPort,
      statusBarColor: "#026ED2",
      bottomNavColor: "#FFFFFF",
      lightColor: false,
      isStatusBarHidden: false,
      statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
      navColor: "#026ED2",
      navText: "一键登录插件演示",
      navTextColor: "#000000",
      navReturnImgPath: "assets/return_btn.png",
      navReturnImgWidth: 30,
      navReturnImgHeight: 30,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,
      navHidden: false,
      logoOffsetY: unit * 2,
      logoImgPath: "assets/logo.png",
      logoHidden: false,
      logBtnText: "一键登录",
      logBtnTextSize: 16,
      logBtnTextColor: "#FFF000",
      protocolOneName: "《通达理》",
      protocolOneURL: "https://tunderly.com",
      protocolTwoName: "《思预云》",
      protocolTwoURL: "https://jokui.com",
      protocolThreeName: "《思预云APP》",
      protocolThreeURL:
          "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
      protocolCustomColor: "#026ED2",
      protocolColor: "#bfbfbf",
      protocolLayoutGravity: Gravity.centerHorizntal,
      sloganTextColor: "#ffffff",
      sloganOffsetY: unit * 5,
      sloganText: "思预云欢迎您使用一键登录",
      logBtnBackgroundPath:
          "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
      loadingImgPath: "authsdk_waiting_icon",
      logoOffsetY_B: -1,
      numberColor: "#ffffff",
      numberSize: 28,
      logoScaleType: ScaleType.fitXy,
      numFieldOffsetY: unit * 7,
      numFieldOffsetY_B: -1,
      numberFieldOffsetX: 0,
      numberLayoutGravity: Gravity.centerHorizntal,
      logBtnOffsetY: unit * 8,
      logBtnOffsetY_B: -1,
      logBtnHeight: 51,
      logBtnOffsetX: 0,
      logBtnMarginLeftAndRight: 28,
      logBtnLayoutGravity: Gravity.centerHorizntal,
      privacyOffsetX: -1,
      privacyOffsetY: -1,
      privacyOffsetY_B: 28,
      checkBoxWidth: 18,
      checkBoxHeight: 18,
      checkboxHidden: false,
      privacyState: false,
      navTextSize: 18,
      logoWidth: 90,
      logoHeight: 90,
      switchAccTextSize: 16,
      switchAccText: "切换到其他方式",
      switchOffsetY: unit * 9 + 20,
      switchOffsetY_B: -1,
      switchAccHidden: false,
      switchAccTextColor: "#FDFDFD",
      sloganTextSize: 16,
      sloganHidden: false,
      uncheckedImgPath: "assets/btn_unchecked.png",
      checkedImgPath: "assets/btn_checked.png",
      protocolGravity: Gravity.centerHorizntal,
      privacyTextSize: 12,
      privacyMargin: 28,
      privacyBefore: "已阅读并同意",
      privacyEnd: "",
      vendorPrivacyPrefix: "《",
      vendorPrivacySuffix: "》",
      dialogWidth: -1,
      dialogHeight: -1,
      dialogBottom: false,
      dialogOffsetX: 0,
      dialogOffsetY: 0,
      webViewStatusBarColor: "",
      webNavColor: "#026ED2",
      webNavTextColor: "#ffffff",
      webNavTextSize: 20,
      webNavReturnImgPath: "assets/return_btn.png",
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      screenOrientation: -1,
      logBtnToastHidden: false,
      dialogAlpha: 1.0,
      privacyOperatorIndex: 0,
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
      pageBackgroundPath: "assets/background_image.jpeg",
      customThirdView: customThirdView,
    );
  }

  /// 全屏正常图片背景
  AliAuthModel getFullPortPrivacyConfig({bool isDelay = false}) {
    customThirdView.top = unit * 10 + 80;
    return AliAuthModel(androidSk, iosSk,
        isDebug: true,
        isDelay: isDelay,
        pageType: PageType.fullPort,
        statusBarColor: "#026ED2",
        bottomNavColor: "#FFFFFF",
        lightColor: false,
        isStatusBarHidden: false,
        statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
        navColor: "#026ED2",
        navText: "一键登录插件演示",
        navTextColor: "#000000",
        navReturnImgPath: "assets/return_btn.png",
        navReturnImgWidth: 30,
        navReturnImgHeight: 30,
        navReturnHidden: false,
        navReturnScaleType: ScaleType.center,
        navHidden: false,
        logoOffsetY: unit * 2,
        logoImgPath: "assets/logo.png",
        logoHidden: false,
        logBtnText: "一键登录",
        logBtnTextSize: 16,
        logBtnTextColor: "#FFF000",
        protocolOneName: "《通达理》",
        protocolOneURL: "https://tunderly.com",
        protocolTwoName: "《思预云》",
        protocolTwoURL: "https://jokui.com",
        protocolThreeName: "《思预云APP》",
        protocolThreeURL:
            "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
        protocolCustomColor: "#026ED2",
        protocolColor: "#bfbfbf",
        protocolLayoutGravity: Gravity.centerHorizntal,
        sloganTextColor: "#ffffff",
        sloganOffsetY: unit * 5,
        sloganText: "欢迎使用AliAuth一键登录插件",
        logBtnBackgroundPath:
            "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
        loadingImgPath: "authsdk_waiting_icon",
        logoOffsetY_B: -1,
        numberColor: "#ffffff",
        numberSize: 28,
        logoScaleType: ScaleType.fitXy,
        numFieldOffsetY: unit * 7,
        numFieldOffsetY_B: -1,
        numberFieldOffsetX: 0,
        numberLayoutGravity: Gravity.centerHorizntal,
        logBtnOffsetY: unit * 8,
        logBtnOffsetY_B: -1,
        logBtnHeight: 51,
        logBtnOffsetX: 0,
        logBtnMarginLeftAndRight: 28,
        logBtnLayoutGravity: Gravity.centerHorizntal,
        privacyOffsetX: -1,
        privacyOffsetY: -1,
        privacyOffsetY_B: 28,
        checkBoxWidth: 18,
        checkBoxHeight: 18,
        checkboxHidden: false,
        navTextSize: 18,
        logoWidth: 90,
        logoHeight: 90,
        switchAccTextSize: 16,
        switchAccText: "切换到其他方式",
        switchOffsetY: unit * 9 + 20,
        switchOffsetY_B: -1,
        switchAccHidden: false,
        switchAccTextColor: "#FDFDFD",
        sloganTextSize: 16,
        sloganHidden: false,
        uncheckedImgPath: "assets/btn_unchecked.png",
        checkedImgPath: "assets/btn_checked.png",
        privacyState: false,
        protocolGravity: Gravity.centerHorizntal,
        privacyTextSize: 12,
        privacyMargin: 28,
        privacyBefore: "已阅读并同意",
        privacyEnd: "",
        vendorPrivacyPrefix: "《",
        vendorPrivacySuffix: "》",
        dialogWidth: -1,
        dialogHeight: -1,
        dialogBottom: false,
        dialogOffsetX: 0,
        dialogOffsetY: 0,
        webViewStatusBarColor: "#026ED2",
        webNavColor: "#FF00FF",
        webNavTextColor: "#F0F0F8",
        webNavTextSize: -1,
        webNavReturnImgPath: "assets/return_btn.png",
        webSupportedJavascript: true,
        authPageActIn: "in_activity",
        activityOut: "out_activity",
        authPageActOut: "in_activity",
        activityIn: "out_activity",
        screenOrientation: -1,
        logBtnToastHidden: false,
        dialogAlpha: 1.0,
        privacyOperatorIndex: 0,
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
        pageBackgroundPath: "assets/background_image.jpeg",
        customThirdView: customThirdView,
        privacyAlertIsNeedShow: true);
  }

  /// 全屏视频背景
  AliAuthModel getFullPortVideoConfig({bool isDelay = false}) {
    /// 开启Gif、Video背景时建议隐藏nav
    /// navHidden(true)
    /// logoHidden(true)
    /// sloganHidden(true)
    /// webViewStatusBarColor(Color.TRANSPARENT)
    /// statusBarColor(Color.TRANSPARENT)
    /// statusBarUIFlag(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
    Map<String, dynamic> configMap = {
      'top': 20,
      'left': 20,
      'width': 40,
      'height': 40,
      'imgPath': "assets/return_btn_filll.png"
    };
    customThirdView.top = unit * 12 + 80;
    CustomView customReturnBtn = CustomView.fromJson(configMap);
    return AliAuthModel(androidSk, iosSk,
        isDebug: true,
        isDelay: isDelay,
        pageType: PageType.customMOV,
        statusBarColor: "#00026ED2",
        bottomNavColor: "#000000",
        lightColor: true,
        statusBarUIFlag: UIFAG.systemUiFalgLayoutFullscreen,
        navHidden: true,
        logoHidden: true,
        numberColor: "#ffffff",
        numberSize: 28,
        numFieldOffsetY: unit * 9,
        numberLayoutGravity: Gravity.centerHorizntal,
        logBtnText: "一键登录",
        logBtnTextSize: 16,
        logBtnTextColor: "#FFF000",
        protocolOneName: "《通达理》",
        protocolOneURL: "https://tunderly.com",
        protocolTwoName: "《思预云》",
        protocolTwoURL: "https://jokui.com",
        protocolThreeName: "《思预云APP》",
        protocolThreeURL:
            "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
        protocolCustomColor: "#026ED2",
        protocolColor: "#bfbfbf",
        protocolLayoutGravity: Gravity.centerHorizntal,
        logBtnBackgroundPath:
            "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
        loadingImgPath: "authsdk_waiting_icon",
        logBtnOffsetY: unit * 10,
        logBtnOffsetY_B: -1,
        logBtnWidth: 300,
        logBtnHeight: 51,
        logBtnOffsetX: 0,
        logBtnMarginLeftAndRight: 28,
        logBtnLayoutGravity: Gravity.centerHorizntal,
        privacyOffsetX: -1,
        privacyOffsetY: -1,
        privacyOffsetY_B: 28,
        checkBoxWidth: 18,
        checkBoxHeight: 18,
        checkboxHidden: false,
        navTextSize: 18,
        switchAccTextSize: 16,
        switchOffsetY: unit * 12 + 40,
        switchOffsetY_B: -1,
        switchAccHidden: false,
        switchAccTextColor: "#FDFDFD",
        switchAccText: "切换到其他方式",
        sloganHidden: true,
        uncheckedImgPath: "assets/btn_unchecked.png",
        checkedImgPath: "assets/btn_checked.png",
        privacyState: false,
        protocolGravity: Gravity.centerHorizntal,
        privacyTextSize: 12,
        privacyMargin: 28,
        privacyBefore: "已阅读并同意",
        privacyEnd: "",
        vendorPrivacyPrefix: "《",
        vendorPrivacySuffix: "》",
        dialogWidth: -1,
        dialogHeight: -1,
        dialogBottom: false,
        dialogOffsetX: 0,
        dialogOffsetY: 0,
        webViewStatusBarColor: "#026ED2",
        webNavColor: "#FF00FF",
        webNavTextColor: "#F0F0F8",
        webNavTextSize: -1,
        webNavReturnImgPath: "assets/return_btn.png",
        webSupportedJavascript: true,
        authPageActIn: "in_activity",
        activityOut: "out_activity",
        authPageActOut: "in_activity",
        activityIn: "out_activity",
        screenOrientation: -1,
        logBtnToastHidden: false,
        dialogAlpha: 1.0,
        privacyOperatorIndex: 0,
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
        pageBackgroundPath: "assets/background_video.mp4",
        customThirdView: customThirdView,
        customReturnBtn: customReturnBtn);
  }

  /// 自定义Gif
  AliAuthModel getFullPortGifConfig({bool isDelay = false}) {
    /// 开启Gif、Video背景时建议隐藏nav
    /// navHidden(true)
    /// logoHidden(true)
    /// sloganHidden(true)
    /// webViewStatusBarColor(Color.TRANSPARENT)
    /// statusBarColor(Color.TRANSPARENT)
    /// statusBarUIFlag(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
    Map<String, dynamic> configMap = {
      'top': 20,
      'left': 20,
      'width': 40,
      'height': 40,
      'imgPath': "assets/return_btn_filll.png"
    };
    customThirdView.top = unit * 12 + 80;
    CustomView customReturnBtn = CustomView.fromJson(configMap);
    return AliAuthModel(androidSk, iosSk,
        isDebug: true,
        isDelay: isDelay,
        pageType: PageType.customGif,
        statusBarColor: "#00026ED2",
        bottomNavColor: "#000000",
        lightColor: true,
        statusBarUIFlag: UIFAG.systemUiFalgLayoutFullscreen,
        navHidden: true,
        logoHidden: true,
        numberColor: "#ffffff",
        numberSize: 28,
        logBtnText: "一键登录",
        logBtnTextSize: 16,
        logBtnTextColor: "#FFF000",
        protocolOneName: "《通达理》",
        protocolOneURL: "https://tunderly.com",
        protocolTwoName: "《思预云》",
        protocolTwoURL: "https://jokui.com",
        protocolThreeName: "《思预云APP》",
        protocolThreeURL:
            "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
        protocolCustomColor: "#026ED2",
        protocolColor: "#bfbfbf",
        protocolLayoutGravity: Gravity.centerHorizntal,
        logBtnBackgroundPath:
            "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
        loadingImgPath: "authsdk_waiting_icon",
        numFieldOffsetY: unit * 9,
        numberLayoutGravity: Gravity.centerHorizntal,
        logBtnOffsetY: unit * 10,
        logBtnOffsetY_B: -1,
        logBtnHeight: 51,
        logBtnOffsetX: 0,
        logBtnMarginLeftAndRight: 28,
        logBtnLayoutGravity: Gravity.centerHorizntal,
        privacyOffsetX: -1,
        privacyOffsetY: -1,
        privacyOffsetY_B: 28,
        checkBoxWidth: 18,
        checkBoxHeight: 18,
        checkboxHidden: false,
        navTextSize: 18,
        switchAccHidden: false,
        switchOffsetY: unit * 12 + 40,
        switchAccTextColor: "#FDFDFD",
        switchAccTextSize: 16,
        switchAccText: "切换到其他方式",
        sloganHidden: true,
        uncheckedImgPath: "assets/btn_unchecked.png",
        checkedImgPath: "assets/btn_checked.png",
        privacyState: false,
        protocolGravity: Gravity.centerHorizntal,
        privacyTextSize: 12,
        privacyMargin: 28,
        privacyBefore: "已阅读并同意",
        privacyEnd: "",
        vendorPrivacyPrefix: "《",
        vendorPrivacySuffix: "》",
        dialogWidth: -1,
        dialogHeight: -1,
        dialogBottom: false,
        dialogOffsetX: 0,
        dialogOffsetY: 0,
        webViewStatusBarColor: "#026ED2",
        webNavColor: "#FF00FF",
        webNavTextColor: "#F0F0F8",
        webNavTextSize: -1,
        webNavReturnImgPath: "assets/return_btn.png",
        webSupportedJavascript: true,
        authPageActIn: "in_activity",
        activityOut: "out_activity",
        authPageActOut: "in_activity",
        activityIn: "out_activity",
        screenOrientation: -1,
        logBtnToastHidden: false,
        dialogAlpha: 1.0,
        privacyOperatorIndex: 0,
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
        pageBackgroundPath: "assets/background_gif.gif",
        customThirdView: customThirdView,
        customReturnBtn: customReturnBtn);
  }

  /// 自定义
  AliAuthModel getFullPortCustomConfig({bool isDelay = false}) {
    return AliAuthModel(androidSk, iosSk,
        isDebug: true,
        isDelay: isDelay,
        pageType: PageType.customXml,
        statusBarColor: "#026ED2",
        bottomNavColor: "#FFFFFF",
        lightColor: true,
        navHidden: false,
        navReturnImgPath: "assets/return_btn.png",
        logoHidden: true,
        sloganHidden: true,
        numberColor: "#ffffff",
        numberSize: 28,
        logBtnBackgroundPath:
            "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
        logBtnText: "一键登录",
        logBtnTextSize: 16,
        logBtnTextColor: "#FFF000",
        logBtnOffsetY: -1,
        logBtnOffsetY_B: -1,
        logBtnWidth: -1,
        logBtnHeight: 51,
        logBtnOffsetX: 0,
        logBtnMarginLeftAndRight: 28,
        logBtnLayoutGravity: Gravity.centerHorizntal,
        protocolOneName: "《通达理》",
        protocolOneURL: "https://tunderly.com",
        protocolTwoName: "《思预云》",
        protocolTwoURL: "https://jokui.com",
        protocolThreeName: "《思预云APP》",
        protocolThreeURL:
            "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
        protocolCustomColor: "#026ED2",
        protocolColor: "#bfbfbf",
        protocolLayoutGravity: Gravity.centerHorizntal,
        numFieldOffsetY: -1,
        numberFieldOffsetX: 0,
        numberLayoutGravity: Gravity.centerHorizntal,
        privacyOffsetX: -1,
        privacyOffsetY: -1,
        privacyOffsetY_B: 28,
        checkBoxWidth: 18,
        checkBoxHeight: 18,
        checkboxHidden: false,
        switchAccHidden: true,
        uncheckedImgPath: "assets/btn_unchecked.png",
        checkedImgPath: "assets/btn_checked.png",
        privacyState: false,
        protocolGravity: Gravity.centerHorizntal,
        privacyTextSize: 12,
        privacyMargin: 28,
        vendorPrivacyPrefix: "",
        vendorPrivacySuffix: "",
        dialogBottom: false,
        webViewStatusBarColor: "#026ED2",
        webNavColor: "#FF00FF",
        webNavTextColor: "#F0F0F8",
        webNavReturnImgPath: "assets/return_btn.png",
        webSupportedJavascript: true,
        authPageActIn: "in_activity",
        activityOut: "out_activity",
        authPageActOut: "in_activity",
        activityIn: "out_activity",
        logBtnToastHidden: false,
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
        pageBackgroundPath: "assets/background_image.jpeg",
        customThirdView: customThirdView);
  }

  /// 弹窗
  AliAuthModel getDialogConfig({bool isDelay = false}) {
    // top相对于switchOffsetY的位置即按钮下方多少间距
    Map<String, dynamic> configMap = {
      "width": -1,
      "height": -1,
      "top": unit * 3 + 80,
      "space": 20,
      "color": "#00ff00",
      "size": 12,
      'itemWidth': 40,
      'itemHeight': 40,
      "viewItemName": ["支付宝", "淘宝", "微博"],
      "viewItemPath": [
        "assets/alipay.png",
        "assets/taobao.png",
        "assets/sina.png"
      ]
    };

    return AliAuthModel(
      androidSk,
      iosSk,
      isDebug: true,
      isDelay: isDelay,
      pageType: PageType.dialogPort,
      privacyOffsetX: -1,
      // statusBarColor: "#026ED2",
      // bottomNavColor: "#FFFFFF",
      lightColor: false,
      isStatusBarHidden: false,
      statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
      navColor: "#026ED2",
      navText: "一键登录插件演示",
      navTextSize: 10,
      navTextColor: "#ff0000",
      navReturnImgPath: "assets/return_btn.png",
      navReturnImgWidth: 20,
      navReturnImgHeight: 20,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,
      navHidden: false,
      switchAccHidden: false,
      switchOffsetY: unit * 3 + 50,
      switchAccTextColor: "#FDFDFD",
      switchAccTextSize: 16,
      switchAccText: "切换到其他方式",
      logBtnText: "一键登录",
      logBtnTextSize: 16,
      logBtnTextColor: "#FFF000",
      uncheckedImgPath: "assets/btn_unchecked.png",
      checkedImgPath: "assets/btn_checked.png",
      protocolCustomColor: "#026ED2",
      protocolColor: "#bfbfbf",
      protocolOneName: "《通达理》",
      protocolOneURL: "https://tunderly.com",
      protocolTwoName: "《思预云》",
      protocolTwoURL: "https://jokui.com",
      protocolThreeName: "《思预云APP》",
      protocolThreeURL:
          "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
      protocolLayoutGravity: Gravity.centerHorizntal,
      sloganTextColor: "#f0ff0d",
      sloganText: "欢迎使用AliAuth一键登录插件",
      logBtnBackgroundPath:
          "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
      loadingImgPath: "authsdk_waiting_icon",
      sloganOffsetY: unit + 20,
      sloganTextSize: 11,
      sloganHidden: false,
      logoWidth: 42,
      logoHeight: 42,
      logoImgPath: "assets/logo.png",
      logoHidden: false,
      logoOffsetY: 0,
      logoScaleType: ScaleType.fitXy,
      numberColor: "#000fff",
      numberSize: 17,
      numFieldOffsetY: unit * 2,
      numberFieldOffsetX: 0,
      numberLayoutGravity: Gravity.centerHorizntal,
      logBtnOffsetY: unit * 3,
      logBtnWidth: dialogWidth - 30,
      logBtnHeight: logBtnHeight,
      logBtnOffsetX: 0,
      logBtnMarginLeftAndRight: 15,
      logBtnLayoutGravity: Gravity.centerHorizntal,
      logBtnToastHidden: false,
      checkBoxWidth: 15,
      checkBoxHeight: 15,
      checkboxHidden: false,
      privacyState: false,
      protocolGravity: Gravity.centerHorizntal,
      privacyTextSize: 12,
      privacyMargin: 28,
      privacyBefore: "已阅读并同意",
      privacyEnd: "",
      vendorPrivacyPrefix: "《",
      vendorPrivacySuffix: "》",
      dialogWidth: dialogWidth,
      dialogHeight: dialogHeight,
      dialogBottom: false,
      dialogOffsetX: (screenWidth - dialogWidth) ~/ 2,
      dialogOffsetY: (screenHeight - dialogHeight) ~/ 2,
      dialogCornerRadiusArray: [10, 10, 10, 10],
      pageBackgroundPath: "assets/background_image.jpeg",
      pageBackgroundRadius: 10,
      webViewStatusBarColor: "#026ED2",
      webNavColor: "#FFFFFF",
      webNavTextColor: "#F0F0F8",
      webNavTextSize: -1,
      webNavReturnImgPath: "assets/return_btn.png",
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      screenOrientation: -1,
      dialogAlpha: 0.4,
      bottomNavBarColor: "#FFFFFF",
      privacyOperatorIndex: 0,
      alertBarIsHidden: false,
      alertCloseItemIsHidden: false,
      alertCloseImagePath: "assets/return_btn.png",
      alertCloseImageX: 10,
      alertCloseImageY: 0,
      alertCloseImageW: 45,
      alertCloseImageH: 45,
      alertBlurViewColor: "#000000",
      alertBlurViewAlpha: 0.4,
      customThirdView: CustomThirdView.fromJson(configMap),
    );
  }

  /// 自定义协议弹窗
  AliAuthModel getDialogWebConfig({bool isDelay = false}) {
    return AliAuthModel(
      androidSk,
      iosSk,
      isDebug: true,
      isDelay: isDelay,
      pageType: PageType.fullPort,
      statusBarColor: "#026ED2",
      bottomNavColor: "#FFFFFF",
      lightColor: false,
      isStatusBarHidden: false,
      statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
      navColor: "#026ED2",
      navText: "一键登录插件演示",
      navTextColor: "#000000",
      navReturnImgPath: "assets/return_btn.png",
      navReturnImgWidth: 30,
      navReturnImgHeight: 30,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,
      navHidden: false,
      logoOffsetY: unit * 2,
      logoImgPath: "assets/logo.png",
      logoHidden: false,
      logBtnText: "一键登录",
      logBtnTextSize: 16,
      logBtnTextColor: "#FFF000",
      protocolOneName: "《通达理》",
      protocolOneURL: "https://tunderly.com",
      protocolTwoName: "《思预云》",
      protocolTwoURL: "https://jokui.com",
      protocolThreeName: "《思预云APP》",
      protocolThreeURL:
          "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
      protocolCustomColor: "#026ED2",
      protocolColor: "#bfbfbf",
      protocolLayoutGravity: Gravity.centerHorizntal,
      sloganTextColor: "#ffffff",
      sloganOffsetY: unit * 5,
      sloganText: "欢迎使用AliAuth一键登录插件",
      logBtnBackgroundPath:
          "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
      loadingImgPath: "authsdk_waiting_icon",
      logoOffsetY_B: -1,
      numberColor: "#ffffff",
      numberSize: 28,
      logoScaleType: ScaleType.fitXy,
      numFieldOffsetY: unit * 7,
      numFieldOffsetY_B: -1,
      numberFieldOffsetX: 0,
      numberLayoutGravity: Gravity.centerHorizntal,
      logBtnOffsetY: unit * 8,
      logBtnOffsetY_B: -1,
      logBtnHeight: 51,
      logBtnOffsetX: 0,
      logBtnMarginLeftAndRight: 28,
      logBtnLayoutGravity: Gravity.centerHorizntal,
      privacyOffsetX: -1,
      privacyOffsetY: -1,
      privacyOffsetY_B: 28,
      checkBoxWidth: 18,
      checkBoxHeight: 18,
      checkboxHidden: false,
      navTextSize: 18,
      logoWidth: 90,
      logoHeight: 90,
      switchAccTextSize: 16,
      switchAccText: "切换到其他方式",
      switchOffsetY: unit * 9 + 20,
      switchOffsetY_B: -1,
      switchAccHidden: false,
      switchAccTextColor: "#FDFDFD",
      sloganTextSize: 16,
      sloganHidden: false,
      uncheckedImgPath: "assets/btn_unchecked.png",
      checkedImgPath: "assets/btn_checked.png",
      privacyState: false,
      protocolGravity: Gravity.centerHorizntal,
      privacyTextSize: 12,
      privacyMargin: 28,
      privacyBefore: "已阅读并同意",
      privacyEnd: "",
      vendorPrivacyPrefix: "《",
      vendorPrivacySuffix: "》",
      dialogWidth: -1,
      dialogHeight: -1,
      dialogBottom: false,
      dialogOffsetX: 0,
      dialogOffsetY: 0,
      dialogCornerRadiusArray: [10, 10, 10, 10],
      webViewStatusBarColor: "#026ED2",
      webNavColor: "#FF00FF",
      webNavTextColor: "#F0F0F8",
      webNavTextSize: -1,
      webNavReturnImgPath: "assets/return_btn.png",
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      screenOrientation: -1,
      logBtnToastHidden: false,
      dialogAlpha: 1.0,
      alertBlurViewColor: "#000000",
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
      pageBackgroundPath: "assets/background_image.jpeg",
      customThirdView: customThirdView,
      privacyOperatorIndex: 2,
      protocolAction: "com.sean.rao.ali_auth_example.protocolWeb",
      packageName: "com.sean.rao.ali_auth_example",
    );
  }

  /// 底部弹窗登录
  AliAuthModel getDialogButtomConfig({bool isDelay = false}) {
    Map<String, dynamic> configMap = {
      "width": -1,
      "height": -1,
      "top": unit * 4 + 90,
      "space": 20,
      "size": 15,
      "color": "#616161",
      'itemWidth': 40,
      'itemHeight': 40,
      "viewItemName": ["支付宝", "淘宝", "微博"],
      "viewItemPath": [
        "assets/alipay.png",
        "assets/taobao.png",
        "assets/sina.png"
      ]
    };
    return AliAuthModel(
      androidSk,
      iosSk,
      isDebug: true,
      isDelay: isDelay,
      pageType: PageType.dialogBottom,
      statusBarColor: "#026ED2",
      bottomNavColor: "#FFFFFF",
      navColor: "#026ED2",
      navText: "一键登录插件演示",
      navTextSize: 10,
      navTextColor: "#ff00ff",
      navReturnImgPath: "assets/return_btn.png",
      navReturnImgWidth: 20,
      navReturnImgHeight: 20,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,
      navHidden: false,
      numberColor: "#ffffff",
      numberSize: 17,
      switchAccHidden: false,
      switchOffsetY: unit * 4 + 60,
      switchAccTextColor: "#FDFDFD",
      switchAccTextSize: 16,
      switchAccText: "切换到其他方式",
      logBtnText: "一键登录",
      logBtnTextSize: 16,
      logBtnTextColor: "#FFF000",
      uncheckedImgPath: "assets/btn_unchecked.png",
      checkedImgPath: "assets/btn_checked.png",
      protocolOneName: "《通达理》",
      protocolOneURL: "https://tunderly.com",
      protocolTwoName: "《思预云》",
      protocolTwoURL: "https://jokui.com",
      protocolThreeName: "《思预云APP》",
      protocolThreeURL:
          "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
      protocolCustomColor: "#026ED2",
      protocolColor: "#bfbfbf",
      protocolLayoutGravity: Gravity.left,
      sloganTextColor: "#ffffff",
      sloganText: "欢迎使用AliAuth一键登录插件",
      logBtnBackgroundPath:
          "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
      loadingImgPath: "authsdk_waiting_icon",
      sloganOffsetY: unit + 70,
      sloganTextSize: 11,
      sloganHidden: false,
      logoWidth: 42,
      logoHeight: 42,
      logoImgPath: "assets/logo.png",
      logoHidden: false,
      logoOffsetY: unit,
      logoOffsetY_B: -1,
      logoScaleType: ScaleType.fitXy,
      numFieldOffsetY: unit * 3,
      numFieldOffsetY_B: -1,
      numberFieldOffsetX: 0,
      numberLayoutGravity: Gravity.centerHorizntal,
      logBtnOffsetY: unit * 4,
      logBtnHeight: logBtnHeight,
      logBtnOffsetX: 0,
      logBtnMarginLeftAndRight: 15,
      logBtnLayoutGravity: Gravity.centerHorizntal,
      logBtnToastHidden: false,
      checkBoxWidth: 15,
      checkBoxHeight: 15,
      checkboxHidden: false,
      privacyState: false,
      protocolGravity: Gravity.centerHorizntal,
      privacyTextSize: 12,
      privacyMargin: 28,
      dialogHeight: dialogHeight,
      dialogBottom: true,
      pageBackgroundRadius: 10,
      webViewStatusBarColor: "#026ED2",
      webNavColor: "#FFFFFF",
      webNavTextColor: "#F0F0F8",
      webNavReturnImgPath: "assets/return_btn.png",
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      alertCloseItemIsHidden: false,
      alertCloseImagePath: "assets/return_btn.png",
      alertCloseImageX: 10,
      alertCloseImageY: 0,
      alertCloseImageW: 45,
      alertCloseImageH: 45,
      dialogCornerRadiusArray: [10, 0, 0, 10],
      dialogAlpha: 0.4,
      alertBlurViewColor: "#000000",
      bottomNavBarColor: "#000000",
      pageBackgroundPath: "assets/background_image.jpeg",
      customThirdView: CustomThirdView.fromJson(configMap),
    );
  }

  /// 延时登录公共初始化方法,请不要使用该方法的配置，其他方法均已调试
  /// 延迟登录初始化只能初始化一次，多次无效
  @Deprecated("即将删除......")
  Future<void> initSdkVoid({PageType pageType = PageType.fullPort}) async {
    AliAuthModel config = AliAuthModel(androidSk, iosSk,
        isDebug: true,
        isDelay: true,
        pageType: pageType,
        statusBarColor: "#026ED2",
        bottomNavColor: "#FFFFFF",
        lightColor: false,
        isStatusBarHidden: false,
        statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
        navColor: "#026ED2",
        navText: "AliAuth插件演示",
        navTextColor: "#000000",
        navReturnImgPath: "assets/return_btn.png",
        navReturnImgWidth: 30,
        navReturnImgHeight: 30,
        navReturnHidden: false,
        navReturnScaleType: ScaleType.center,
        navHidden: false,
        logoImgPath: "assets/logo.png",
        logoHidden: false,
        numberColor: "#ffffff",
        numberSize: 28,
        switchAccHidden: false,
        switchAccTextColor: "#FDFDFD",
        logBtnText: "一键登录",
        logBtnTextSize: 16,
        logBtnTextColor: "#FFF000",
        protocolOneName: "《通达理》",
        protocolOneURL: "https://tunderly.com",
        protocolTwoName: "《思预云》",
        protocolTwoURL: "https://jokui.com",
        protocolThreeName: "《思预云APP》",
        protocolThreeURL:
            "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
        protocolCustomColor: "#F3F3F3",
        protocolColor: "#dddddd",
        protocolLayoutGravity: Gravity.centerHorizntal,
        sloganTextColor: "#ffffff",
        sloganText: "欢迎使用AliAuth一键登录插件",
        logBtnBackgroundPath:
            "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
        loadingImgPath: "authsdk_waiting_icon",
        sloganOffsetY: -1,
        logoOffsetY: -1,
        logoOffsetY_B: -1,
        logoScaleType: ScaleType.fitXy,
        numFieldOffsetY: -1,
        numFieldOffsetY_B: -1,
        numberFieldOffsetX: 0,
        numberLayoutGravity: Gravity.centerHorizntal,
        switchOffsetY: -1,
        switchOffsetY_B: -1,
        logBtnOffsetY: -1,
        logBtnOffsetY_B: -1,
        logBtnWidth: -1,
        logBtnHeight: 51,
        logBtnOffsetX: 0,
        logBtnMarginLeftAndRight: 28,
        logBtnLayoutGravity: Gravity.centerHorizntal,
        privacyOffsetX: -1,
        privacyOffsetY: -1,
        privacyOffsetY_B: 28,
        sloganOffsetY_B: -1,
        checkBoxWidth: 18,
        checkBoxHeight: 18,
        checkboxHidden: false,
        navTextSize: 18,
        logoWidth: 90,
        logoHeight: 90,
        switchAccTextSize: 16,
        switchAccText: "切换到其他方式",
        sloganTextSize: 16,
        sloganHidden: false,
        uncheckedImgPath: "assets/btn_unchecked.png",
        checkedImgPath: "assets/btn_checked.png",
        privacyState: false,
        protocolGravity: Gravity.centerHorizntal,
        privacyTextSize: 12,
        privacyMargin: 28,
        privacyBefore: "已阅读并同意",
        privacyEnd: "",
        vendorPrivacyPrefix: "《",
        vendorPrivacySuffix: "》",
        dialogWidth: -1,
        dialogHeight: -1,
        dialogBottom: false,
        dialogOffsetX: 0,
        dialogOffsetY: 0,
        webViewStatusBarColor: "#026ED2",
        webNavColor: "#FF00FF",
        webNavTextColor: "#F0F0F8",
        webNavTextSize: -1,
        webNavReturnImgPath: "assets/return_btn.png",
        webSupportedJavascript: true,
        authPageActIn: "in_activity",
        activityOut: "out_activity",
        authPageActOut: "in_activity",
        activityIn: "out_activity",
        screenOrientation: -1,
        logBtnToastHidden: false,
        dialogAlpha: 1.0,
        privacyOperatorIndex: 0,
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
        pageBackgroundPath: "assets/background_image.jpeg",
        customThirdView: customThirdView);
    await AliAuth.initSdk(config);
  }

  /// This allows a value of type T or T? to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become non-nullable can still be used
  /// with `!` and `?` on the stable branch.
  /// TODO(ianh): Remove this once we roll stable in late 2021.
  T? _ambiguate<T>(T? value) => value;
}
