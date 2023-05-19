import 'dart:async';
import 'ali_auth_model.dart';
import 'ali_auth_platform_interface.dart';
import 'ali_auth_web.dart';

export 'ali_auth_enum.dart';
export 'ali_auth_model.dart';

/// 阿里云一键登录类
/// 原来的全屏登录和dialog 统一有配置参数isDislog来控制
class AliAuth {
  /// 初始化监听
  static Stream<dynamic>? onChange({bool type = true}) {
    return AliAuthPlatform.instance.onChange(type: type);
  }

  /// 获取设备版本信息
  static Future<String?> get platformVersion async {
    return AliAuthPlatform.instance.getPlatformVersion();
  }

  /// 获取SDK版本号
  static Future<String?> get sdkVersion async {
    return AliAuthPlatform.instance.getSdkVersion();
  }

  /// 初始化SDK sk 必须
  /// isDialog 是否使用Dialog 弹窗登录 非必须 默认值false 非Dialog登录
  /// debug 是否开启调试模式 非必须 默认true 开启
  /// 使用一键登录传入 SERVICE_TYPE_LOGIN 2  使用号码校验传入 SERVICE_TYPE_AUTH  1 默认值 2
  static Future<dynamic> initSdk(AliAuthModel? config) async {
    return AliAuthPlatform.instance.initSdk(config);
  }

  /// 一键登录
  static Future<dynamic> login({int timeout = 5000}) async {
    return AliAuthPlatform.instance.login(timeout: timeout);
  }

  /// 强制关闭一键登录授权页面
  static Future<void> quitPage() async {
    return AliAuthPlatform.instance.quitPage();
  }

  /// 强制关闭一键登录授权页面
  static Future<String> getCurrentCarrierName() async {
    return AliAuthPlatform.instance.getCurrentCarrierName();
  }

  /// pageRoute
  static Future<void> openPage(String? pageRoute) async {
    return AliAuthPlatform.instance.openPage(pageRoute);
  }

  static Future<dynamic> get checkCellularDataEnable async {
    return AliAuthPlatform.instance.checkCellularDataEnable;
  }

  /// 苹果登录iOS专用
  static Future<dynamic> get appleLogin async {
    return AliAuthPlatform.instance.appleLogin;
  }

  /// 数据监听
  static loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) async {
    return AliAuthPlatform.instance.loginListen(
        type: type, onEvent: onEvent, onError: onError, isOnlyOne: isOnlyOne);
  }

  /// 暂停
  static pause() {
    return AliAuthPlatform.instance.pause();
  }

  /// 恢复
  static resume() {
    return AliAuthPlatform.instance.resume();
  }

  /// 销毁监听
  static dispose() {
    return AliAuthPlatform.instance.dispose();
  }

  /// WEB专用接口
  static Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      {required Function(dynamic) success,
      required Function(dynamic) error}) async {
    await AliAuthPluginApi()
        .checkAuthAvailable(accessToken, jwtToken, success, error);
  }

  /// WEB专用接口
  static Future<void> getVerifyToken(
      {required Function(dynamic) success,
      required Function(dynamic) error}) async {
    await AliAuthPluginApi().getVerifyToken(success, error);
  }
}
