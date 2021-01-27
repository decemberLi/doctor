import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:doctor/pages/login/login_footer.dart';
import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/pages/login/model/login_user.dart';
import 'package:doctor/provider/GlobalData.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:http_manager/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'common_style.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/http/Sso.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'dart:io';

class LoginByCaptchaPage extends StatefulWidget {
  @override
  _LoginByCaptchaPageState createState() => _LoginByCaptchaPageState();
}

class _LoginByCaptchaPageState extends State<LoginByCaptchaPage> {
  final _formKey = GlobalKey<FormState>();
  Timer _timer;
  int _maxCount = 0;
  String _mobile, _captcha;
  int subscribeId;
  bool _agree = false;
  var _phoneController = TextEditingController();

  Future _submit() async {
    final form = _formKey.currentState;
    if (!_agree) {
      EasyLoading.showToast('请阅读并同意《易学术服务协议》及《易学术隐私协议》');
      return;
    }
    if (form.validate()) {
      form.save();
      EasyLoading.instance.flash(() async {
        var response = await API.shared.sso.loginByCaptCha(
            {'mobile': _mobile, 'code': _captcha, 'system': 'DOCTOR'});
        LoginInfoModel infoModel = LoginInfoModel.fromJson(response);
        SessionManager.shared.session = infoModel.ticket;
        var sp = await SharedPreferences.getInstance();
        sp.setString(LAST_PHONE, _mobile);
        sp.setBool(
        KEY_DOCTOR_ID_MODIFIED_PWD, infoModel.modifiedPassword ?? false);
        try {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          var params = {'appType':'DOCTOR'};
          if (Platform.isIOS) {
            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            print('Running on ${iosInfo.utsname.machine}');
            params['platform'] = 'iOS';
            params['model'] = iosInfo.model;
            params['os'] = "${iosInfo.systemVersion}";
          } else if (Platform.isAndroid){
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            params['platform'] = 'Android';
            params['model'] = androidInfo.model;
            params['os'] = "${androidInfo.version.sdkInt}";
          }
          params['deviceId'] = GlobalData.shared.registerId;
          params['registerId'] = GlobalData.shared.registerId;
          print("the params is -- ${params}");
          await API.shared.foundation.pushDeviceLoginSubmit(params);
        }catch(e){

        }
      }, text: '登录中...');
    }
  }

  void _captchaClick() async {
    final form = _formKey.currentState;
    form.save();
    if (RegexUtil.isMobileSimple(_mobile)) {
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
      EasyLoading.show(status: "发送中...");
      var params = {'phone': _mobile, 'system': system, 'type': 'LOGIN'};
      API.shared.foundation.sendSMS(params).then((response) {
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
    getLastPhone();
    super.initState();
  }

  getLastPhone() async {
    var sp = await SharedPreferences.getInstance();
    var phone = sp.get(LAST_PHONE);
    if (phone is String) {
      _phoneController.text = phone ?? '';
    }
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
            padding: EdgeInsets.only(left: 33, right: 33),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 12,
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '手机快捷登录',
                      style: TextStyle(
                          color: ThemeColor.colorFF000000,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 16),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '未注册手机号验证后将自动创建账号',
                      style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      controller: _phoneController,
                      autofocus: false,
                      maxLength: 11,
                      decoration: InputDecoration(
                          hintText: '请输入手机号',
                          counterText: '',
                          focusedBorder: focusableInputBorder,
                          enabledBorder: enableInputBorder),
                      validator: (val) =>
                          !RegexUtil.isMobileSimple(val) ? '请输入正确的手机号' : null,
                      onSaved: (val) => _mobile = val,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      style: loginInputStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '请输入验证码',
                        counterText: '',
                        focusedBorder: focusableInputBorder,
                        enabledBorder: enableInputBorder,
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
                      validator: (val) => val.length < 4 ? '请输入4位验证码' : null,
                      onSaved: (val) => _captcha = val,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      style: loginInputStyle,
                    ),
                  ),
                  LoginFooter(onChange: (bool value) {
                    setState(() {
                      _agree = value;
                    });
                  }),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    child: AceButton(
                      text: '登录',
                      color: _agree
                          ? null
                          : ThemeColor.primaryColor.withOpacity(0.5),
                      onPressed: _submit,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 11, right: 11),
                    alignment: Alignment.topLeft,
                    width: 310,
                    child: GestureDetector(
                        child: Text(
                          '账号密码登录',
                          style: TextStyle(
                              color: ThemeColor.primaryColor, fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.LOGIN_PWD);
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
