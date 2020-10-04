import 'package:flutter/material.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '易学术',
      theme: ThemeData(
        primaryColor: ThemeColor.primaryColor,
        buttonTheme: ButtonThemeData(buttonColor: ThemeColor.primaryColor),
        iconTheme: IconThemeData(color: ThemeColor.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      builder: (BuildContext context, Widget child) {
        /// 确保 loading 组件能覆盖在其他组件之上.
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
