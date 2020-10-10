import 'package:doctor/pages/login/model/login_user.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// sesssion管理类
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  static Future init() async {
    return await _instance._initSP();
  }

  static loginHandler(String ticket, LoginUser loginUser) {
    _instance.setSession(ticket);
    _instance.sp.setString(LAST_PHONE, loginUser.mobile);
    NavigationService().pushNamedAndRemoveUntil(
        RouteManager.HOME, (Route<dynamic> route) => false);
  }

  static loginOutHandler() {
    _instance.setSession(null);
    NavigationService().pushNamedAndRemoveUntil(
        RouteManager.LOGIN, (Route<dynamic> route) => false);
  }

  SharedPreferences sp;

  String session;

  SessionManager._internal() {
    this._initSP();
  }

  _initSP() async {
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
      this.session = sp.getString(SESSION_KEY);
    }
    return sp;
  }

  /// 获取session
  getSession() {
    return this.session;
  }

  /// 设置session
  setSession(String session) {
    this.session = session;
    sp.setString(SESSION_KEY, session);
  }
}
