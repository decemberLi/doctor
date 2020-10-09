import 'package:doctor/http/http_manager.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/login_user.dart';

HttpManager http = HttpManager('sso');

loginHandler(String ticket, LoginUser loginUser) async {
  SharedPreferences sp = await SessionManager.init();
  SessionManager().setSession(ticket);
  NavigationService().pushNamedAndRemoveUntil(
      RouteManager.HOME, (Route<dynamic> route) => false);
}

loginOutHandler() {
  SessionManager().setSession(null);
  NavigationService().pushNamedAndRemoveUntil(
      RouteManager.LOGIN, (Route<dynamic> route) => false);
}

loginByPassword(params) {
  return http.post('/user/login-by-pwd',
      params: params, ignoreSession: true, loadingText: '登录中...');
}
