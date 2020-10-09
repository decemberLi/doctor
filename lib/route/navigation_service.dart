import 'package:flutter/material.dart';

/// 路由服务
/// 适用于不使用BuildContext的路由的情况
class NavigationService {
  /// 路由服务
  /// 适用于不使用BuildContext的路由的情况
  factory NavigationService() => _getInstance();
  factory NavigationService.getInstance() => _getInstance();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  NavigationService._internal();

  static NavigationService _instance;

  static NavigationService _getInstance() {
    if (_instance == null) {
      _instance = new NavigationService._internal();
    }
    return _instance;
  }

  NavigatorState get navigator => navigatorKey.currentState;

  get pushNamed => navigator.pushNamed;
  get pushNamedAndRemoveUntil => navigator.pushNamedAndRemoveUntil;
  get push => navigator.push;
  get popAndPushNamed => navigator.popAndPushNamed;

  Future<dynamic> navigateTo(String routeName) {
    return navigator.pushNamed(routeName);
  }

  void goBack() {
    return navigator.pop();
  }
}
