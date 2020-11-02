import 'dart:convert';

import 'package:doctor/pages/login/model/login_info.dart';
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

  /// 获取登录信息
  static LoginInfoModel getLoginInfo() {
    return _instance.loginInfo;
  }

  static loginHandler(Map response) {
    LoginInfoModel loginInfo = LoginInfoModel.fromJson(response);
    _instance.setSession(loginInfo.ticket);
    _instance.loginInfo = loginInfo;
    _instance.sp.setString(LOGIN_INFO, jsonEncode(loginInfo.toJson()));
    _instance.sp.setString(LAST_PHONE, loginInfo.loginUser.mobile);
    NavigationService().pushNamedAndRemoveUntil(
        RouteManager.HOME, (Route<dynamic> route) => false);
  }

  static loginOutHandler() {
    _instance.setSession(null);
    NavigationService().pushNamedAndRemoveUntil(
        RouteManager.LOGIN_CAPTCHA, (Route<dynamic> route) => false);
  }

  SharedPreferences sp;

  String session;

  LoginInfoModel loginInfo;

  SessionManager._internal() {
    this._initSP();
  }

  _initSP() async {
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
      this.session = sp.getString(SESSION_KEY);
      this.setLoginInfoFromSp();
    }
    return sp;
  }

  setLoginInfoFromSp() {
    String info = sp.getString(LOGIN_INFO);
    if (info != null) {
      this.loginInfo = LoginInfoModel.fromJson(jsonDecode(info));
    }
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
