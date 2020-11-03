import 'package:common_utils/common_utils.dart';

class AppRegexUtil extends RegexUtil {
  /// 不含有特殊字符
  static final String specialChart = "^[a-zA-Z0-9_\\-\u4e00-\u9fa5@\\s+]+\$";

  static bool isSpecialChart(String input) {
    return !RegexUtil.matches(specialChart, input);
  }
}
