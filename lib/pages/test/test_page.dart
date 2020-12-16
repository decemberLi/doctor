import 'package:doctor/http/http_manager.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/session_manager.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, dynamic> userInfo;

  void login() async {

  }

  void getUserInfo()  {

    // dynamic response3 = await http2.post('/learn-plan/status-count', params: {
    //   'taskTemplate': ['SALON', 'DEPART'],
    // });
    // print('status-count: $response3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('测试页'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AceButton(onPressed: login, text: '登录'),
            AceButton(
                onPressed: () {
                  SessionManager.shared.session = null;
                },
                text: '退出登录'),
            AceButton(onPressed: getUserInfo, text: '获取用户信息'),
            Container(
              child: Text(userInfo != null ? userInfo['doctorName'] : ''),
            )
          ],
        ),
      ),
    );
  }
}
