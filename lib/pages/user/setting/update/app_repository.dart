import 'package:doctor/http/http_manager.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';

import 'app_update_info.dart';

/// App相关接口
class AppRepository {
  static HttpManager foundation = HttpManager('foundationClient');
  static HttpManager developer = HttpManager('developer');

  static Future<AppUpdateInfo> checkUpdate() async {
    var response = await foundation.post('/app-upgrade/check', params: {
      'appType': 'DOCTOR',
      'appVersoin': await PlatformUtils.getAppVersion(),
      'platform': Platform.isAndroid ? 'ANDROID' : 'IOS'
    }, showLoading: false);
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
