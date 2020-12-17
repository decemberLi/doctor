import 'package:doctor/http/servers.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'root_widget.dart';

mixin ApplicationInitializeConfigMixin {
  @protected
  AppEnvironment get env;
}

class ApplicationInitialize {

  static void initialize(ApplicationInitializeConfigMixin config) async {
    ApiHost.initHostByEnvironment(config.env);
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
    runApp(RootWidget({'showGuide': showGuide}));
  }
}
