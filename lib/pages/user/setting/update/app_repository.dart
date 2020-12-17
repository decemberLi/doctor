import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';

import 'app_update_info.dart';
import 'package:doctor/http/foundation.dart';
import 'package:http_manager/manager.dart';

/// App相关接口
class AppRepository {

  static Future<AppUpdateInfo> checkUpdate() async {
    var response = await API.shared.foundation.appUpgradeCheck();
    if(response == null || response.length == 0){
      print('无升级版本');
      return null;
    }

    var result = AppUpdateInfo.fromJson(response);
    if (result.appVersion != await PlatformUtils.getAppVersion()) {
      debugPrint('发现新版本===>${result.appVersion}');
      return result;
    }
    debugPrint('没有发现新版本');
    return null;
  }

}
