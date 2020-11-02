import 'package:dio/dio.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/pages/login/login_footer.dart';
import 'package:doctor/pages/login/model/login_user.dart';
import 'package:doctor/pages/login/service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'common_style.dart';

class LoginByCaptchaPage extends StatefulWidget {
  @override
  _LoginByCaptchaPageState createState() => _LoginByCaptchaPageState();
}

class _LoginByCaptchaPageState extends State<LoginByCaptchaPage> {
  final _formKey = GlobalKey<FormState>();
  Timer _timer;
  int _maxCount = 0;
  String _mobile, _captcha;
  RegExp captcha = new RegExp(r'(^1\d{10}$)');

  bool _agree = false;

  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (!_agree) {
        EasyLoading.showToast('请阅读并同意《易学术服务协议》及《易学术隐私协议》');
        return;
      }
      var response = await loginByCaptCha(
          {'mobile': _mobile, 'code': _captcha, 'system': 'DOCTOR'});
      if (response is! DioError) {
        SessionManager.loginHandler(response);
      }
    }
  }

  void _captchaClick() async {
    final form = _formKey.currentState;
    form.save();
    if (captcha.hasMatch(_mobile)) {
      String system = 'DOCTOR';
      // // 查询用户是否存在
      // var res = await checkUserExists({
      //   'mobile': _mobile,
      //   'system': system,
      // });
      // String type = 'LOGIN';
      // if (res['exists'] == false) {
      //   type = 'USER_CREATE';
      // }
      // 获取验证码
      sendSms({'phone': _mobile, 'system': system, 'type': 'LOGIN'})
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
      body: SafeArea(
        bottom: true,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40, bottom: 30),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '验证码登录',
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
                          autovalidateMode: AutovalidateMode.always,
                          maxLength: 11,
                          initialValue:
                              SessionManager().sp.getString(LAST_PHONE) ?? '',
                          decoration: InputDecoration(
                            hintText: '请输入手机号',
                            counterText: '',
                          ),
                          validator: (val) =>
                              !captcha.hasMatch(val) ? '请输入正确的手机号' : null,
                          onSaved: (val) => _mobile = val,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          style: loginInputStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 44),
                        child: TextFormField(
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
                          maxLength: 4,
                          validator: (val) =>
                              val.length < 4 ? '请输入4位验证码' : null,
                          onSaved: (val) => _captcha = val,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          style: loginInputStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: AceButton(
                          text: '登录',
                          onPressed: _agree ? _submit : null,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: 310,
                        child: TextButton(
                            child: Text('账号密码登录'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RouteManager.LOGIN_PWD);
                            }),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: LoginFooter(onChange: (bool value) {
                      setState(() {
                        _agree = value;
                      });
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
