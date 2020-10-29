import 'package:shared_preferences/shared_preferences.dart';

/// 工具类
class AppUtils {
  /// 本地缓存工具
  static SharedPreferences sp;

  static Future init() async {
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
    }
  }
}
