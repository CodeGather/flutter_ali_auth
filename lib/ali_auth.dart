/* 
 * @Author: 21克的爱情
 * @Date: 2020-06-17 16:07:44
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-16 16:02:44
 * @Description: 
 */
import 'dart:async';

import 'package:flutter/services.dart';

class AliAuthPlugin {
  static const MethodChannel _channel = const MethodChannel('ali_auth');

  static const EventChannel _eventChannel = const EventChannel('ali_auth/event');

  Stream<dynamic> _onBatteryStateChanged;

  Stream<dynamic> get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged = _eventChannel.receiveBroadcastStream();
    }
    return _onBatteryStateChanged;
  }

  // 初始化SDK
  static Future<dynamic> initSdk(String sk) async {
    print("SDK sk=$sk");
    Map<String, String> params = {'sk': sk};
    return await _channel.invokeMethod("init", params);
  }

  /// SDK判断网络环境是否支持
  static Future<bool> get checkVerifyEnable async {
    return await _channel.invokeMethod("checkVerifyEnable");
  }
  
  // 一键登录
  static Future<dynamic> get login async {
    return await _channel.invokeMethod('login');
  }
  
  // 预取号
  static Future<dynamic> get preLogin async {
    return await _channel.invokeMethod('preLogin');
  }

  // 一键登录（ 弹窗 ）
  static Future<dynamic> get loginDialog async {
    return await _channel.invokeMethod('loginDialog');
  }

  // 苹果登录iOS专用
  static Future<dynamic> get appleLogin async {
    return await _channel.invokeMethod('appleLogin');
  }

  // 登录监听返回数据
  static loginListen({ bool type = true, Function onEvent, Function onError }) async {
    assert(onEvent != null);
    _eventChannel.receiveBroadcastStream( type ).listen(onEvent, onError: onError);
  }

}