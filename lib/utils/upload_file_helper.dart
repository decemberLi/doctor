import 'package:doctor/http/common_service.dart';
import 'package:doctor/model/oss_policy.dart';
import 'package:doctor/model/uploaded_file_entity.dart';

/// 临时方案
///

_querySignature() async {
  var result = await foundation.post('/ali-oss/policy');
  return OssPolicy.fromJson(result);
}

_saveImage(Map<String, dynamic> param) async {
  var result = await foundation.post('/ali-oss/save', params: param);
  return UploadFileEntity.fromJson(result);
}

uploadImageToOss(String path) async {
  OssPolicy policy = await _querySignature();

  String originName = path.substring(path.lastIndexOf('/') + 1, path.length);
  String suffix = path.substring(path.lastIndexOf('.') + 1, path.length);

  var ossFileName = '${policy.fileNamePrefix}$originName';
  await CommonService().uploadToOss(policy.host, path, originName, ossFileName,
      policy.accessKeyId, policy.signature, policy.policy);
  Map<String, dynamic> param = {
    'ossFileName': ossFileName,
    'attachName': originName,
    'publicRead': false,
    'type': suffix,
  };
  UploadFileEntity entity = await _saveImage(param);
  entity.ossFileName = ossFileName;
  return entity;
}
