// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// _RouteMainGenerator
// **************************************************************************

import "package:flutter/material.dart";
import "package:doctor/pages/activity/activity_research.dart";
import "package:yyy_route_annotation/yyy_route_annotation.dart";
import "package:doctor/pages/activity/activity_detail.dart";
import "package:doctor/pages/activity/widget/activity_resource_detail.dart";
import "package:doctor/pages/activity/activity_list_page.dart";
import "package:doctor/pages/user/auth/doctor_auth_step_two.dart";
import "package:doctor/pages/user/auth/auth_status_pass_page.dart";
import "package:doctor/pages/worktop/learn/learn_detail/learn_detail_page.dart";

Map<String, WidgetBuilder> routes() {
  routeMapping.addAll({
    "medical_survey_page": MRouteAware((context) {
      Map<String, dynamic> args = {};
      Map<String, dynamic> from =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (from != null) {
        args = from;
      }
      return ActivityResearch(
        typeConvert(args["activityPackageId"], int),
        activityTaskId: typeConvert(args["activityTaskId"], int),
      );
    }, false, false),
    "activity_detail_page": MRouteAware((context) {
      Map<String, dynamic> args = {};
      Map<String, dynamic> from =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (from != null) {
        args = from;
      }
      return ActivityDetail(
        typeConvert(args["activityPackageId"], int),
        typeConvert(args["type"], String),
      );
    }, true, true),
    "case_collection_page": MRouteAware((context) {
      Map<String, dynamic> args = {};
      Map<String, dynamic> from =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (from != null) {
        args = from;
      }
      return ActivityResourceDetailPage(
        typeConvert(args["activityPackageId"], int),
        typeConvert(args["activityTaskId"], int),
        status: typeConvert(args["status"], String),
        rejectReason: typeConvert(args["rejectReason"], String),
      );
    }, false, false),
    "activity_list_page": MRouteAware((context) {
      return ActivityListPage();
    }, false, false),
    "qualification_check_fail_page": MRouteAware((context) {
      return DoctorAuthenticationStepTwoPage();
    }, false, false),
    "auth_status_pass_page": MRouteAware((context) {
      return AuthStatusPassPage();
    }, false, false),
    "learn_detail_page": MRouteAware((context) {
      Map<String, dynamic> args = {};
      Map<String, dynamic> from =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (from != null) {
        args = from;
      }
      return LearnDetailPage(
        typeConvert(args["learnPlanId"], int),
        key: typeConvert(args["key"], Key),
      );
    }, false, false),
  });
  return routeMapping.map((key, value) => MapEntry(key, value.widgetBuilder));
}
