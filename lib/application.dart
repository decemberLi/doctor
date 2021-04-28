import 'dart:convert';

import 'package:doctor/http/host_provider.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_manager/manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/env/environment.dart';
import 'root_widget.dart';

mixin ApplicationInitializeConfigMixin {
  @protected
  AppEnvironment get env;
}

class ApplicationInitialize {
  static void initialize(ApplicationInitializeConfigMixin config) async {
    ApiHost.initHostByEnvironment(Environment.initEnv(config.env));
    Provider.debugCheckInvalidValueType = null;
    WidgetsFlutterBinding.ensureInitialized();
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await AppUtils.init();
    await SessionManager.shared.loadSession();
    dynamic version = await PlatformUtils.getAppVersion();
    var reference = await SharedPreferences.getInstance();
    var lastVerson = reference.getString('version');
    if (lastVerson == null || lastVerson != version) {
      reference.setString('version', version);
    }
    bool showGuide = lastVerson != version;
    MedcloudsNativeApi.instance().addProcessor("commonWeb", (args) {
      var parse = Uri.parse(args);
      if (parse == null) {
        return null;
      }
      var queryParameters = parse.queryParameters;
      print(queryParameters);
      print(queryParameters['ext']);
      var ext = queryParameters['ext'];
      var url = json.decode(ext)['url'];
      print('url -> $url');

      return MedcloudsNativeApi.instance().openWebPage(url);
    });
    runApp(RootWidget({'showGuide': showGuide}));
  }
}
