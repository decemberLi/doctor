import 'package:dio/dio.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/model/oss_policy.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';

/// 上传服务
class OssService {
  static final OssService _instance = OssService._internal();

  factory OssService() => _instance;

  static Future<OssFileEntity> upload(
    path, {
    bool showLoading = true,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    return await _instance._upload(
      path,
      showLoading: showLoading,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future getFile(params) async {
    var data = API.shared.foundation.aliTmpURLBatch(params);
    return data;
  }

  OssPolicy _policy;

  Dio _dio = Dio();

  OssService._internal() {
    // _querySignature();
  }

  _querySignature() async {
    var result = await API.shared.foundation.aliossPolicy();
    _policy = OssPolicy.fromJson(result);
  }

  Future<OssFileEntity> _upload(
    String path, {
    String loadingText = '上传中...',
    bool showLoading = true,
    bool publicRead = false,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    await _querySignature();
    String originName = path.substring(path.lastIndexOf('/') + 1, path.length);
    String suffix = path.substring(path.lastIndexOf('.') + 1, path.length);
    var postFileName =
        '${originName.hashCode}${DateTime.now().millisecondsSinceEpoch}.$suffix';

    String ossFileName = '${_policy.fileNamePrefix}$postFileName';
    if (showLoading) {
      EasyLoading.show(status: loadingText);
    }

    await _uploadToOss(
      path,
      originName,
      ossFileName,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    Map<String, dynamic> param = {
      'ossFileName': ossFileName,
      'attachName': postFileName,
      'publicRead': publicRead,
      'type': suffix,
    };
    OssFileEntity entity = await _saveFile(param);
    entity.type = suffix;
    entity.name = originName;
    if (showLoading) {
      EasyLoading.dismiss();
    }

    return entity;
  }

  _uploadToOss(
    String file,
    String fileName,
    String key, {
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var formData = FormData.fromMap({
      'key': key,
      'OSSAccessKeyId': _policy.accessKeyId,
      'policy': _policy.policy,
      'Signature': _policy.signature,
      'file': await MultipartFile.fromFile(file, filename: fileName),
    });

    print("YYYLog::UploadFile request --> $formData");
    var response = await _dio.post(
      _policy.host,
      data: formData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    print("YYYLog::UploadFile response <-- $formData");
    if (response.statusCode == 204) {
      return;
    }
    EasyLoading.dismiss();
    throw Error();
  }

  _saveFile(Map<String, dynamic> param) async {
    var result = await API.shared.foundation.aliossSave(param);
    return OssFileEntity.fromJson(result);
  }

  static uploadBatchToOss(List<String> filePath) async {
    List<Future<OssFileEntity>> futires = [];
    List<dynamic> urlList = [];
    for (int i = 0; i < filePath.length; i++) {
      var eachF = upload(filePath[i], showLoading: false);
      futires.add(eachF);
      eachF.then((value) => urlList.add(value.toJson()));
      if (futires.length == 4) {
        await Future.wait(futires);
        futires.clear();
      }
    }
    await Future.wait(futires);
    return urlList;
  }
}
