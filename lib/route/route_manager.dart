import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/login/find_password.dart';
import 'package:doctor/pages/login/login_by_password_page.dart';
import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/pages/prescription/medication_page.dart';
import 'package:doctor/pages/prescription/prescription_template_add_page.dart';
import 'package:doctor/pages/test/test_page.dart';
import 'package:doctor/pages/user/about/about_us_page.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_page.dart';
import 'package:doctor/pages/worktop/learn/learn_upload_record/learn_upload_record.dart';
import 'package:doctor/pages/worktop/resource/resource_detail_page.dart';
import 'package:doctor/pages/user/update_pwd/update_pwd_page.dart';
import 'package:doctor/pages/login/login_by_chaptcha.dart';
import 'package:doctor/pages/worktop/learn_plan_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String LOGIN = '/login';
  static const String LOGIN_PWD = '/login_by_password';
  static const String LOGIN_CAPTCHA = '/login_by_captcha';
  static const String FIND_PWD = '/find_password';
  static const String HOME = '/home';
  static const String TEST = '/test';
  static const String LEARN_DETAIL = '/learn_detail';
  static const String LEARN_UPLOAD_RECORD = '/learn_upload_record';
  static const String RESOURCE_DETAIL = '/resource_detail';
  static const String UPDATE_PWD = '/update_pwd';
  static const String ABOUT_US = '/about_us';
  static const String LEARN_PAGE = '/learn_page';
  static const String MEDICATION_LIST = '/medication_list';
  static const String PRESCRIPTION_TEMPLATE_ADD = '/prescription_template_add';

  static Map<String, WidgetBuilder> routes = {
    LOGIN: (context) => LoginPage(),
    LOGIN_PWD: (context) => LoginByPasswordPage(),
    LOGIN_CAPTCHA: (context) => LoginByCaptchaPage(),
    FIND_PWD: (context) => FindPassword(),
    HOME: (context) => HomePage(),
    TEST: (context) => TestPage(),
    LEARN_DETAIL: (context) => LearnDetailPage(),
    LEARN_UPLOAD_RECORD: (context) => LearnUploadRecordPage(),
    RESOURCE_DETAIL: (context) => ResourceDetailPage(),
    UPDATE_PWD: (context) => UpdatePwdPage(),
    ABOUT_US: (context) => AboutUs(),
    LEARN_PAGE: (context) => LearnPlanPage(),
    MEDICATION_LIST: (context) => MedicationPage(),
    PRESCRIPTION_TEMPLATE_ADD: (context) => PrescriptionTemplageAddPage(),
  };
}
