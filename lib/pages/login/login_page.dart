import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(APP_NAME),
        ),
        // 避免键盘弹起时高度错误
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 34, bottom: 24),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                height: 172,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AceButton(
                      text: '微信一键登录',
                      onPressed: () => {EasyLoading.showToast('暂未开放')},
                    ),
                    AceButton(
                      type: AceButtonType.grey,
                      text: '输入手机号码登录',
                      onPressed: () => {print('111')},
                    ),
                    AceButton(
                      type: AceButtonType.grey,
                      text: '使用密码登录',
                      onPressed: () => {
                        Navigator.pushNamed(context, RouteManager.LOGIN_PWD)
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
