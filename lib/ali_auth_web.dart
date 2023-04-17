// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'ali_auth_web_api.dart';
import 'ali_auth_platform_interface.dart';

/// A web implementation of the AliAuthPlatform of the AliAuth plugin.
class AliAuthPluginWeb extends AliAuthPlatform {
  /// Constructs a AliAuthWeb
  AliAuthPluginWeb();
  AliAuthPluginWebPhone aliAuthPluginWebPhone = AliAuthPluginWebPhone();

  static void registerWith(Registrar registrar) {
    AliAuthPlatform.instance = AliAuthPluginWeb();
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
    return await aliAuthPluginWebPhone.getVersion();
  }

  /// 网络类型检查接口
  @override
  Future<String?> getConnection() async {
    return await aliAuthPluginWebPhone.getConnection();
  }

  /// 设置SDK是否开启日志。开启后会在控制台打印更多内容便于排查问题。
  @override
  Future<void> setLoggerEnable(bool isEnable) async {
    return await aliAuthPluginWebPhone.setLoggerEnable(isEnable);
  }

  /// 身份鉴权
  @override
  Future<void> checkAuthAvailable(
      String accessToken,
      String jwtToken,
      Function(dynamic) success,
      Function(dynamic) error
  ) async {
    aliAuthPluginWebPhone.checkAuthAvailable(
        accessToken,
        jwtToken,
        success,
        error
    );
  }

  /// 获取本机号码校验Token
  @override
  Future<void> getVerifyToken(
      Function(dynamic) success,
      Function(dynamic) error
      ) async {
    aliAuthPluginWebPhone.getVerifyToken(
        success,
        error
    );
  }
}
