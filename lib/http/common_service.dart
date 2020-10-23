import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

HttpManager foundation = HttpManager('foundation');

/// 通用service
class CommonService {
  Dio dio = Dio();

  static Future getFile(params) async {
    var data = foundation.post('/ali-oss/tmp-url-batch',
        params: params, showLoading: false);
    return data;
  }

  // TODO: 临时方案
  uploadToOss(
    String host,
    String file,
    String key,
    String oSSAccessKeyId,
    String signature,
    String policy, {
    Map<String, dynamic> param,
    String loadingText = '加载中...',
  }) async {
    EasyLoading.show(status: loadingText);
    Map<String, dynamic> param = {};
    param['key'] = key;
    param['OSSAccessKeyId'] = oSSAccessKeyId;
    param['policy'] = policy;
    param['Signature'] = signature;
    param['file'] = File(file);
    var response = await dio.post(host, data: FormData.fromMap(param));
    print(response);
  }

  uploadImage({
    String accessKeyId,
    String policy,
    String fileName,
    String signature,
  }) {}
}
