import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String AGREE_KEY = 'AGREE_KEY';

var enableInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(width: 1, color: ThemeColor.colorFFE5E5E5),
);
var focusableInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(width: 1,color: ThemeColor.primaryColor),
);

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
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 1,right: 3),
              child: Icon(
                Icons.check_circle,
                color: _agree
                    ? ThemeColor.primaryColor
                    : ThemeColor.secondaryGeryColor,
                size: 15,
                textDirection: TextDirection.ltr,
              ),
            ),
            onTap: saveAgree,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "登录代表你已阅读并同意 ",
                        style: _testStyle(ThemeColor.secondaryGeryColor),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          saveAgree();
                        }
                      ),
                      TextSpan(
                        text: "《易学术服务协议》",
                        style: _testStyle(ThemeColor.primaryColor),
                        recognizer: _tap1
                          ..onTap = () {
                            FlutterFilePreview.openFile(
                              'https://static.e-medclouds.com/web/other/protocols/doctor_license_app.pdf',
                              title: '易学术服务协议',
                              context: context,
                            );
                          },
                      ),
                      TextSpan(
                          text: "及 ",
                          style: _testStyle(ThemeColor.secondaryGeryColor)),
                      TextSpan(
                        text: "《易学术隐私协议》",
                        style: _testStyle(ThemeColor.primaryColor),
                        recognizer: _tap2
                          ..onTap = () {
                            FlutterFilePreview.openFile(
                              'https://static.e-medclouds.com/web/other/protocols/doctor_privacy_app.pdf',
                              title: '易学术隐私协议',
                              context: context,
                            );
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.parent),
            ),
          )
        ],
      ),
    );
  }

  _testStyle(Color color) {
    return TextStyle(
        color: color, fontSize: 10, textBaseline: TextBaseline.ideographic);
  }
}
