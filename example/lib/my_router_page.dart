import 'package:ali_auth_example/my_home_page.dart';
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
        child: Column(
          children: [
            const Text('通过原生控制flutter的跳转'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const MyHomePage();
                }));
              },
              child: const Text("跳转页面"),
            ),
          ],
        ),
      ),
    );
  }
}
