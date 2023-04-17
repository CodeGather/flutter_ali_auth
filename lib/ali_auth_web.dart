import 'dart:html' as html show window;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'ali_auth_web_api.dart';
import 'ali_auth_platform_interface.dart';

/// A web implementation of the AliAuthPlatform of the AliAuth plugin.
class AliAuthPluginApi extends AliAuthPlatform {
  /// Constructs a AliAuthWeb
  AliAuthPluginApi();
  AliAuthPluginWebApi aliAuthPluginWebApi = AliAuthPluginWebApi();

  static void registerWith(Registrar registrar) {
    AliAuthPlatform.instance = AliAuthPluginApi();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
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

  /// 设置SDK是否开启日志。开启后会在控制台打印更多内容便于排查问题。
  @override
  Future<void> setLoggerEnable(bool isEnable) async {
    return await aliAuthPluginWebApi.setLoggerEnable(isEnable);
  }

  /// 身份鉴权
  @override
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.checkAuthAvailable(
        accessToken, jwtToken, success, error);
  }

  /// 获取本机号码校验Token
  @override
  Future<void> getVerifyToken(
      Function(dynamic) success, Function(dynamic) error) async {
    aliAuthPluginWebApi.getVerifyToken(success, error);
  }
}
