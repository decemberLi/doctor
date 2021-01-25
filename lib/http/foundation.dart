import 'package:doctor/http/host_provider.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:http_manager/manager.dart';
import 'host.dart';

extension founAPI on API {
  Foundation get foundation => Foundation();
}

class Foundation extends SubAPI {
  String get middle => "/medclouds-foundation/${API.shared.defaultClient}";

  /// 反馈信息
  getFeedbackInfo(params) {
    print('调用接口$params');
    return normalPost(
      '/feedback-config/random-feedback-list',
      params: params,
    );
  }

  /// 获取绑定二维码
  Future<String> loadBindQRCode(String prescriptionNo) async {
    try {
      var res = await normalPost(
        '/wechat-accounts/temp-qr-code',
        params: {
          'bizType': 'PRESCRIPTION_BIND',
          'bizId': prescriptionNo,
        },
      );
      return res['qrCodeUrl'];
    } catch (e) {
      return null;
    }
  }

  /// 检查更新
  appUpgradeCheck() async => await normalPost(
        "/app-upgrade/check",
        params: {
          'appType': 'DOCTOR',
          'appVersoin': await PlatformUtils.getAppVersion(),
          'platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
        },
      );

  /// 下拉基础信息
  getSelectInfo(params) {
    return normalPost('/pull-down-config/list', params: params);
  }

  aliossPolicy() async => normalPost(
        "/ali-oss/policy",
      );

  aliossSave(params) async => normalPost("/ali-oss/save", params: params);

  aliTmpURLBatch(params) async =>
      normalPost("/ali-oss/tmp-url-batch", params: params);

  ocr(params) async =>
      normalPost("/ocr/recognize-identity-card", params: params);

  hospitalKeyQueryPage(params) async =>
      normalPost("/hospital/key-query-page", params: params);

  sendSMS(params) async => normalPost('/sms/send-captcha', params: params);
  pushDeviceSubmit(params) async => normalPost('mobile/push-device/submit',params: params);
  pushDeviceLoginSubmit(params) async => normalPost('mobile/push-device/login-submit',params: params);
  pushDeviceDel(params) async => normalPost('mobile/push-device/del',params: params);
}
