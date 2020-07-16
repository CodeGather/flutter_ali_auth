/* 
 * @Author: 21克的爱情
 * @Date: 2020-06-17 16:07:46
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-16 11:32:27
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:ali_auth/ali_auth.dart';
import 'home.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  BuildContext mContext;

  @override
  void initState() {
    super.initState();
    // 初始化插件
    AliAuthPlugin.initSdk('uYhNaUWEW+1rV9cq27oAQVWi8qFaF1wKfHr6BjrdnMoyQbtAxIA7q/ToLl1xKGCAwDl66Mii6KXK3FstD+PNcwS0aFCLorOrYHMHed8FX7AT8qu/AlzTXE05g0FmUMb5z1QKCiyvpmP+THs04fCfVtHsYdirkJGcd58r24o3QykIatcZYgd1jB3WAz3HLUqCg4afUK49SggbPdwscSfVV8wcB/hP+ST9kUVD02JmsqLA4YZUCRuUX2+o5AG1UpJwi/OHEccrFyEwuODaFzDSMPVth2pTZEwCB/g3PeLWhUQlWxvRqolgWQ==');
      
    // 登录监听
    AliAuthPlugin.loginListen( type: false, onEvent: _onEvent, onError: _onError);
    
  }

  // 错误处理
  void _onEvent(event) {
    print("------------------------------------------------------------------------------------------$event");
    Navigator.of(mContext).push(
      new MaterialPageRoute(builder: (_) {
        return Home();
      })
    );
  }

  // 成功后处理
  void _onError(error) {
    print("==========================================================================================$error");
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
        appBar: AppBar(
          title: const Text('阿里云一键登录插件'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                await AliAuthPlugin.loginDialog;
              },
              child: Text('弹窗登录'),
            ),
            RaisedButton(
              onPressed: () async {
                await AliAuthPlugin.login;
              },
              child: Text('直接登录'),
            ),
            RaisedButton(
              onPressed: () async {
                await AliAuthPlugin.checkVerifyEnable;
              },
              child: Text('检测环境是否支持'),
            ),
            RaisedButton(
              onPressed: () async {
                await AliAuthPlugin.appleLogin;
              },
              child: Text('apple登录'),
            ),
          ],
        ),
      );
  }
}
