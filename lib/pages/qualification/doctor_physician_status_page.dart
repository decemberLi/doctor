import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorPhysicianStatusPage extends StatelessWidget {
  final String authStatus;

  DoctorPhysicianStatusPage(this.authStatus);

  @override
  Widget build(BuildContext context) {
    String authStatusNotice = '';
    String content = '';
    String assets = '';

    if (authStatus == 'VERIFYING') {
      authStatusNotice = '资质认证审核中';
      content = '您提交的信息将会在1-3个工作日内审核完成届时审核结果会以短信通知到您';
      assets = 'assets/images/qualification_checking.png';
    } else if (authStatus == 'PASS') {
      authStatusNotice = '已完成资质认证';
      assets = 'assets/images/qualification_pass.png';
      content = '已为您开通复诊开方服务';
    }

    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('医师资质认证'),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 150),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assets,
              width: 120,
              height: 120,
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Text(
                authStatusNotice,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColor.colorFF222222,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 28, left: 69, right: 69),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColor.colorFF999999,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
