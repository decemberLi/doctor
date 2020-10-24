import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/login/find_password.dart';
import 'package:doctor/pages/login/login_by_chaptcha.dart';
import 'package:doctor/pages/login/login_by_password_page.dart';
import 'package:doctor/pages/login/login_page.dart';
import 'package:doctor/pages/patient/patient_detail_page.dart';
import 'package:doctor/pages/patient/patient_page.dart';
import 'package:doctor/pages/prescription/medication_page.dart';
import 'package:doctor/pages/prescription/prescription_detail_page.dart';
import 'package:doctor/pages/prescription/prescription_list_page.dart';
import 'package:doctor/pages/prescription/prescription_success_page.dart';
import 'package:doctor/pages/prescription/prescription_template_add_page.dart';
import 'package:doctor/pages/qualification/doctor_basic_info_page.dart';
import 'package:doctor/pages/splash/splash.dart';
import 'package:doctor/pages/test/test_page.dart';
import 'package:doctor/pages/user/about/about_us_page.dart';
import 'package:doctor/pages/user/update_pwd/update_pwd_page.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_page.dart';
import 'package:doctor/pages/worktop/learn/learn_upload_record/learn_upload_record.dart';
import 'package:doctor/pages/worktop/learn_plan_page.dart';
import 'package:doctor/pages/worktop/resource/resource_detail_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String LOGIN = '/login';
  static const String GUIDE = '/guide';
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
  static const String PRESCRIPTION_SUCCESS = '/prescription_success';
  static const String QUALIFICATION_PAGE = '/qualification_page';
  static const String PRESCRIPTION_LIST = '/prescription_list';
  static const String PRESCRIPTION_DETAIL = '/prescription_detail';
  static const String PATIENT = '/patient';
  static const String PATIENT_DETAIL = '/patient_detail';
  static Map<String, WidgetBuilder> routes = {
    GUIDE: (context) => GuidePage(),
    LOGIN: (context) => LoginPage(),
    LOGIN_PWD: (context) => LoginByPasswordPage(),
    LOGIN_CAPTCHA: (context) => LoginByCaptchaPage(),
    FIND_PWD: (context) => FindPassword(),
    HOME: (context) => HomePage(),
    TEST: (context) => TestPage(),
    LEARN_DETAIL: (context) => LearnDetailPage(),
    LEARN_UPLOAD_RECORD: (context) => LearnUploadRecordPage(),
    RESOURCE_DETAIL: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return ResourceDetailPage(obj["learnPlanId"], obj['resourceId']);
    },
    UPDATE_PWD: (context) => UpdatePwdPage(),
    ABOUT_US: (context) => AboutUs(),
    LEARN_PAGE: (context) => LearnPlanPage(),
    QUALIFICATION_PAGE: (context) => DoctorBasicInfoPage(),
    MEDICATION_LIST: (context) => MedicationPage(),
    PRESCRIPTION_TEMPLATE_ADD: (context) => PrescriptionTemplageAddPage(),
    PRESCRIPTION_SUCCESS: (context) => PrescriptionSuccessPage(),
    PRESCRIPTION_LIST: (context) => PrescriptionListPage(),
    PRESCRIPTION_DETAIL: (context) => PrescriptionDetailPage(),
    PATIENT: (context) => PatientListPage(),
    PATIENT_DETAIL: (context) => PatientDetailPage(),
  };
}
