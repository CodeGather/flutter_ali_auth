import 'dart:async';
import 'package:flutter/services.dart';
import 'ali_auth_model.dart';

export 'ali_auth_enum.dart';
export 'ali_auth_model.dart';

/// 阿里云一键登录类
/// 原来的全屏登录和dialog 统一有配置参数isDislog来控制
class AliAuth {
  /// 声明回调通道
  static const MethodChannel _channel = MethodChannel("ali_auth");

  /// 声明监听回调通道
  static const EventChannel _eventChannel = EventChannel("ali_auth/event");

  /// 监听器
  static Stream<dynamic>? _onListener;

  /// 初始化监听
  static Stream<dynamic>? onChange({bool type = true}) {
    _onListener ??= _eventChannel.receiveBroadcastStream(type);
    return _onListener;
  }

  /// 获取设备版本信息
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 获取SDK版本号
  static Future<String?> get sdkVersion async {
    final String? version = await _channel.invokeMethod('getSdkVersion');
    return version;
  }

  /// 初始化SDK sk 必须
  /// isDialog 是否使用Dialog 弹窗登录 非必须 默认值false 非Dialog登录
  /// debug 是否开启调试模式 非必须 默认true 开启
  /// 使用一键登录传入 SERVICE_TYPE_LOGIN 2  使用号码校验传入 SERVICE_TYPE_AUTH  1 默认值 2
  static Future<dynamic> initSdk(AliAuthModel? config) async {
    config ??= const AliAuthModel("", "");
    return await _channel.invokeMethod("initSdk", config.toJson());
  }

  /// 一键登录
  static Future<dynamic> login({int timeout = 5000}) async {
    return await _channel.invokeMethod('login', {"timeout": timeout});
  }

  /// 强制关闭一键登录授权页面
  static Future<void> quitPage() async {
    return await _channel.invokeMethod('quitPage');
  }

  /// pageRoute
  static Future<void> openPage(String? pageRoute) async {
    return await _channel
        .invokeMethod('openPage', {'pageRoute': pageRoute ?? 'main_page'});
  }

  /// 苹果登录iOS专用
  static Future<dynamic> get appleLogin async {
    return await _channel.invokeMethod('appleLogin');
  }

  /// 数据监听
  static loginListen(
      {bool type = true, required Function onEvent, Function? onError}) async {
    onChange(type: type)!.listen(onEvent as void Function(dynamic)?,
        onError: onError, onDone: null, cancelOnError: null);
  }
}
