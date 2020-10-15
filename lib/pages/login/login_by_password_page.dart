import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/model/login_user.dart';
import 'package:doctor/pages/login/service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

import 'common_style.dart';

class LoginByPasswordPage extends StatefulWidget {
  @override
  _LoginByPasswordPageState createState() => _LoginByPasswordPageState();
}

class _LoginByPasswordPageState extends State<LoginByPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String _mobile, _password;

  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      var response = await loginByPassword(
          {'mobile': _mobile, 'password': _password, 'system': 'DOCTOR'});
      SessionManager.loginHandler(
          response['ticket'], LoginUser.fromJson(response['loginUser']));
    }
  }

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
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 30),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '密码登录',
                    style: TextStyle(
                        color: ThemeColor.colorFF000000,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    autofocus: true,
                    initialValue:
                        SessionManager().sp.getString(LAST_PHONE) ?? '',
                    decoration: InputDecoration(hintText: '请输入手机号'),
                    validator: (val) => val.length < 1 ? '手机号不能为空' : null,
                    onSaved: (val) => _mobile = val,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '请输入6位数字密码',
                      suffix: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteManager.HOME);
                        },
                        child: Text(
                          '找回密码',
                          style: TextStyle(
                              color: ThemeColor.primaryColor, fontSize: 14),
                        ),
                      ),
                    ),
                    validator: (val) => val.length < 6 ? '请输入6位数字密码' : null,
                    onSaved: (val) => _password = val,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: AceButton(
                    text: '登录',
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
