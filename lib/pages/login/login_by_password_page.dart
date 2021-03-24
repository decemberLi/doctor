import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:doctor/common/statistics/biz_tracker.dart';
import 'package:doctor/http/Sso.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/pages/login/login_footer.dart';
import 'package:doctor/pages/login/model/login_info.dart';
import 'package:doctor/provider/GlobalData.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_style.dart';

class LoginByPasswordPage extends StatefulWidget {

  final String phoneNumber;
  LoginByPasswordPage(this.phoneNumber);
  
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
      EasyLoading.instance.flash(() async {
        var response = await API.shared.sso.loginByPassword(
            {'mobile': _mobile, 'password': _password, 'system': 'DOCTOR'});
        LoginInfoModel infoModel = LoginInfoModel.fromJson(response);
        eventTracker(Event.LOGIN, {
          'user_id':'${infoModel?.userId}',
          'login_type':'2'
        });
        MedcloudsNativeApi.instance().login('${infoModel?.userId}');
        SessionManager.shared.session = infoModel.ticket;
        var sp = await SharedPreferences.getInstance();
        sp.setBool(
        KEY_DOCTOR_ID_MODIFIED_PWD, infoModel?.modifiedPassword ?? false);
        sp.setString(LAST_PHONE, _mobile);
        try {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          var params = {'appType':'DOCTOR'};
          if (Platform.isIOS) {
            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            print('Running on ${iosInfo.utsname.machine}');
            params['plantform'] = 'iOS';
            params['model'] = iosInfo.model;
            params['os'] = "${iosInfo.systemVersion}";
          } else if (Platform.isAndroid){
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            params['plantform'] = 'Android';
            params['model'] = androidInfo.model;
            params['os'] = "${androidInfo.version.sdkInt}";
          }
          params['deviceId'] = GlobalData.shared.registerId;
          params['registerId'] = GlobalData.shared.registerId;
          print("the params is -- $params");
          await API.shared.foundation.pushDeviceLoginSubmit(params);
        }catch(e){

        }
      }, text: '登录中...');
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
    getLastPhoneIfNeeded();
    super.initState();
  }

  getLastPhoneIfNeeded() async {
    if(!TextUtil.isEmpty(widget.phoneNumber)){
      _phoneController.text = widget.phoneNumber;
      return;
    }

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
            padding: EdgeInsets.only(left: 33, right: 33),
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
                          margin: const EdgeInsets.only(
                              top: 20, left: 11, right: 11),
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
                                  Navigator.of(context).pop(_phoneController.text);
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
