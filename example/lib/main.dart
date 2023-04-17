import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'my_home_page.dart';
import 'my_home_page_web.dart';
import 'my_router_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    configLoading();
  }

  Widget getDefaultRouter() {
    //还记得我们上边的routerPage嘛， 这个东西就是我们传进来的字符串，我们可以根据这个字符串来决定加载那个flutter页面
    String router = window.defaultRouteName;
    if (kDebugMode) {
      print("获取到路由数据--------$router");
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      if (router.contains('routerPage')) {
        return const MyRouterPage();
      } else {
        return const MyHomePage();
      }
    } else {
      return const MyHomePageWeb();
    }
  }

  /// 弹窗插件初始化
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // 退出APP方法一
        EasyLoading.show(
          status: '您确定要退出思预云吗?',
        );
        return Future.value(false);
      }, // look here!
      child: MaterialApp(
        home: getDefaultRouter(),
        routes: <String, WidgetBuilder>{
          '/homePage': (BuildContext context) => const MyHomePage(),
          '/routerPage': (BuildContext context) => const MyRouterPage(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
