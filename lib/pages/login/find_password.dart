import 'package:dio/dio.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'common_style.dart';

class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  final _formKey = GlobalKey<FormState>();
  RegExp pwd = new RegExp(r'(\d{6}$)');
  String newPassword, confirmPassword;
  bool pwdNewVisible = true;
  bool pwdConfirmVisible = true;
  Timer _timer;
  int _maxCount = 0;
  String _mobile, _captcha;
  RegExp captcha = new RegExp(r'(^1\d{10}$)');
  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('$_mobile,$_captcha,$newPassword');
      if (newPassword != confirmPassword) {
        EasyLoading.showToast('两次新密码不一致，请重新输入');
      } else {
        var response = await findPwd({
          'phone': _mobile,
          'code': _captcha,
          'newPassword': newPassword,
          'system': 'DOCTOR',
        });
        if (response is! DioError) {
          SessionManager.loginOutHandler();
          Timer(Duration(seconds: 1), () {
            EasyLoading.showToast('修改密码成功，请重新登陆');
          });
        }
      }
    }
  }

  void _captchaClick() {
    final form = _formKey.currentState;
    form.save();
    if (captcha.hasMatch(_mobile)) {
      //获取验证码
      sendSms({'phone': _mobile, 'system': 'DOCTOR', 'type': 'FORGET_PASSWORD'})
          .then((response) {
        if (response is! DioError) {
          setState(() {
            _maxCount = 60;
          });
          startCountTimer();
        }
      });
    } else {
      EasyLoading.showToast('请输入正确的手机号');
    }
  }

  //计时器
  void startCountTimer() {
    const timeout = const Duration(seconds: 1);
    _timer = Timer.periodic(timeout, (timer) {
      if (_maxCount < 1) {
        _timer.cancel();
      } else {
        setState(() {
          _maxCount -= 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(APP_NAME),
        ),
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
                    '找回密码',
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
                    validator: (val) =>
                        !captcha.hasMatch(val) ? '请输入正确的手机号' : null,
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
                      hintText: '请输入验证码',
                      suffix: GestureDetector(
                          onTap: () {
                            //获取验证码
                            if (_maxCount == 0) {
                              _captchaClick();
                            }
                          },
                          child: Text(
                            _maxCount > 0 ? '$_maxCount s后重新获取' : '获取验证码',
                            style: TextStyle(
                                color: _maxCount > 0
                                    ? Colors.grey
                                    : ThemeColor.primaryColor,
                                fontSize: 14),
                          )),
                    ),
                    validator: (val) => val.length < 4 ? '请输入4位验证码' : null,
                    onSaved: (val) => _captcha = val,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
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
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
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
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: AceButton(
                    text: '确定',
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
