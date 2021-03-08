import 'dart:convert';

import 'package:doctor/utils/MedcloudsNativeApi.dart';

class Event {
  static const APP_LAUNCH = "app_launch";
  static const LOGIN = "account_login";
  static const QUESTION_SUBMIT = "questn_submit";
  static const PLAN_SUBMIT = "learn_plan_submit";
}

void eventTracker(String eventName, Map<String, String> ext) async {
  var arguments = jsonEncode({
    "eventName": eventName,
    "ext": jsonEncode(ext),
  });
  MedcloudsNativeApi.instance().eventTracker(eventName, arguments);
}
