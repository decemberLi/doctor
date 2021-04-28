import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:doctor/http/Sso.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int subscribeId;
  String lastPhone;
  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('$_mobile,$_captcha,$newPassword');
      if (newPassword != confirmPassword) {
        EasyLoading.showToast('两次新密码不一致，请重新输入');
      } else {
        EasyLoading.instance.flash(()async{
          var response = await API.shared.sso.findPwd({
            'phone': _mobile,
            'code': _captcha,
            'newPassword': newPassword,
            'system': 'DOCTOR',
          });
          if (response is! DioError) {
            // SessionManager.loginOutHandler();
            Timer(Duration(seconds: 1), () {
              EasyLoading.showToast('修改密码成功，请重新登录');
              Navigator.pop(context);
            });
          }
        },text: '密码修改中...');
      }
    }
  }

  void _captchaClick() {
    final form = _formKey.currentState;
    form.save();
    if (RegexUtil.isMobileSimple(_mobile)) {
      //获取验证码
      EasyLoading.show(status: "发送中...");
      var params = {'phone': _mobile, 'system': 'DOCTOR', 'type': 'FORGET_PASSWORD'};
      API.shared.foundation.sendSMS(params)
          .then((response) {
            EasyLoading.dismiss();
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

  @override
  void initState() {
    //监听键盘高度变化
    subscribeId = KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          //键盘下降失去焦点
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
    );
    readLastPhone();
    super.initState();
  }

  readLastPhone() async {
    var sp = await SharedPreferences.getInstance();
    var phone = sp.get(LAST_PHONE);
    if (phone is String) {
      setState(() {
        lastPhone = phone;
      });
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
    KeyboardVisibilityNotification().removeListener(subscribeId);
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('找回密码'),
      ),
      // resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Form(
            key: _formKey,
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 30),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '验证手机号',
                    style: TextStyle(
                        color: ThemeColor.colorFF000000,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    autofocus: false,
                    maxLength: 11,
                    initialValue:
                        lastPhone ?? '',
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      counterText: '',
                    ),
                    validator: (val) =>
                        !RegexUtil.isMobileSimple(val) ? '请输入正确的手机号' : null,
                    onSaved: (val) => _mobile = val,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
                  child: TextFormField(
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      counterText: '',
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          left: 10,
                          right: 0,
                          bottom: 0,
                        ),
                        child: GestureDetector(
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
                          ),
                        ),
                      ),
                    ),
                    validator: (val) => val.length < 4 ? '请输入4位验证码' : null,
                    onSaved: (val) => _captcha = val,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
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
                    validator: (val) => val.length < 6 || !pwd.hasMatch(val)
                        ? '请输入6位数字密码'
                        : null,
                    onSaved: (val) => newPassword = val,
                    obscureText: pwdNewVisible,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    style: loginInputStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 44),
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
                    validator: (val) => val.length < 6 || !pwd.hasMatch(val)
                        ? '请输入6位数字密码'
                        : null,
                    onSaved: (val) => confirmPassword = val,
                    obscureText: pwdConfirmVisible,
                    keyboardType: TextInputType.number,
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
        ),
      ),
    );
  }
}
