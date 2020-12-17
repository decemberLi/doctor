import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/http/foundation.dart';
import 'package:http_manager/manager.dart';

/// 通用service
class CommonService {
  Dio dio = Dio();

  static Future getFile(params) async {
    var data = API.shared.foundation.aliTmpURLBatch(params);
    return data;
  }

  // TODO: 临时方案
  uploadToOss(
    String host,
    String file,
    String fileName,
    String key,
    String oSSAccessKeyId,
    String signature,
    String policy, {
    Map<String, dynamic> param,
    String loadingText = '加载中...',
  }) async {

    var formData = FormData.fromMap({
      'key': key,
      'OSSAccessKeyId': oSSAccessKeyId,
      'policy': policy,
      'Signature': signature,
      'file': await MultipartFile.fromFile(file, filename: fileName),
    });

    print("YYYLog::UploadFile request --> ${formData}");
    var response = await dio.post(host, data: formData);
    print("YYYLog::UploadFile response <-- ${formData}");
    if (response.statusCode == 204) {
      return;
    }

    throw Error();
  }

  uploadImage({
    String accessKeyId,
    String policy,
    String fileName,
    String signature,
  }) {}
}
