import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedVideoInfo {
  int learnPlanId;
  int resourceId;
  int duration;

  String videoTitle;
  String path;
  String presenter;

  CachedVideoInfo();

  CachedVideoInfo.fromJson(Map<String, dynamic> json) {
    this.learnPlanId = json["learnPlanId"] as int;
    this.resourceId = json["resourceId"] as int;
    this.videoTitle = json["videoTitle"] as String;
    this.path = json["path"] as String;
    this.duration = json["duration"] as int;
    this.presenter = json["presenter"] as String;
  }

  Map<String, dynamic> get json {
    var result = Map<String, dynamic>();
    result["learnPlanId"] = this.learnPlanId;
    result["resourceId"] = this.resourceId;
    result["videoTitle"] = this.videoTitle;
    result["path"] = this.path;
    return result;
  }
}

class CachedLearnDetailVideoHelper {
  static String _keyVideoInfo = "_keyCachedVideoInfo";

  static void cacheVideoInfo(int userId, CachedVideoInfo data) async {
    if (TextUtil.isEmpty(data.path) ||
        TextUtil.isEmpty(data.videoTitle) ||
        TextUtil.isEmpty(data.presenter)) {
      debugPrint("Param error -> ${data.json}");
      return;
    }

    var refs = await SharedPreferences.getInstance();
    refs.setString('$_keyVideoInfo-$userId', json.encode(data.json));
  }

  static void cleanVideoCache(int userId) async {
    var refs = await SharedPreferences.getInstance();
    refs.remove('$_keyVideoInfo-$userId');
  }

  static Future<bool> hasCachedVideo(int userId, {int learnPlanId = -1}) async {
    var refs = await SharedPreferences.getInstance();
    var cacheStr = refs.getString('$_keyVideoInfo-$userId');
    if (cacheStr == null) {
      return false;
    }
    CachedVideoInfo info =
        CachedVideoInfo.fromJson(json.decode(cacheStr) as Map<String, dynamic>);

    if (learnPlanId == -1) {
      return true;
    }
    return learnPlanId == info.learnPlanId;
  }

  static Future<CachedVideoInfo> getCachedVideoInfo(int userId) async {
    var refs = await SharedPreferences.getInstance();
    return CachedVideoInfo.fromJson(json.decode(refs.getString('$_keyVideoInfo-$userId'))
        as Map<String, dynamic>);
  }
}
