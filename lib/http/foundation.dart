import 'package:http_manager/manager.dart';
import 'host.dart';

extension founAPI on API {
  Foundation get foundation => Foundation();
}

class Foundation extends SubAPI {
  String get middle =>
      "/medclouds-foundation/${API.shared.defaultClient}";

  /// 反馈信息
  getFeedbackInfo(params) {
    print('调用接口$params');
    return normalPost(
      '/feedback-config/random-list',
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
}
