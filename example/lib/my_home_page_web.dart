import 'dart:io';
import 'dart:ui';

import 'package:ali_auth/ali_auth.dart';
import 'package:ali_auth/ali_auth_web.dart';
import 'package:ali_auth_example/my_router_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePageWeb extends StatefulWidget {
  const MyHomePageWeb({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageWebState();
  }
}

class MyHomePageWebState extends State<MyHomePageWeb> with WidgetsBindingObserver {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await AliAuth.sdkVersion ?? 'Unknown platform version';
      AliAuth.checkAuthAvailable(
        "123",
        "1234",
        success: (status) {
          print(status);
          AliAuth.getVerifyToken(
            success: (status) {
              print(status);
            },
            error: (status) {
              print(status);
            }
          );
        },
        error: (status) {
          print(status);
        }
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              Text("当前SDK版本：$_platformVersion"),
              ElevatedButton(
                onPressed: () async {
                },
                child: const Text("开始全屏Video登录"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
