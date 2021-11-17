import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/provider/GlobalData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/foundation.dart';

typedef OnNativeProcessor = Future Function(String args);

class MedcloudsNativeApi {
  MethodChannel _channel = MethodChannel("com.emedclouds-channel/navigation");
  Map<String, OnNativeProcessor> _map = {};

  static MedcloudsNativeApi _instance;

  MedcloudsNativeApi._() {
    print("MedcloudsNativeApi");
    _channel.setMethodCallHandler((call) async {
      print("call method");
      try {
        if (_map.containsKey(call.method)) {
          return await _map[call.method](call.arguments);
        }
      } on DioError catch (e) {
        print("----------------------${e.message}");
        if (e.message.contains("SocketException")) {
          return "网络错误";
        }
        return "${e.message}";
      } catch (e) {
        print("----------------------$e");
        return "$e";
      }

      return null;
    });
  }

  static MedcloudsNativeApi instance() {
    if (_instance == null) {
      _instance = MedcloudsNativeApi._();
    }
    return _instance;
  }

  void addProcessor(String method, OnNativeProcessor processor) {
    if (method == null) {
      print('method must be not null.');
    }
    if (processor == null) {
      print('processor must be not null.');
    }
    if (_map.containsKey(method)) {
      print('[$method] already registered');
    }
    _map[method] = processor;
  }

  Future share(String args) async {
    return await _channel.invokeMapMethod("share", args);
  }

  Future record(String args) async {
    return await _channel.invokeMapMethod("record", args);
  }

  Future checkNotification() async {
    return await _channel.invokeMethod("checkNotification");
  }

  Future openSetting() async {
    return await _channel.invokeMethod("openSetting");
  }

  Future openWebPage(String url, {String title = ""}) async {
    var arguments = json.encode({"url": url, "title": title});
    return await _channel.invokeMethod("openWebPage", arguments);
  }

  Future openFile(String url, {String title = ""}) async {
    var arguments = json.encode({"url": url, "title": title});
    return await _channel.invokeMethod("openFile", arguments);
  }

  Future ocrIdCardFaceSide() async {
    return await _channel.invokeMethod("ocrIdCardFaceSide");
  }

  Future ocrIdCardBackSide() async {
    return await _channel.invokeMethod("ocrIdCardBackSide");
  }

  Future ocrBankCard() async {
    return await _channel.invokeMethod("ocrBankCard");
  }

  Future eventTracker(String eventName, dynamic arguments) async {
    return await _channel.invokeMethod("eventTracker", arguments);
  }

  Future login(String userId) async {
    return await _channel.invokeMethod("login", userId);
  }

  Future logout() async {
    return await _channel.invokeMethod("logout");
  }

  Future uploadDeviceInfo(args) async {
    try {
      var ids = json.decode(args);
      var registerId = ids["registerId"];
      if (TextUtil.isEmpty(registerId)) {
        return;
      }
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var params = {'appType': 'DOCTOR'};
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('Running on ${iosInfo.utsname.machine}');
        params['plantform'] = 'iOS';
        params['model'] = iosInfo.model;
        params['os'] = "${iosInfo.systemVersion}";
        params['deviceId'] = "${iosInfo.identifierForVendor}";
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        params['plantform'] = 'Android';
        params['model'] = androidInfo.model;
        params['os'] = "${androidInfo.version.sdkInt}";
        params['deviceId'] = "${ids["registerId"]}";
      }
      params['registerId'] = "$registerId";
      debugPrint("the params - $params");
      GlobalData.shared.registerId = "${ids["registerId"]}";
      await API.shared.foundation.pushDeviceSubmit(params);
    } catch (e) {}
  }

  Future<double> get brightness async =>
      (await _channel.invokeMethod('brightness')) as double;

  Future setBrightness(double brightness) =>
      _channel.invokeMethod('setBrightness', "$brightness");

  Future<bool> get isKeptOn async =>
      (await _channel.invokeMethod('isKeptOn')) as bool;

  Future keepOn(bool on) => _channel.invokeMethod('keepOn', "${on ? "1" : "0"}");

  Future fetchConfig(String configKey) => _channel.invokeMethod('getConfigValue', configKey);
}
