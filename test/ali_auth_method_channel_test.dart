// import 'package:flutter/services.dart';
import 'package:ali_auth/ali_auth_model.dart';
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

  test('serializes HarmonyOS secret without changing positional secrets', () {
    final model = AliAuthModel(null, null, ohosSk: 'ohos-secret');

    expect(model.androidSk, isNull);
    expect(model.iosSk, isNull);
    expect(model.toJson()['ohosSk'], 'ohos-secret');

    final legacyModel = AliAuthModel('android-secret', 'ios-secret');
    expect(legacyModel.toJson()['androidSk'], 'android-secret');
    expect(legacyModel.toJson()['iosSk'], 'ios-secret');
    expect(legacyModel.toJson()['ohosSk'], isNull);
  });
}
