import 'package:flutter/material.dart';

class MyRouterPage extends StatefulWidget {
  const MyRouterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyRouterState();
  }
}

class MyRouterState extends State<MyRouterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我是被跳转页面'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text('通过原生控制flutter的跳转'),
      ),
    );
  }
}
