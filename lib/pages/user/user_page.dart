import 'package:doctor/route/route_manager.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: AceButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.TEST);
                },
                text: '测试页'),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: AceButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.UPDATE_PWD);
                },
                text: '修改密码'),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: AceButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.ABOUT_US);
                },
                text: '关于我们'),
          )
        ],
      )),
    ));
  }
}
