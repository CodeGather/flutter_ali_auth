/* 
 * @Author: 21克的爱情
 * @Date: 2020-06-18 15:27:59
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-11-19 09:52:10
 * @Description: 测试
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 测试
void main() {
  const MethodChannel channel = MethodChannel('ali_auth');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await AliAuth.platformVersion, '42');
  });
}
