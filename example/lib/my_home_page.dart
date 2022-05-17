import 'dart:ui';

import 'package:ali_auth/ali_auth.dart';
import 'package:ali_auth/ali_auth_enum.dart';
import 'package:ali_auth/ali_auth_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  String status = "初始化中...";

  @override
  void initState() {
    super.initState();

    AliAuth.loginListen(onEvent: (onEvent) {
      print(
          "-------------------------------> ${onEvent} <---------------------------------");

      setState(() {
        status = onEvent.toString();
      });
    });
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
                Map<String, dynamic> configMap = {
                  "width": -1,
                  "height": -1,
                  "top": 400,
                  "space": 20,
                  "size": 20,
                  'itemWidth': 50,
                  'itemHeight': 50,
                  "viewItemName": ["支付宝", "淘宝", "微博"],
                  "viewItemPath": [
                    "assets/alipay.png",
                    "assets/taobao.png",
                    "assets/sina.png"
                  ]
                };
                CustomThirdView customThirdView =
                    CustomThirdView.fromJson(configMap);
                AliAuthModel config = AliAuthModel(
                    "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                    "",
                    isDebug: true,
                    isDelay: false,
                    pageType: PageType.fullPort,
                    privacyOffsetX: -1,
                    statusBarColor: "#026ED2",
                    bottomNavColor: "#FFFFFF",
                    isLightColor: false,
                    isStatusBarHidden: false,
                    statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
                    navColor: "#026ED2",
                    navText: "一键登录插件演示",
                    navTextColor: "#ffffff",
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
                    privacyBefore: "",
                    privacyEnd: "",
                    vendorPrivacyPrefix: "",
                    vendorPrivacySuffix: "",
                    dialogWidth: -1,
                    dialogHeight: -1,
                    dialogBottom: false,
                    dialogOffsetX: 0,
                    dialogOffsetY: 0,
                    pageBackgroundPath: "assets/background_image.jpeg",
                    webViewStatusBarColor: "#026ED2",
                    webNavColor: "#FF00FF",
                    webNavTextColor: "#F0F0F8",
                    webNavTextSize: -1,
                    webNavReturnImgPath: "assets/background_image.jpeg",
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
                    backgroundPath: "assets/background_image.jpeg",
                    customThirdView: customThirdView);
                await AliAuth.initSdk(config);
              },
              child: const Text("开始全屏登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> configMap = {
                  "width": -1,
                  "height": -1,
                  "top": 400,
                  "space": 20,
                  "size": 20,
                  'itemWidth': 50,
                  'itemHeight': 50,
                  "viewItemName": ["支付宝", "淘宝", "微博"],
                  "viewItemPath": [
                    "assets/alipay.png",
                    "assets/taobao.png",
                    "assets/sina.png"
                  ]
                };
                CustomThirdView customThirdView =
                    CustomThirdView.fromJson(configMap);
                AliAuthModel config = AliAuthModel(
                    "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                    "",
                    isDebug: true,
                    isDelay: false,
                    pageType: PageType.customXml,
                    privacyOffsetX: -1,
                    statusBarColor: "#026ED2",
                    bottomNavColor: "#FFFFFF",
                    isLightColor: true,
                    navHidden: true,
                    logoHidden: true,
                    sloganHidden: true,
                    numberColor: "#ffffff",
                    numberSize: 28,
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
                    protocolCustomColor: "#F3F3F3",
                    protocolColor: "#dddddd",
                    protocolLayoutGravity: Gravity.centerHorizntal,
                    numFieldOffsetY: -1,
                    numberFieldOffsetX: 0,
                    numberLayoutGravity: Gravity.centerHorizntal,
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
                    pageBackgroundPath: "assets/background_image.jpeg",
                    webViewStatusBarColor: "#026ED2",
                    webNavColor: "#FF00FF",
                    webNavTextColor: "#F0F0F8",
                    webNavReturnImgPath: "assets/background_image.jpeg",
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
                    backgroundPath: "assets/background_image.jpeg",
                    customThirdView: customThirdView);
                await AliAuth.initSdk(config);
              },
              child: const Text("开始自定义界面登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final dialogWidth =
                    (window.physicalSize.width / window.devicePixelRatio * 0.8)
                        .floor();
                final dialogHeight = (window.physicalSize.height /
                            window.devicePixelRatio *
                            0.65)
                        .floor() -
                    50;
                int unit = dialogHeight ~/ 10;
                int logBtnHeight = (unit * 1.1).floor();

                AliAuthModel config = AliAuthModel(
                  "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                  "",
                  isDebug: true,
                  isDelay: false,
                  pageType: PageType.dialogPort,
                  privacyOffsetX: -1,
                  statusBarColor: "#026ED2",
                  bottomNavColor: "#FFFFFF",
                  isLightColor: false,
                  isStatusBarHidden: false,
                  statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
                  navColor: "#026ED2",
                  navText: "一键登录插件演示",
                  navTextSize: 10,
                  navTextColor: "#ffffff",
                  navReturnImgPath: "assets/icon_close.png",
                  navReturnImgWidth: 20,
                  navReturnImgHeight: 20,
                  navReturnHidden: false,
                  navReturnScaleType: ScaleType.center,
                  navHidden: false,
                  numberColor: "#ffffff",
                  numberSize: 17,
                  switchAccHidden: true,
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
                  protocolCustomColor: "#F3F3F3",
                  protocolColor: "#dddddd",
                  protocolLayoutGravity: Gravity.centerHorizntal,
                  sloganTextColor: "#ffffff",
                  sloganText: "欢迎使用AliAuth一键登录插件",
                  logBtnBackgroundPath:
                      "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
                  loadingImgPath: "authsdk_waiting_icon",
                  sloganOffsetY: unit * 4,
                  sloganOffsetY_B: -1,
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
                  switchOffsetY: -1,
                  switchOffsetY_B: -1,
                  logBtnOffsetY: unit * 5,
                  logBtnOffsetY_B: -1,
                  logBtnWidth: dialogWidth - 30,
                  logBtnHeight: logBtnHeight,
                  logBtnOffsetX: 0,
                  logBtnMarginLeftAndRight: 15,
                  logBtnLayoutGravity: Gravity.centerHorizntal,
                  logBtnToastHidden: false,
                  privacyOffsetY: -1,
                  privacyOffsetY_B: 28,
                  checkBoxWidth: 15,
                  checkBoxHeight: 15,
                  checkboxHidden: false,
                  privacyState: false,
                  protocolGravity: Gravity.centerHorizntal,
                  privacyTextSize: 12,
                  privacyMargin: 28,
                  privacyBefore: "",
                  privacyEnd: "",
                  vendorPrivacyPrefix: "",
                  vendorPrivacySuffix: "",
                  dialogWidth: dialogWidth,
                  dialogHeight: dialogHeight,
                  dialogBottom: false,
                  dialogOffsetX: 0,
                  dialogOffsetY: 0,
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
                  privacyOperatorIndex: 2,
                );
                await AliAuth.initSdk(config);
              },
              child: const Text("开始弹窗登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final dialogWidth =
                    (window.physicalSize.width / window.devicePixelRatio * 0.8)
                        .floor();
                final dialogHeight = (window.physicalSize.height /
                            window.devicePixelRatio *
                            0.65)
                        .floor() -
                    50;
                int unit = dialogHeight ~/ 10;
                int logBtnHeight = (unit * 1.1).floor();

                AliAuthModel config = AliAuthModel(
                  "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                  "",
                  isDebug: true,
                  isDelay: false,
                  pageType: PageType.dialogPort,
                  privacyOffsetX: -1,
                  statusBarColor: "#026ED2",
                  bottomNavColor: "#FFFFFF",
                  isLightColor: false,
                  isStatusBarHidden: false,
                  statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
                  navColor: "#026ED2",
                  navText: "一键登录插件演示",
                  navTextSize: 10,
                  navTextColor: "#ffffff",
                  navReturnImgPath: "assets/icon_close.png",
                  navReturnImgWidth: 20,
                  navReturnImgHeight: 20,
                  navReturnHidden: false,
                  navReturnScaleType: ScaleType.center,
                  navHidden: false,
                  numberColor: "#ffffff",
                  numberSize: 17,
                  switchAccHidden: true,
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
                  protocolCustomColor: "#F3F3F3",
                  protocolColor: "#dddddd",
                  protocolLayoutGravity: Gravity.centerHorizntal,
                  sloganTextColor: "#ffffff",
                  sloganText: "欢迎使用AliAuth一键登录插件",
                  logBtnBackgroundPath:
                      "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
                  loadingImgPath: "authsdk_waiting_icon",
                  sloganOffsetY: unit * 4,
                  sloganOffsetY_B: -1,
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
                  switchOffsetY: -1,
                  switchOffsetY_B: -1,
                  logBtnOffsetY: unit * 5,
                  logBtnOffsetY_B: -1,
                  logBtnWidth: dialogWidth - 30,
                  logBtnHeight: logBtnHeight,
                  logBtnOffsetX: 0,
                  logBtnMarginLeftAndRight: 15,
                  logBtnLayoutGravity: Gravity.centerHorizntal,
                  logBtnToastHidden: false,
                  privacyOffsetY: -1,
                  privacyOffsetY_B: 28,
                  checkBoxWidth: 15,
                  checkBoxHeight: 15,
                  checkboxHidden: false,
                  privacyState: false,
                  protocolGravity: Gravity.centerHorizntal,
                  privacyTextSize: 12,
                  privacyMargin: 28,
                  privacyBefore: "",
                  privacyEnd: "",
                  vendorPrivacyPrefix: "",
                  vendorPrivacySuffix: "",
                  dialogWidth: dialogWidth,
                  dialogHeight: dialogHeight,
                  dialogBottom: false,
                  dialogOffsetX: 0,
                  dialogOffsetY: 0,
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
                  privacyOperatorIndex: 2,
                  protocolAction: "com.sean.rao.ali_auth_example.protocolWeb",
                  packageName: "com.sean.rao.ali_auth_example",
                );
                await AliAuth.initSdk(config);
              },
              child: const Text("开始弹窗自定义web协议页面登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final dialogHeight = (window.physicalSize.height /
                            window.devicePixelRatio *
                            0.65)
                        .floor() -
                    50;
                int unit = dialogHeight ~/ 10;
                int logBtnHeight = (unit * 1.1).floor();

                AliAuthModel config = AliAuthModel(
                  "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                  "",
                  isDebug: true,
                  isDelay: false,
                  pageType: PageType.dialogBottom,
                  statusBarColor: "#026ED2",
                  bottomNavColor: "#FFFFFF",
                  navColor: "#026ED2",
                  navText: "一键登录插件演示",
                  navTextSize: 10,
                  navTextColor: "#ffffff",
                  navReturnImgPath: "assets/icon_close.png",
                  navReturnImgWidth: 20,
                  navReturnImgHeight: 20,
                  navReturnHidden: false,
                  navReturnScaleType: ScaleType.center,
                  navHidden: false,
                  numberColor: "#ffffff",
                  numberSize: 17,
                  switchAccHidden: true,
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
                  protocolCustomColor: "#F3F3F3",
                  protocolColor: "#dddddd",
                  protocolLayoutGravity: Gravity.centerHorizntal,
                  sloganTextColor: "#ffffff",
                  sloganText: "欢迎使用AliAuth一键登录插件",
                  logBtnBackgroundPath:
                      "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
                  loadingImgPath: "authsdk_waiting_icon",
                  sloganOffsetY: unit * 4,
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
                  logBtnOffsetY: unit * 5,
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
                  pageBackgroundPath: "assets/background_image.jpeg",
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
                  dialogAlpha: 0.4,
                  bottomNavBarColor: "#000000",
                );
                await AliAuth.initSdk(config);
              },
              child: const Text("开始底部弹窗登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> configMap = {
                  "width": -1,
                  "height": -1,
                  "top": 400,
                  "space": 20,
                  "size": 20,
                  'itemWidth': 50,
                  'itemHeight': 50,
                  "viewItemName": ["支付宝", "淘宝", "微博"],
                  "viewItemPath": [
                    "assets/alipay.png",
                    "assets/taobao.png",
                    "assets/sina.png"
                  ]
                };
                CustomThirdView customThirdView =
                    CustomThirdView.fromJson(configMap);
                AliAuthModel config = AliAuthModel(
                    "HGaIEvjq1t0waKqBPRy8UFDXO7jF7IeNdWBhvjWhSeIIqT4RK0e+lBFHdGWo9Q0LiqipWgfmj7VMZAtoPvTwPw4GuYzFMHTUK8VbKb6p1Oc59SbnwWOkJSonv7m3iTD9ntJz5WuffuEeXojLBDPSJXqkKyyxVml/hVpPmA1dMgKptxHjZlTNbaQsCJ2sB//8oRX5yE1SRN/jZqVsj3tjRuY/XSsbLSAxrxLq+n/w9pfeBcslpB9yeV8qbs0hpfsB2ogcfd3GFBNNpFsp7PL+Sb3pzyxfZmpm5Jdt7Gnhx+8aluiY8xRIr3Uh1/pN67dakhKc/VuBEaU=",
                    "",
                    isDebug: true,
                    isDelay: true,
                    pageType: PageType.fullPort,
                    privacyOffsetX: -1,
                    statusBarColor: "#026ED2",
                    bottomNavColor: "#FFFFFF",
                    isLightColor: false,
                    isStatusBarHidden: false,
                    statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
                    navColor: "#026ED2",
                    navText: "AliAuth插件演示",
                    navTextColor: "#ffffff",
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
                    privacyBefore: "",
                    privacyEnd: "",
                    vendorPrivacyPrefix: "",
                    vendorPrivacySuffix: "",
                    dialogWidth: -1,
                    dialogHeight: -1,
                    dialogBottom: false,
                    dialogOffsetX: 0,
                    dialogOffsetY: 0,
                    pageBackgroundPath: "assets/background_image.jpeg",
                    webViewStatusBarColor: "#026ED2",
                    webNavColor: "#FF00FF",
                    webNavTextColor: "#F0F0F8",
                    webNavTextSize: -1,
                    webNavReturnImgPath: "assets/background_image.jpeg",
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
                    backgroundPath: "assets/background_image.jpeg",
                    customThirdView: customThirdView);
                await AliAuth.initSdk(config);
              },
              child: const Text("开始初始化延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AliAuth.login();
                print("同开始初始化延迟登录，初始化时决定页面类型 获取登录结果${result}");
              },
              child: const Text("开始全屏延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AliAuth.login();
                print("同开始初始化延迟登录，初始化时决定页面类型 获取登录结果${result}");
              },
              child: const Text("开始弹窗延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AliAuth.login();
                print("同开始初始化延迟登录，初始化时决定页面类型 获取登录结果${result}");
              },
              child: const Text("开始底部弹窗延迟登录"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AliAuth.openPage("routerPage");
              },
              child: const Text("打开跳转页面"),
            )
          ],
        ),
      ),
    );
  }
}
