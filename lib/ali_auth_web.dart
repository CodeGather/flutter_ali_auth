import 'dart:js_interop';
import 'dart:ui_web' as ui;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'ali_auth_web_api.dart';
import 'ali_auth_platform_interface.dart';
import 'ali_auth_model.dart';
export 'ali_auth_method_channel.dart';

/// A web implementation of the AliAuthPlatform of the AliAuth plugin.
class AliAuthPluginWeb extends AliAuthPlatform {
  AliAuthPluginWeb();

  AliAuthPluginWebApi aliAuthPluginWebApi = AliAuthPluginWebApi();

  static void registerWith(Registrar registrar) {
    AliAuthPlatform.instance = AliAuthPluginWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = ui.BrowserDetection.instance.debugUserAgentOverride;
    return version;
  }

  /// 获取SDK版本号
  @override
  Future<String?> getSdkVersion() async {
    return await aliAuthPluginWebApi.getVersion();
  }

  /// 网络类型检查接口
  @override
  Future<String?> getConnection() async {
    return await aliAuthPluginWebApi.getConnection();
  }

  /// 设置SDK是否开启日志
  @override
  Future<void> setLoggerEnable(bool isEnable) async {
    return await aliAuthPluginWebApi.setLoggerEnable(isEnable);
  }

  /// 身份鉴权
  @override
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.checkAuthAvailable(
        accessToken,
        jwtToken,
        (JSAny? status) => success(status),
        (JSAny? status) => error(status));
  }

  /// 获取本机号码校验Token
  @override
  Future<void> getVerifyToken(
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.getVerifyToken(
        (JSAny? status) => success(status), (JSAny? status) => error(status));
  }

  // ========== Web 不支持的接口（一键登录仅限移动端） ==========

  @override
  Future<dynamic> initSdk(AliAuthModel? config) async {
    throw UnsupportedError('initSdk 仅支持 Android/iOS 平台，Web 端请使用 checkAuthAvailable + getVerifyToken 进行号码校验');
  }

  @override
  Future<dynamic> login({int timeout = 5000}) async {
    throw UnsupportedError('login 仅支持 Android/iOS 平台，Web 端不支持一键登录');
  }

  @override
  Future<void> quitPage() async {
    throw UnsupportedError('quitPage 仅支持 Android/iOS 平台');
  }

  @override
  Future<void> hideLoading() async {
    throw UnsupportedError('hideLoading 仅支持 Android/iOS 平台');
  }

  @override
  Future<String> getCurrentCarrierName() async {
    throw UnsupportedError('getCurrentCarrierName 仅支持 Android/iOS 平台，Web 端无运营商信息');
  }

  @override
  Future<void> openPage(String? pageRoute) async {
    throw UnsupportedError('openPage 仅支持 Android/iOS 平台');
  }

  @override
  Future<dynamic> get checkCellularDataEnable async {
    throw UnsupportedError('checkCellularDataEnable 仅支持 Android/iOS 平台');
  }

  @override
  Future<dynamic> get appleLogin async {
    throw UnsupportedError('appleLogin 仅支持 iOS 平台');
  }

  @override
  Stream<dynamic>? onChange({bool type = true}) {
    throw UnsupportedError('onChange 仅支持 Android/iOS 平台');
  }

  @override
  void loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) {
    throw UnsupportedError('loginListen 仅支持 Android/iOS 平台');
  }

  @override
  void pause() {
    throw UnsupportedError('pause 仅支持 Android/iOS 平台');
  }

  @override
  void resume() {
    throw UnsupportedError('resume 仅支持 Android/iOS 平台');
  }

  @override
  void dispose() {
    // Web 端无需清理，空实现
  }

  @override
  Future<void> checkEnvAvailable() async {
    throw UnsupportedError('checkEnvAvailable 仅支持 Android/iOS 平台');
  }

  @override
  Future<void> queryCheckBoxIsChecked() async {
    throw UnsupportedError('queryCheckBoxIsChecked 仅支持 Android/iOS 平台');
  }

  @override
  Future<void> setCheckboxIsChecked() async {
    throw UnsupportedError('setCheckboxIsChecked 仅支持 Android/iOS 平台');
  }
}