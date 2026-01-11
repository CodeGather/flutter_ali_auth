import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'ali_auth_model.dart';
import 'ali_auth_platform_interface.dart';

/// 阿里云一键登录类
/// 原来的全屏登录和dialog 统一有配置参数isDislog来控制
class MethodChannelAliAuth extends AliAuthPlatform {
  /// 声明回调通道
  @visibleForTesting
  final methodChannel = const MethodChannel('ali_auth');

  /// 声明监听回调通道
  @visibleForTesting
  final EventChannel eventChannel = const EventChannel("ali_auth/event");

  /// 监听器
  static Stream<dynamic>? onListener;

  /// 为了控制Stream 暂停。恢复。取消监听 新建
  static StreamSubscription? streamSubscription;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getSdkVersion() async {
    final version = await methodChannel.invokeMethod('getSdkVersion');
    return version;
  }

  /// 初始化监听
  @override
  Stream<dynamic>? onChange({bool type = true}) {
    onListener ??= eventChannel.receiveBroadcastStream(type);
    return onListener;
  }

  /// 初始化SDK sk 必须
  /// isDialog 是否使用Dialog 弹窗登录 非必须 默认值false 非Dialog登录
  /// debug 是否开启调试模式 非必须 默认true 开启
  /// 使用一键登录传入 SERVICE_TYPE_LOGIN 2  使用号码校验传入 SERVICE_TYPE_AUTH  1 默认值 2
  @override
  Future<dynamic> initSdk(AliAuthModel? config) async {
    config ??= AliAuthModel("", "");
    return await methodChannel.invokeMethod("initSdk", config.toJson());
  }

  /// 一键登录
  @override
  Future<dynamic> login({int timeout = 5000}) async {
    return await methodChannel.invokeMethod('login', {"timeout": timeout});
  }

  /// 强制关闭一键登录授权页面
  @override
  Future<void> quitPage() async {
    return await methodChannel.invokeMethod('quitPage');
  }

  /// SDK环境检查函数，检查终端是否支持号码认证。
  ///
  /// @see PhoneNumberAuthHelper#SERVICE_TYPE_AUTH  本机号码校验
  /// @see PhoneNumberAuthHelper#SERVICE_TYPE_LOGIN 一键登录校验
  @override
  Future<void> checkEnvAvailable() async {
    return await methodChannel.invokeMethod('checkEnvAvailable');
  }

  /// 获取授权页协议勾选框选中状态
  @override
  Future<void> queryCheckBoxIsChecked() async {
    return await methodChannel.invokeMethod('queryCheckBoxIsChecked');
  }

  /// 获取授权页协议勾选框选中状态
  @override
  Future<void> setCheckboxIsChecked() async {
    return await methodChannel.invokeMethod('setCheckboxIsChecked');
  }

  /// 强制关闭Loading
  @override
  Future<void> hideLoading() async {
    return await methodChannel.invokeMethod('hideLoading');
  }

  /// 强制关闭一键登录授权页面
  @override
  Future<String> getCurrentCarrierName() async {
    return await methodChannel.invokeMethod('getCurrentCarrierName');
  }

  /// pageRoute
  @override
  Future<void> openPage(String? pageRoute) async {
    return await methodChannel
        .invokeMethod('openPage', {'pageRoute': pageRoute ?? 'main_page'});
  }

  @override
  Future<dynamic> get checkCellularDataEnable async {
    return await methodChannel.invokeMethod('checkCellularDataEnable');
  }

  /// 苹果登录iOS专用
  @override
  Future<dynamic> get appleLogin async {
    return await methodChannel.invokeMethod('appleLogin');
  }

  /// 数据监听
  @override
  loginListen(
      {bool type = true,
      required Function onEvent,
      Function? onError,
      isOnlyOne = true}) async {
    /// 默认为初始化单监听
    if (isOnlyOne && streamSubscription != null) {
      /// 原来监听被移除
      dispose();
    }
    streamSubscription = onChange(type: type)!.listen(
        onEvent as void Function(dynamic)?,
        onError: onError,
        onDone: null,
        cancelOnError: null);
  }

  /// 暂停
  @override
  pause() {
    if (streamSubscription != null) {
      streamSubscription!.pause();
    }
  }

  /// 恢复
  @override
  resume() {
    if (streamSubscription != null) {
      streamSubscription!.resume();
    }
  }

  /// 销毁监听
  @override
  dispose() {
    if (streamSubscription != null) {
      streamSubscription!.cancel();
      streamSubscription = null;
    }
  }
}
