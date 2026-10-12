import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// 引入全局 JS 对象 PhoneNumberServer（构造函数）
@JS('PhoneNumberServer')
@staticInterop
class PhoneNumberServer {
  // 构造函数（staticInterop 必须使用 factory）
  external factory PhoneNumberServer();
}

// 实例成员放在静态扩展中
extension PhoneNumberServerExtension on PhoneNumberServer {
  // 方法：获取网络连接状态（返回 Promise）
  external JSPromise<JSString?> getConnection();

  // 方法：设置日志开关
  external void setLoggerEnable(bool isEnable);

  // 方法：获取 SDK 版本（返回 Promise）
  external JSPromise<JSString?> getVersion();

  // 方法：鉴权（通过回调通知结果）
  external void checkAuthAvailable(JSObject params);

  // 方法：获取 Token（通过回调通知结果）
  external void getVerifyToken(JSObject params);
}

/// 阿里云号码认证 Web 插件（Dart 封装）
class AliAuthPluginWebApi {
  final PhoneNumberServer _server = PhoneNumberServer();

  /// 网络类型检查接口
  Future<String?> getConnection() async {
    final result = await _server.getConnection().toDart;
    return result?.toDart;
  }

  /// 设置 SDK 是否开启日志。开启后会在控制台打印更多内容便于排查问题。
  Future<void> setLoggerEnable(bool isEnable) async {
    _server.setLoggerEnable(isEnable);
  }

  /// 获取版本号
  Future<String?> getVersion() async {
    final result = await _server.getVersion().toDart;
    return result?.toDart;
  }

  /// 调用之前先去用户服务端获取 accessToken 和 jwtToken
  Future<void> checkAuthAvailable(
    String accessToken,
    String jwtToken,
    void Function(JSAny? status) success,
    void Function(JSAny? status) error,
  ) async {
    // 将 Dart 回调转换为 JSFunction
    final jsSuccess = success.toJS;
    final jsError = error.toJS;

    final params = _buildParams(
      accessToken: accessToken,
      jwtToken: jwtToken,
      success: jsSuccess,
      error: jsError,
    );
    _server.checkAuthAvailable(params);
  }

  /// 身份鉴权成功后才可调用获取 Token 接口
  Future<void> getVerifyToken(
    void Function(JSAny? status) success,
    void Function(JSAny? status) error,
  ) async {
    final jsSuccess = success.toJS;
    final jsError = error.toJS;

    final params = _buildParams(
      success: jsSuccess,
      error: jsError,
    );
    _server.getVerifyToken(params);
  }

  /// 构建参数对象（通过 JS 互操作创建）
  JSObject _buildParams({
    String? accessToken,
    String? jwtToken,
    JSFunction? success,
    JSFunction? error,
  }) {
    final obj = JSObject();
    if (accessToken != null) obj['accessToken'] = accessToken.toJS;
    if (jwtToken != null) obj['jwtToken'] = jwtToken.toJS;
    if (success != null) obj['success'] = success;
    if (error != null) obj['error'] = error;
    return obj;
  }
}