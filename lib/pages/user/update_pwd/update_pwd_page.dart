import 'package:dio/dio.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/http/session_manager.dart';
import 'dart:async';
import 'service.dart';
import 'common_style.dart';

class UpdatePwdPage extends StatefulWidget {
  UpdatePwdPage({Key key}) : super(key: key);

  @override
  _UpdatePwdState createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwdPage> {
  final _formKey = GlobalKey<FormState>();
  RegExp pwd = new RegExp(r'(\d{6}$)');
  String oldPassword, newPassword, confirmPassword;
  bool pwdOldVisible = true;
  bool pwdNewVisible = true;
  bool pwdConfirmVisible = true;
  Future changePwd() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (newPassword != confirmPassword) {
        EasyLoading.showToast('两次新密码不一致，请重新输入');
      } else {
        changePassword({'oldPassword': oldPassword, 'newPassword': newPassword})
            .then((response) {
          if (!(response is DioError)) {
            SessionManager.loginOutHandler();
            const timeout = const Duration(seconds: 1);
            Timer(timeout, () {
              EasyLoading.showToast('密码更新成功，请重新登录');
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('我的资料'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        height: 500,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 40),
              child: Text(
                '修改密码',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 44),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '请输入原密码',
                          suffixIcon: IconButton(
                            icon: Icon(pwdOldVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => {
                              setState(() {
                                pwdOldVisible = !pwdOldVisible;
                              })
                            },
                          ),
                        ),
                        validator: (val) => val.length < 6 || !pwd.hasMatch(val)
                            ? '请输入6位数字密码'
                            : null,
                        onSaved: (val) => oldPassword = val,
                        obscureText: pwdOldVisible,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        style: pwdInputStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 44),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '请输入新密码',
                          suffixIcon: IconButton(
                            icon: Icon(pwdNewVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => {
                              setState(() {
                                pwdNewVisible = !pwdNewVisible;
                              })
                            },
                          ),
                        ),
                        validator: (val) => val.length < 6 || !pwd.hasMatch(val)
                            ? '请输入6位数字密码'
                            : null,
                        onSaved: (val) => newPassword = val,
                        obscureText: pwdNewVisible,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        style: pwdInputStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 44),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '再次输入密码',
                          suffixIcon: IconButton(
                            icon: Icon(pwdConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => {
                              setState(() {
                                pwdConfirmVisible = !pwdConfirmVisible;
                              })
                            },
                          ),
                        ),
                        validator: (val) => val.length < 6 || !pwd.hasMatch(val)
                            ? '请输入6位数字密码'
                            : null,
                        onSaved: (val) => confirmPassword = val,
                        obscureText: pwdConfirmVisible,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        style: pwdInputStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AceButton(onPressed: () => changePwd(), text: '修改'),
          ],
        ),
      ),
    );
  }
}
