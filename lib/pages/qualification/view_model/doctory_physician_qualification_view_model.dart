import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/model/oss_policy.dart';
import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:doctor/pages/qualification/model/doctor_physician_qualification_entity.dart';
import 'package:doctor/model/face_photo.dart';

HttpManager uCenter = HttpManager('ucenter');
HttpManager foundation = HttpManager('foundation');

class DoctorPhysicianQualificationViewModel {
  StreamController<DoctorQualificationModel> _controller =
      StreamController<DoctorQualificationModel>();
  var _model = DoctorQualificationModel();

  get stream => _controller.stream;

  dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  refresh() {
    _queryPhysician();
    notifyDataChange();
  }

  notifyDataChange() {
    _controller.sink.add(_model);
  }

  _querySignature() async {
    var result = await foundation.post('/ali-oss/policy');
    return OssPolicy.fromJson(result);
  }

  _queryPhysician() async {
    var result = await uCenter.post('/personal/query-doctor-verify-info');
    if (result is DioError) {
      return;
    }

    _model.physicianInfoEntity = DoctorPhysicianInfoEntity.fromJson(result);
    _model.physicianInfoEntity =
        _model.physicianInfoEntity ?? DoctorPhysicianInfoEntity.create();
  }

  _uploadImageToOss(String path) async {
    OssPolicy policy = await _querySignature();
    var ossFileName =
        '${policy.ossFileName}${path.substring(path.lastIndexOf('/') + 1, path.length)}';
    await CommonService().uploadToOss(policy.host, path, ossFileName,
        policy.accessKeyId, policy.signature, policy.policy);
  }

  // TODO 上传失败处理
  void setAvatar(String path) async{
    if (_model.physicianInfoEntity.fullFacePhoto == null) {
      _model.physicianInfoEntity.fullFacePhoto = FacePhoto.create();
    }
    var facePhoto = _model.physicianInfoEntity.fullFacePhoto;
    facePhoto.path = path;
    facePhoto.url = null;
    notifyDataChange();
    await _uploadImageToOss(path);

  }

  void setIdCardFaceSide(String path) {
    if (_model.physicianInfoEntity.idCardLicense1 == null) {
      _model.physicianInfoEntity.idCardLicense1 = FacePhoto.create();
    }
    var idCardFace = _model.physicianInfoEntity.idCardLicense1;
    idCardFace.path = path;
    idCardFace.url = null;
  }

  void setIdCardBackgroundSide(String path) {
    //C19B79335322E659697E90E4E7B96688
    if (_model.physicianInfoEntity.idCardLicense2 == null) {
      _model.physicianInfoEntity.idCardLicense2 = FacePhoto.create();
    }
    var idCardBackground = _model.physicianInfoEntity.idCardLicense2;
    idCardBackground.path = path;
    idCardBackground.url = null;
  }
}
