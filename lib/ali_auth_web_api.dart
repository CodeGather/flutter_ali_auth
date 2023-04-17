import 'dart:async';
import 'package:js/js.dart';

@JS("PhoneNumberServer")
class PhoneNumberServer {
  /// 链接
  external getConnection();

  /// 设置SDK是否开启日志
  external setLoggerEnable(bool isEnable);

  /// 获取版本信息
  external getVersion();

  /// 鉴权
  external checkAuthAvailable(Params params);

  /// 获取token
  external getVerifyToken(Params params);
}

@JS()
@anonymous
class Params {
  /// 传递的参数
  external String get accessToken;

  /// 传递的参数
  external String get jwtToken;

  /// 传递方法 需要使用allowInterop 包裹
  external void Function(dynamic ststus) get success;

  /// 传递方法 需要使用allowInterop 包裹
  external void Function(dynamic ststus) get error;
  external factory Params(
      {String accessToken,
      String jwtToken,
      void Function(dynamic ststus) success,
      void Function(dynamic ststus) error});
}

class AliAuthPluginWebApi {
  /// 网络类型检查接口
  Future<String?> getConnection() async {
    return await PhoneNumberServer().getConnection();
  }

  /// 设置SDK是否开启日志。开启后会在控制台打印更多内容便于排查问题。
  Future<void> setLoggerEnable(bool isEnable) async {
    PhoneNumberServer().setLoggerEnable(isEnable);
  }

  /// 获取版本号
  Future<String?> getVersion() async {
    return await PhoneNumberServer().getVersion();
  }

  /// 调用之前先去用户服务端获取accessToken和jwtToken
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic ststus) success, Function(dynamic ststus) error) async {
    PhoneNumberServer().checkAuthAvailable(Params(
      accessToken: accessToken,
      jwtToken: jwtToken,
      success: allowInterop(success),
      error: allowInterop(error),
    ));
  }

  /// 身份鉴权成功后才可调用获取Token接口
  Future<void> getVerifyToken(
      Function(dynamic ststus) success, Function(dynamic ststus) error) async {
    PhoneNumberServer().getVerifyToken(Params(
      success: allowInterop(success),
      error: allowInterop(error),
    ));
  }
}
