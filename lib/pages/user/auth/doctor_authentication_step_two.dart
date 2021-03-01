import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorAuthenticationStepTwoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorAuthenticationStepTwoPageState();
}

class DoctorAuthenticationStepTwoPageState
    extends State<DoctorAuthenticationStepTwoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColor.colorFFF3F5F8,
        appBar: AppBar(
          title: Text('医师身份认证'),
          elevation: 0,
        ),
        body: Container(),
      ),
    );
  }
}
