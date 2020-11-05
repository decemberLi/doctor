import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/oss_policy.dart';
import 'package:doctor/pages/qualification/model/doctor_physician_qualification_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

HttpManager uCenter = HttpManager('ucenter');
HttpManager uCenterCommon = HttpManager('uCenterCommon');
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

  refresh() async {
    await _queryPhysician();
    notifyDataChange();
  }

  notifyDataChange() {
    _controller.sink.add(_model);
  }

  _querySignature() async {
    var result = await foundation.post('/ali-oss/policy');
    return OssPolicy.fromJson(result);
  }

  _saveImage(Map<String, dynamic> param) async {
    var result = await foundation.post('/ali-oss/save', params: param);
    return UploadFileEntity.fromJson(result);
  }

  _recognizeIdCard(Map<String, dynamic> param) async {
    var result = await uCenterCommon.post(
        '/medclouds-ucenter/mobile/idcardOcr/picture-recognition',
        params: param);
    return result;
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

  setAvatar(String path) async {
    if (_model.physicianInfoEntity.fullFacePhoto == null) {
      _model.physicianInfoEntity.fullFacePhoto = FacePhoto.create();
    }
    var facePhoto = _model.physicianInfoEntity.fullFacePhoto;
    facePhoto.path = path;
    facePhoto.url = null;
    notifyDataChange();
    UploadFileEntity entity = await uploadImageToOss(path);
    facePhoto.url = entity.url;
    facePhoto.ossId = entity.ossId;
    facePhoto.name = entity.ossFileName;
  }

  setIdCardFaceSide(String path) async {
    if (_model.physicianInfoEntity.idCardLicense1 == null) {
      _model.physicianInfoEntity.idCardLicense1 = FacePhoto.create();
    }
    var idCardFace = _model.physicianInfoEntity.idCardLicense1;
    UploadFileEntity entity = await uploadImageToOss(path);

    // ocr
    Map<String, dynamic> param = {};
    // http://www.diqibu.com/ocrimg/demo/idcard/2.jpg
    param['imgUrl'] = entity.url;
    param['imgType'] = 'face';
    var result = await _recognizeIdCard(param);
    // 识别成功后再展示内容
    idCardFace.path = path;
    idCardFace.url = null;
    idCardFace.url = entity.url;
    idCardFace.ossId = entity.ossId;
    idCardFace.name = entity.ossFileName;

    print('-------- $result');
    var resultJson = json.decode(result);
    if (resultJson is Map<String, dynamic>) {
      var physicianInfo = _model.physicianInfoEntity;
      physicianInfo.identityNo = '${resultJson['num']}';
      physicianInfo.identityName = '${resultJson['name']}';
      physicianInfo.identitySex = resultJson['sex'] == '男' ? 1 : 0;
      physicianInfo.identityDate = resultJson['birth'];
      physicianInfo.identityAddress = '${resultJson['address']}';
      return;
    }
    EasyLoading.showToast('身份证识别失败，请重新上传身份证');
  }

  setIdCardBackgroundSide(String path) async {
    //C19B79335322E659697E90E4E7B96688
    if (_model.physicianInfoEntity.idCardLicense2 == null) {
      _model.physicianInfoEntity.idCardLicense2 = FacePhoto.create();
    }
    var idCardBackground = _model.physicianInfoEntity.idCardLicense2;
    UploadFileEntity entity = await uploadImageToOss(path);
    Map<String, dynamic> param = {};
    param['imgUrl'] = entity.url;
    param['imgType'] = 'back';
    var result = await _recognizeIdCard(param);
    // 识别成功后再展示内容
    idCardBackground.path = path;
    idCardBackground.url = null;
    idCardBackground.url = entity.url;
    idCardBackground.ossId = entity.ossId;
    idCardBackground.name = entity.ossFileName;

    // https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603620957283&di=61acea5fc966284c9bc389e8a752aba7&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20060810%2FImg244728941.jpg

    var resultJson = json.decode(result);
    if (resultJson is Map<String, dynamic>) {
      var physicianInfo = _model.physicianInfoEntity;
      physicianInfo.identityValidity = resultJson['end_date'];
      return;
    }

    EasyLoading.showToast('身份证识别失败，请重新上传身份证');
  }

  setQualifications(String path, FacePhoto toBeChange, int index) async {
    if (_model.physicianInfoEntity.qualifications == null) {
      _model.physicianInfoEntity.qualifications = [];
    }

    _processUploadImgLogic(
        _model.physicianInfoEntity.qualifications, path, toBeChange, index);
  }

  setPracticeCertificates(String path, FacePhoto toBeChange, int index) async {
    if (_model.physicianInfoEntity.practiceCertificates == null) {
      _model.physicianInfoEntity.practiceCertificates = [];
    }
    _processUploadImgLogic(_model.physicianInfoEntity.practiceCertificates,
        path, toBeChange, index);
  }

  setJobCertificatess(String path, FacePhoto toBeChange, int index) async {
    if (_model.physicianInfoEntity.jobCertificates == null) {
      _model.physicianInfoEntity.jobCertificates = [];
    }
    _processUploadImgLogic(
        _model.physicianInfoEntity.jobCertificates, path, toBeChange, index);
  }

  _processUploadImgLogic(List<FacePhoto> list, String path,
      FacePhoto toBeChange, int index) async {
    // update
    FacePhoto toBeChange;
    if (index < list.length) {
      toBeChange = list[index];
    } else {
      toBeChange = FacePhoto.create();
      list.add(toBeChange);
    }

    toBeChange.path = path;
    toBeChange.url = null;
    notifyDataChange();
    UploadFileEntity entity = await uploadImageToOss(path);
    toBeChange.ossId = entity.ossId;
    toBeChange.url = entity.url;
    toBeChange.name = entity.ossFileName;
  }

  submitData() async {
    if (_model.physicianInfoEntity == null ||
        _model.physicianInfoEntity.fullFacePhoto == null) {
      EasyLoading.showToast('请上传头像');
      return false;
    }
    if (_model.physicianInfoEntity.idCardLicense1 == null ||
        _model.physicianInfoEntity.idCardLicense2 == null) {
      EasyLoading.showToast('请上传身份证');
      return false;
    }
    if (_model.physicianInfoEntity.qualifications == null ||
        _model.physicianInfoEntity.qualifications.length < 2) {
      EasyLoading.showToast('医师资格证至少上传两张图');
      return false;
    }
    if (_model.physicianInfoEntity.practiceCertificates == null ||
        _model.physicianInfoEntity.practiceCertificates.length < 2) {
      EasyLoading.showToast('医师执业证至少上传两张图');
      return false;
    }
    if (_model.physicianInfoEntity.jobCertificates == null ||
        _model.physicianInfoEntity.jobCertificates.length < 2) {
      EasyLoading.showToast('医师职称证至少上传两张图');
      return false;
    }

    await uCenter.post('/personal/commit-doctor-verify-info',
        params: _model.physicianInfoEntity.toJson());

    return true;
  }
}
