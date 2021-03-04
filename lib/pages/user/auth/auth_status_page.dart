import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthStatusPage extends StatelessWidget {
  final String authStatus;

  AuthStatusPage(this.authStatus);

  @override
  Widget build(BuildContext context) {
    String authStatusNotice = '';
    Widget contentWidget = Container();
    String assets = '';
    var style = TextStyle(
      fontSize: 12,
      color: ThemeColor.colorFF999999,
    );

    if (authStatus == 'VERIFYING') {
      authStatusNotice = '医师身份认证审核中';
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('您提交的信息将会在1-3个工作日内审核完成',
              textAlign: TextAlign.center, style: style),
          Text('届时审核结果会通知到您', textAlign: TextAlign.center, style: style),
        ],
      );
      assets = 'assets/images/qualification_checking.png';
    } else if (authStatus == 'PASS') {
      assets = 'assets/images/qualification_pass.png';
      authStatusNotice = '医师身份认证已通过';
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('您可以开始做医师身份认证学习任务啦', textAlign: TextAlign.center, style: TextStyle(
            fontSize: 10,
            color: ThemeColor.colorFF999999,
          )),
        ],
      );
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
              child: contentWidget,
            )
          ],
        ),
      ),
    );
  }
}
