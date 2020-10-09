import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/login/login_by_password_page.dart';
import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/pages/test/test_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String LOGIN = '/login';
  static const String LOGIN_PWD = '/login_by_password';
  static const String HOME = '/home';
  static const String TEST = '/test';

  static Map<String, WidgetBuilder> routes = {
    LOGIN: (context) => LoginPage(),
    LOGIN_PWD: (context) => LoginByPasswordPage(),
    HOME: (context) => HomePage(),
    TEST: (context) => TestPage(),
  };
}
