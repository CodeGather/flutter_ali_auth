/* 
 * @Author: 21克的爱情
 * @Date: 2020-06-17 16:07:46
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-16 11:31:58
 * @Description: 
 */
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    
    
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('点击后打开的页面'),
        ),
        body: Center(
          child: Text('点击后打开的页面'),
        ),
      ),
    );
  }
}
