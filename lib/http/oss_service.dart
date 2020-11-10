import 'package:dio/dio.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/model/oss_policy.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 上传服务
class OssService {
  static final OssService _instance = OssService._internal();
  factory OssService() => _instance;

  static Future<OssFileEntity> upload(path) async {
    return await _instance._upload(path);
  }

  static Future getFile(params) async {
    var data = _instance._foundation
        .post('/ali-oss/tmp-url-batch', params: params, showLoading: false);
    return data;
  }

  OssPolicy _policy;

  Dio _dio = Dio();

  HttpManager _foundation = HttpManager('foundation');

  OssService._internal() {
    // _querySignature();
  }

  _querySignature() async {
    var result = await _foundation.post('/ali-oss/policy');
    _policy = OssPolicy.fromJson(result);
  }

  Future<OssFileEntity> _upload(
    String path, {
    String loadingText = '上传中...',
    bool publicRead = false,
  }) async {
    await _querySignature();
    String originName = path.substring(path.lastIndexOf('/') + 1, path.length);
    String suffix = path.substring(path.lastIndexOf('.') + 1, path.length);

    String ossFileName = '${_policy.fileNamePrefix}$originName';
    EasyLoading.show(status: loadingText);
    await _uploadToOss(path, originName, ossFileName);
    Map<String, dynamic> param = {
      'ossFileName': ossFileName,
      'attachName': originName,
      'publicRead': publicRead,
      'type': suffix,
    };
    OssFileEntity entity = await _saveFile(param);
    entity.type = suffix;
    entity.name = originName;
    EasyLoading.dismiss();
    return entity;
  }

  _uploadToOss(String file, String fileName, String key) async {
    var formData = FormData.fromMap({
      'key': key,
      'OSSAccessKeyId': _policy.accessKeyId,
      'policy': _policy.policy,
      'Signature': _policy.signature,
      'file': await MultipartFile.fromFile(file, filename: fileName),
    });

    print("YYYLog::UploadFile request --> $formData");
    var response = await _dio.post(_policy.host, data: formData);
    print("YYYLog::UploadFile response <-- $formData");
    if (response.statusCode == 204) {
      return;
    }
    EasyLoading.dismiss();
    throw Error();
  }

  _saveFile(Map<String, dynamic> param) async {
    var result = await _foundation.post('/ali-oss/save', params: param);
    return OssFileEntity.fromJson(result);
  }
}
