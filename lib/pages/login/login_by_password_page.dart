import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:doctor/pages/login/login_footer.dart';
import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/pages/login/model/login_user.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/adapt.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:http_manager/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor/http/Sso.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

import 'common_style.dart';

class LoginByPasswordPage extends StatefulWidget {
  @override
  _LoginByPasswordPageState createState() => _LoginByPasswordPageState();
}

class _LoginByPasswordPageState extends State<LoginByPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String _mobile, _password;
  bool _agree = false;
  int subscribeId;
  var _phoneController = TextEditingController();

  Future _submit() async {
    final form = _formKey.currentState;
    if (!_agree) {
      EasyLoading.showToast('请阅读并同意《易学术服务协议》及《易学术隐私协议》');
      return;
    }
    if (form.validate()) {
      form.save();
      try{
        await EasyLoading.instance.flash(() async {
          var response = await API.shared.sso.loginByPassword(
              {'mobile': _mobile, 'password': _password, 'system': 'DOCTOR'});
          LoginInfoModel.shared = LoginInfoModel.fromJson(response);
          SessionManager.shared.session = LoginInfoModel.shared.ticket;
          var sp = await SharedPreferences.getInstance();
          sp.setString(LAST_PHONE, _mobile);
        }, text: '登录中...');
      }on DioError catch (e){
        EasyLoading.showToast(e.message);
      }

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
    KeyboardVisibilityNotification().removeListener(subscribeId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
      ),
      // 避免键盘弹起时高度错误
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
            padding: EdgeInsets.only(left: 36, right: 28),
            child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 12, bottom: 40),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '账号密码登录',
                            style: TextStyle(
                                color: ThemeColor.colorFF000000,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 37),
                          child: TextFormField(
                            controller: _phoneController,
                            autofocus: false,
                            maxLength: 11,
                            decoration: InputDecoration(
                                hintText: '请输入手机号',
                                counterText: '',
                                focusedBorder: focusableInputBorder,
                                enabledBorder: enableInputBorder),
                            validator: (val) => !RegexUtil.isMobileSimple(val)
                                ? '请输入正确的手机号'
                                : null,
                            onSaved: (val) => _mobile = val,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            style: loginInputStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            maxLength: 6,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: '请输入6位数字密码',
                                counterText: '',
                                focusedBorder: focusableInputBorder,
                                enabledBorder: enableInputBorder),
                            validator: (val) =>
                                val.length < 6 ? '请输入6位数字密码' : null,
                            onSaved: (val) => _password = val,
                            obscureText: true,
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
                          margin: EdgeInsets.only(top: 10),
                          child: AceButton(
                            text: '登录',
                            color: _agree
                                ? null
                                : ThemeColor.primaryColor.withOpacity(0.5),
                            onPressed: _submit,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          width: 310,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Text(
                                  '验证码登录',
                                  style: TextStyle(
                                      color: ThemeColor.primaryColor,
                                      fontSize: 12),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              GestureDetector(
                                child: Text('找回密码',
                                    style: TextStyle(
                                        color: ThemeColor.primaryColor,
                                        fontSize: 12)),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.FIND_PWD);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
