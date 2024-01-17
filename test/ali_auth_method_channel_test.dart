// import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:ali_auth/ali_auth_method_channel.dart';

void main() {
  // MethodChannelAliAuth platform = MethodChannelAliAuth();
  // const MethodChannel channel = MethodChannel('ali_auth');

  TestWidgetsFlutterBinding.ensureInitialized();

  // setUp(() {
  //   channel.setMockMethodCallHandler((MethodCall methodCall) async {
  //     return '42';
  //   });
  // });
  //
  // tearDown(() {
  //   channel.setMockMethodCallHandler(null);
  // });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}
