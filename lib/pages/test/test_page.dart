import 'package:doctor/http/http_manager.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, dynamic> userInfo;

  void login() async {
    HttpManager http = HttpManager('sso');
    dynamic response = await http.post('/user/login-by-pwd',
        params: {
          'mobile': '18866660000',
          'password': '111111',
          'system': 'DOCTOR'
        },
        ignoreSession: true);
    print('ticket:${response['ticket']}');
    SessionManager().setSession(response['ticket']);
  }

  void getUserInfo() async {
    HttpManager http = HttpManager('ucenter');
    dynamic response = await http.request('post', '/my/query');
    print('userInfo: $response');
    setState(() {
      userInfo = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    SessionManager();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(child: Text('登录'), onPressed: login),
            RaisedButton(child: Text('获取用户信息'), onPressed: getUserInfo),
            Container(
              child: Text(userInfo != null ? userInfo['doctorName'] : ''),
            )
          ],
        ),
      ),
    );
  }
}
