import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    result["duration"] = this.duration;
    result["presenter"] = this.presenter;
    return result;
  }
}

class CachedLearnDetailVideoHelper {
  static String _keyVideoInfo = "_keyCachedVideoInfo";
  static String typeLearnVideo = "_typeLearnVideo";
  static String typeActivityVideo = "_typeActivityVideo";

  static void cacheVideoInfo(int userId,String type, CachedVideoInfo data) async {
    if (TextUtil.isEmpty(data.path) ||
        TextUtil.isEmpty(data.videoTitle) ||
        TextUtil.isEmpty(data.presenter)) {
      debugPrint("Param error -> ${data.json}");
      return;
    }

    var refs = await SharedPreferences.getInstance();
    refs.setString('$_keyVideoInfo-$type-$userId', json.encode(data.json));
  }

  static void cleanVideoCache(int userId, String type) async {
    var refs = await SharedPreferences.getInstance();
    refs.remove('$_keyVideoInfo-$type-$userId');
  }

  static Future<bool> hasCachedVideo(int userId, String type, {int id = -1}) async {
    var refs = await SharedPreferences.getInstance();
    var cacheStr = refs.getString('$_keyVideoInfo-$type-$userId');
    if (cacheStr == null || TextUtil.isEmpty(cacheStr)) {
      return false;
    }
    CachedVideoInfo info =
        CachedVideoInfo.fromJson(json.decode(cacheStr) as Map<String, dynamic>);

    if (id == -1) {
      return true;
    }
    return id == info.learnPlanId;
  }

  static Future<CachedVideoInfo> getCachedVideoInfo(int userId, String type) async {
    if(!await hasCachedVideo(userId, type)){
      return null;
    }
    var refs = await SharedPreferences.getInstance();
    return CachedVideoInfo.fromJson(json.decode(refs.getString('$_keyVideoInfo-$type-$userId'))
        as Map<String, dynamic>);
  }
}
