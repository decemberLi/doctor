import 'package:doctor/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// sesssion管理类
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  SharedPreferences sp;

  String session;

  SessionManager._internal() {
    this._initSP();
  }
  _initSP() async {
    sp = await SharedPreferences.getInstance();
    this.session = sp.getString(SESSION_KEY);
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
