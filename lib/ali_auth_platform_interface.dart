import 'package:ali_auth/ali_auth_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'ali_auth_method_channel.dart'
    if (dart.library.html) "ali_auth_web.dart";

abstract class AliAuthPlatform extends PlatformInterface {
  /// Constructs a AliAuthPlatform.
  AliAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliAuthPlatform _instance = MethodChannelAliAuth();

  /// The default instance of [AliAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliAuth].
  static AliAuthPlatform get instance => _instance;

  Future? get appleLogin => null;

  Future? get checkCellularDataEnable => null;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliAuthPlatform] when
  /// they register themselves.
  static set instance(AliAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getSdkVersion() {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  Stream? onChange({bool type = true}) {
    throw UnimplementedError('onChange() has not been implemented.');
  }

  resume() {
    throw UnimplementedError('resume() has not been implemented.');
  }

  dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<void> openPage(String? pageRoute) {
    throw UnimplementedError('openPage() has not been implemented.');
  }

  Future<void> quitPage() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future<void> checkEnvAvailable() {
    throw UnimplementedError('checkEnvAvailable() has not been implemented.');
  }

  Future<void> queryCheckBoxIsChecked() {
    throw UnimplementedError('queryCheckBoxIsChecked() has not been implemented.');
  }

  Future<void> setCheckboxIsChecked() {
    throw UnimplementedError('setCheckboxIsChecked() has not been implemented.');
  }

  Future<void> hideLoading() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future<String> getCurrentCarrierName() {
    throw UnimplementedError('quitPage() has not been implemented.');
  }

  Future login({int timeout = 5000}) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future initSdk(AliAuthModel? config) {
    throw UnimplementedError('login() has not been implemented.');
  }

  loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) {
    throw UnimplementedError('loginListen() has not been implemented.');
  }

  Future<String?> getConnection() {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  Future<void> setLoggerEnable(bool isEnable) {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  /// 调用之前先去用户服务端获取accessToken和jwtToken
  Future<void> checkAuthAvailable(String accessToken, String jwtToken,
      Function(dynamic) success, Function(dynamic) error) async {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }

  /// 身份鉴权成功后才可调用获取Token接口。
  Future<void> getVerifyToken(
      Function(dynamic) success, Function(dynamic) error) async {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }
}
