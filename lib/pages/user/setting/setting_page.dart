import 'package:doctor/http/session_manager.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Column(
        children: [
          _buildModifyPwdWidget(),
          _buildLogoutWidget(),
        ],
      ),
    );
  }

  _buildLogoutWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 24),
                child: Text(
                  '退出登陆',
                  style:
                      TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        SessionManager.loginOutHandler();
      },
    );
  }

  _buildModifyPwdWidget() {
    return GestureDetector(
      child: Container(
        height: 50,
        padding: EdgeInsets.only(right: 18),
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 24),
              child: Text(
                '修改登陆密码',
                style: TextStyle(color: ThemeColor.colorFF222222, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeColor.colorFF000000,
              size: 12,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.MODIFY_PWD);
      },
    );
  }
}
