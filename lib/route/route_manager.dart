import 'package:doctor/common/env/environment.dart';
import 'package:doctor/common/env/url_provider.dart';
import 'package:doctor/pages/doctors/doctors_list_page.dart';
import 'package:doctor/pages/doctors/doctors_list_page2.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/login/find_password.dart';
import 'package:doctor/pages/login/login_by_chaptcha.dart';
import 'package:doctor/pages/login/login_by_password_page.dart';
import 'package:doctor/pages/medication/medication_detail_page.dart';
import 'package:doctor/pages/medication/medication_page.dart';
import 'package:doctor/pages/patient/patient_detail_page.dart';
import 'package:doctor/pages/patient/patient_page.dart';
import 'package:doctor/pages/prescription/prescription_detail_page.dart';
import 'package:doctor/pages/prescription/prescription_list_page.dart';
import 'package:doctor/pages/prescription/prescription_preview_page.dart';
import 'package:doctor/pages/prescription/prescription_success_page.dart';
import 'package:doctor/pages/prescription/prescription_template_add_page.dart';
import 'package:doctor/pages/qualification/doctor_basic_info_page.dart';
import 'package:doctor/pages/splash/splash.dart';
import 'package:doctor/pages/user/about/about_us_page.dart';
import 'package:doctor/pages/user/auth/auth_status_pass_page.dart';
import 'package:doctor/pages/user/auth/auth_status_verifying_page.dart';
import 'package:doctor/pages/user/auth/doctor_auth_step_one.dart';
import 'package:doctor/pages/user/auth/doctor_auth_step_two.dart';
import 'package:doctor/pages/user/collect/collect_list.dart';
import 'package:doctor/pages/user/setting/setting_page.dart';
import 'package:doctor/pages/user/update_pwd/set_new_pwd.dart';
import 'package:doctor/pages/user/update_pwd/update_pwd_page.dart';
import 'package:doctor/pages/user/user_detail/user_edit_page.dart';
import 'package:doctor/pages/user/user_detail/user_info_detai.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_page.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/look_course_page.dart';
import 'package:doctor/pages/worktop/learn/learn_list/learn_list_view.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/look_lecture_video_page.dart';
import 'package:doctor/pages/worktop/learn_plan_page.dart';
import 'package:doctor/pages/worktop/resource/resource_detail_page.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String HOME = '/home';
  static const String GUIDE = '/guide';
  static const String LOGIN_PWD = '/login_by_password';
  static const String LOGIN_CAPTCHA = '/login_by_captcha';
  static const String FIND_PWD = '/find_password';
  static const String LEARN_LIST = '/learn_list';
  static const String LEARN_DETAIL = '/learn_detail';
  static const String LOOK_LECTURE_VIDEOS = '/look_lecture_video_page';
  static const String LOOK_COURSE_PAGE = '/look_course_page';
  static const String RESOURCE_DETAIL = '/resource_detail';
  static const String UPDATE_PWD = '/update_pwd';
  static const String SET_NEW_PWD = '/set_new_pwd';
  static const String ABOUT_US = '/about_us';
  static const String LEARN_PAGE = '/learn_page';
  static const String MEDICATION_LIST = '/medication_list';
  static const String MEDICATION_DETAIL = '/medication_detail';
  static const String PRESCRIPTION_TEMPLATE_ADD = '/prescription_template_add';
  static const String PRESCRIPTION_SUCCESS = '/prescription_success';
  static const String QUALIFICATION_PAGE = '/qualification_page';
  static const String PRESCRIPTION_LIST = '/prescription_list';
  static const String PRESCRIPTION_DETAIL = '/prescription_detail';
  static const String PRESCRIPTION_PREVIEW = '/prescription_preview';
  static const String PATIENT = '/patient';
  static const String PATIENT_DETAIL = '/patient_detail';
  static const String COLLECT_DETAIL = '/collect_detail';
  static const String USERINFO_DETAIL = '/user_detail';
  static const String EDIT_DOCTOR_PAGE = '/edit_user_detail';
  static const String SETTING = '/setting';
  static const String MODIFY_PWD = '/modify_pwd';
  static const String DOCTOR_LIST1 = '/DoctorList1';
  static const String DOCTOR_LIST2 = '/DoctorList2';
  // 未认证
  static const String DOCTOR_AUTHENTICATION_INFO_PAGE = '/DoctorAuthenticationInfoPage';
  // 认证失败
  static const String DOCTOR_AUTHENTICATION_PAGE = '/DoctorAuthenticationPage';
  // 认证中
  static const String DOCTOR_AUTH_STATUS_VERIFYING_PAGE = '/AuthStatusPageVerifying';
  // 认证成功
  static const String DOCTOR_AUTH_STATUS_PASS_PAGE = '/AuthStatusPagePass';

  static Map<String, WidgetBuilder> routes = {
    GUIDE: (context) => GuidePage(),
    LOGIN_PWD: (context){
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return LoginByPasswordPage(obj['phoneNumber']);
    },
    LOGIN_CAPTCHA: (context) => LoginByCaptchaPage(),
    FIND_PWD: (context) => FindPassword(),
    HOME: (context) => HomePage(),
    LEARN_LIST: (context) => LearnListPage('LEARNING'),
    LEARN_DETAIL: (context) => LearnDetailPage(),
    LOOK_LECTURE_VIDEOS: (context) => LookLectureVideosPage(),
    LOOK_COURSE_PAGE: (context) => LookCoursePage(),
    RESOURCE_DETAIL: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return ResourceDetailPage(
        obj["learnPlanId"],
        obj['resourceId'],
        obj['favoriteId'],
        obj['taskTemplate'],
        obj['meetingStartTime'],
        obj['meetingEndTime'],
        obj['taskDetailId'],
        obj['from'],
      );
    },
    UPDATE_PWD: (context) => UpdatePwdPage(),
    SET_NEW_PWD: (context) => SetNewPwdPage(),
    ABOUT_US: (context) => AboutUs(),
    LEARN_PAGE: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return LearnPlanPage(index: obj['index']);
    },
    QUALIFICATION_PAGE: (context) => DoctorBasicInfoPage(),
    MEDICATION_LIST: (context) => MedicationPage(),
    MEDICATION_DETAIL: (context) => MedicationDetailPage(),
    PRESCRIPTION_TEMPLATE_ADD: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return PrescriptionTemplageAddPage(
        action: obj['action'],
        data: obj['data'],
      );
    },
    PRESCRIPTION_SUCCESS: (context) => PrescriptionSuccessPage(),
    PRESCRIPTION_LIST: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return PrescriptionListPage(
        from: obj['from'],
      );
    },
    PRESCRIPTION_DETAIL: (context) => PrescriptionDetailPage(),
    PRESCRIPTION_PREVIEW: (context) => PrescriptionPreviewPage(),
    PATIENT: (context) => PatientListPage(),
    PATIENT_DETAIL: (context) => PatientDetailPage(),
    COLLECT_DETAIL: (context) => CollectDetailList(),
    USERINFO_DETAIL: (context) {
      dynamic data = ModalRoute.of(context).settings.arguments as Map;
      return DoctorUserInfo(data['doctorData'], data['openType'] ?? 'VIEW',
          data['qualification'] ?? false);
    },
    SETTING: (context) => SettingPage(),
    MODIFY_PWD: (context) => UpdatePwdPage(),
    EDIT_DOCTOR_PAGE: (context) {
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return UserEditPage(
          obj['lable'], obj['value'], obj['editWay'], obj['function']);
    },
    DOCTOR_LIST1: (context){
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return DoctorsListPage(obj);
    },
    DOCTOR_LIST2: (context){
      dynamic obj = ModalRoute.of(context).settings.arguments;
      return DoctorsListPage2(obj);
    },
    DOCTOR_AUTHENTICATION_INFO_PAGE:(context){
      return DoctorAuthenticationPage();
    },
    DOCTOR_AUTHENTICATION_PAGE:(context){
      return DoctorAuthenticationStepTwoPage();
    },
    DOCTOR_AUTH_STATUS_VERIFYING_PAGE: (context) => AuthStatusVerifyingPage(),
    DOCTOR_AUTH_STATUS_PASS_PAGE: (context) => AuthStatusPassPage(),
  };

  static openDoctorsDetail(postId, {String from = "list"}) {
    String url =
        "${UrlProvider.doctorsCircleUrl(Environment.instance)}?id=$postId&from=$from";
    MedcloudsNativeApi.instance().openWebPage(url);
  }

  static openWebPage(String url){
    MedcloudsNativeApi.instance().openWebPage(url);
  }
}
