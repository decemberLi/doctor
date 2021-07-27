import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';

import 'common_style.dart';

class SetNewPwdPage extends StatefulWidget {
  SetNewPwdPage({Key key}) : super(key: key);

  @override
  _SetNewPwdState createState() => _SetNewPwdState();
}

class _SetNewPwdState extends State<SetNewPwdPage> {
  final _formKey = GlobalKey<FormState>();
  RegExp pwd = new RegExp(r'(\d{6}$)');
  String newPassword, confirmPassword;
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
        API.shared.ucenter.changePassword({'newPassword': newPassword}).then((response) {
          if (response is! DioError) {
            const timeout = const Duration(seconds: 1);
            Timer(timeout, () {
              EasyLoading.showToast('密码设置成功');
              Navigator.popUntil(
                  context, ModalRoute.withName(RouteManagerOld.HOME));
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
        title: Text('设置登录密码'),
      ),
      // 避免键盘弹起时高度错误
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 44),
                        child: TextFormField(
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: '请输入新密码',
                            counterText: '',
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
                          validator: (val) =>
                              val.length < 6 || !pwd.hasMatch(val)
                                  ? '请输入6位数字密码'
                                  : null,
                          onSaved: (val) => newPassword = val,
                          obscureText: pwdNewVisible,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          style: pwdInputStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 44),
                        child: TextFormField(
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: '再次输入密码',
                            counterText: '',
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
                          validator: (val) =>
                              val.length < 6 || !pwd.hasMatch(val)
                                  ? '请输入6位数字密码'
                                  : null,
                          onSaved: (val) => confirmPassword = val,
                          obscureText: pwdConfirmVisible,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          style: pwdInputStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AceButton(onPressed: () => changePwd(), text: '确认'),
            ],
          ),
        ),
      ),
    );
  }
}
