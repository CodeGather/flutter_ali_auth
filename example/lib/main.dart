import 'dart:ui';
import 'package:flutter/material.dart';
import 'my_home_page.dart';
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
  Widget getDefaultRouter() {
    //还记得我们上边的routerPage嘛， 这个东西就是我们传进来的字符串，我们可以根据这个字符串来决定加载那个flutter页面
    String router = window.defaultRouteName;
    if (router == 'routerPage') {
      return const MyRouterPage();
    } else {
      return const MyHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: getDefaultRouter(),
      routes: <String, WidgetBuilder>{
        '/homePage': (BuildContext context) => const MyHomePage(),
        '/routerPage': (BuildContext context) => const MyRouterPage(),
      },
    );
  }
}
