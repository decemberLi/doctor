import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String AGREE_KEY = 'AGREE_KEY';

class LoginFooter extends StatefulWidget {
  final ValueChanged<bool> onChange;
  LoginFooter({this.onChange});

  @override
  _LoginFooterState createState() => _LoginFooterState();
}

class _LoginFooterState extends State<LoginFooter> {
  TapGestureRecognizer _tap1 = TapGestureRecognizer();
  TapGestureRecognizer _tap2 = TapGestureRecognizer();
  SharedPreferences sp;
  bool _agree = false;

  initAgree() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      _agree = sp.getBool(AGREE_KEY) ?? false;
      this.onChange();
    });
  }

  saveAgree() {
    setState(() {
      _agree = !_agree;
      sp.setBool(AGREE_KEY, _agree);
      this.onChange();
    });
  }

  onChange() {
    if (widget.onChange != null) {
      widget.onChange(_agree);
    }
  }

  @override
  void initState() {
    initAgree();
    super.initState();
  }

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tap1.dispose();
    _tap2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            icon: Icon(
              Icons.check_circle,
              color: _agree
                  ? ThemeColor.primaryColor
                  : ThemeColor.secondaryGeryColor,
              size: 16,
            ),
            onPressed: saveAgree,
          ),
          Container(
            width: 260,
            alignment: Alignment.topLeft,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: "登录代表你已阅读并同意 ",
                  style: MyStyles.greyTextStyle_12,
                ),
                TextSpan(
                  text: "《易学术服务协议》",
                  style: MyStyles.primaryTextStyle_12,
                  recognizer: _tap1
                    ..onTap = () {
                      FlutterFilePreview.openFile(
                        'https://static.e-medclouds.com/web/other/protocols/doctor_license_app.pdf',
                        title: '易学术服务协议',
                      );
                    },
                ),
                TextSpan(
                  text: "及 ",
                  style: MyStyles.greyTextStyle_12,
                ),
                TextSpan(
                  text: "《易学术隐私协议》",
                  style: MyStyles.primaryTextStyle_12,
                  recognizer: _tap2
                    ..onTap = () {
                      FlutterFilePreview.openFile(
                        'https://static.e-medclouds.com/web/other/protocols/doctor_privacy_app.pdf',
                        title: '易学术隐私协议',
                      );
                    },
                ),
              ]),
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
