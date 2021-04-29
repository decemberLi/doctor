import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctor/http/foundation.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/recognize_entity.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_physician_qualification_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';

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

  _recognizeIdCard(Map<String, dynamic> param) async {
    var result = await API.shared.foundation.ocr(param);
    return RecognizeEntity.fromJson(result);
  }

  _queryPhysician() async {
    var result = await API.shared.ucenter.queryDoctorVerifyInfo();
    if (result is DioError) {
      return;
    }

    _model.physicianInfoEntity = DoctorPhysicianInfoEntity.fromJson(result);
    _model.physicianInfoEntity =
        _model.physicianInfoEntity ?? DoctorPhysicianInfoEntity.create();
  }

  setAvatar(String path) async {
    if (path == null) {
      _model?.physicianInfoEntity?.fullFacePhoto = null;
      notifyDataChange();
      return;
    }
    UploadFileEntity entity = await uploadImageToOss(path);
    if (_model.physicianInfoEntity.fullFacePhoto == null) {
      _model.physicianInfoEntity.fullFacePhoto = FacePhoto.create();
    }

    var facePhoto = _model.physicianInfoEntity.fullFacePhoto;
    facePhoto.url = null;
    notifyDataChange();
    facePhoto.url = entity.url;
    facePhoto.ossId = entity.ossId;
    facePhoto.name = entity.ossFileName;
  }

  setIdCardFaceSide(String path) async {
    if (path == null) {
      _model.physicianInfoEntity.identityNo = null;
      _model.physicianInfoEntity.identityName = null;
      _model.physicianInfoEntity.identitySex = null;
      _model.physicianInfoEntity.identityDate = null;
      _model.physicianInfoEntity.identityAddress = null;
      _model.physicianInfoEntity?.idCardLicense1 = null;
      notifyDataChange();
      return;
    }
    UploadFileEntity entity = await uploadImageToOss(path);

    // ocr
    Map<String, dynamic> param = {};
    // http://www.diqibu.com/ocrimg/demo/idcard/2.jpg
    param['imgUrl'] = entity.url;
    param['imgType'] = 'face';
    RecognizeEntity recognizeResult = await _recognizeIdCard(param);
    // 识别成功后再展示内容

    if ((recognizeResult != null && recognizeResult.frontResult != null) &&
        recognizeResult.frontResult.iDNumber != null &&
        recognizeResult.frontResult.iDNumber.length != 0) {
      if (_model.physicianInfoEntity.idCardLicense1 == null) {
        _model.physicianInfoEntity.idCardLicense1 = FacePhoto.create();
      }
      var idCardFace = _model.physicianInfoEntity.idCardLicense1;
      idCardFace.url = null;
      idCardFace.url = entity.url;
      idCardFace.ossId = entity.ossId;
      idCardFace.name = entity.ossFileName;
      notifyDataChange();

      var physicianInfo = _model.physicianInfoEntity;
      physicianInfo.identityNo = recognizeResult.frontResult.iDNumber;
      physicianInfo.identityName = recognizeResult.frontResult.name;
      physicianInfo.identitySex =
          recognizeResult.frontResult.gender == '男' ? 1 : 0;
      physicianInfo.identityDate = recognizeResult.frontResult.birthDate;
      physicianInfo.identityAddress = recognizeResult.frontResult.address;
      return;
    }
    EasyLoading.showToast('身份证识别失败，请重新上传身份证');
  }

  setIdCardBackgroundSide(String path) async {
    if (path == null) {
      _model.physicianInfoEntity.identityValidityStart = null;
      _model.physicianInfoEntity.identityValidityEnd = null;
      _model.physicianInfoEntity.idCardLicense2 = null;
      notifyDataChange();
      return;
    }
    UploadFileEntity entity = await uploadImageToOss(path);
    Map<String, dynamic> param = {};
    param['imgUrl'] = entity.url;
    param['imgType'] = 'back';
    RecognizeEntity recognizeResult = await _recognizeIdCard(param);
    // https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603620957283&di=61acea5fc966284c9bc389e8a752aba7&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20060810%2FImg244728941.jpg

    if (recognizeResult != null &&
        recognizeResult.backResult != null &&
        recognizeResult.backResult.startDate != null &&
        recognizeResult.backResult.startDate.length != 0 &&
        recognizeResult.backResult.endDate != null &&
        recognizeResult.backResult.endDate.length != 0) {
      // 识别成功后再展示内容
      if (_model.physicianInfoEntity.idCardLicense2 == null) {
        _model.physicianInfoEntity.idCardLicense2 = FacePhoto.create();
      }
      var idCardBackground = _model.physicianInfoEntity.idCardLicense2;
      idCardBackground.url = null;
      idCardBackground.url = entity.url;
      idCardBackground.ossId = entity.ossId;
      idCardBackground.name = entity.ossFileName;
      notifyDataChange();

      var physicianInfo = _model.physicianInfoEntity;
      physicianInfo.identityValidityStart =
          recognizeResult.backResult.startDate;
      physicianInfo.identityValidityEnd = recognizeResult.backResult.endDate;
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

  removeQualifications(int index) async {
    if (_model.physicianInfoEntity.qualifications == null) {
      _model.physicianInfoEntity.qualifications = [];
    }
    if (_model.physicianInfoEntity.qualifications.length > index) {
      _model.physicianInfoEntity.qualifications.removeAt(index);
      notifyDataChange();
    }
  }

  setPracticeCertificates(String path, FacePhoto toBeChange, int index) async {
    if (_model.physicianInfoEntity.practiceCertificates == null) {
      _model.physicianInfoEntity.practiceCertificates = [];
    }
    _processUploadImgLogic(_model.physicianInfoEntity.practiceCertificates,
        path, toBeChange, index);
  }

  removePracticeCertificates(int index) async {
    if (_model.physicianInfoEntity.practiceCertificates == null) {
      _model.physicianInfoEntity.practiceCertificates = [];
    }
    if (_model.physicianInfoEntity.practiceCertificates.length > index) {
      _model.physicianInfoEntity.practiceCertificates.removeAt(index);
      notifyDataChange();
    }
  }

  setJobCertificates(String path, FacePhoto toBeChange, int index) async {
    if (_model.physicianInfoEntity.jobCertificates == null) {
      _model.physicianInfoEntity.jobCertificates = [];
    }
    _processUploadImgLogic(
        _model.physicianInfoEntity.jobCertificates, path, toBeChange, index);
  }

  void setSignature(path) async {
    UploadFileEntity entity = await uploadImageToOss(path);
    _model.physicianInfoEntity.signature = FacePhoto.create();
    _model.physicianInfoEntity.signature.url = entity.url;
    _model.physicianInfoEntity.signature.name = entity.ossFileName;
    _model.physicianInfoEntity.signature.ossId = entity.ossId;
    notifyDataChange();
  }

  removeJobCertificates(int index) async {
    if (_model.physicianInfoEntity.jobCertificates == null) {
      _model.physicianInfoEntity.jobCertificates = [];
    }
    if (_model.physicianInfoEntity.jobCertificates.length > index) {
      _model.physicianInfoEntity.jobCertificates.removeAt(index);
      notifyDataChange();
    }
  }

  _processUploadImgLogic(List<FacePhoto> list, String path,
      FacePhoto toBeChange, int index) async {
    UploadFileEntity entity = await uploadImageToOss(path);
    // update
    FacePhoto toBeChange;
    if (index < list.length) {
      toBeChange = list[index];
    } else {
      toBeChange = FacePhoto.create();
      list.add(toBeChange);
    }
    toBeChange.ossId = entity.ossId;
    toBeChange.url = entity.url;
    toBeChange.name = entity.ossFileName;
    notifyDataChange();
  }

  submitData(BuildContext context) async {
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
    if (_model.physicianInfoEntity.practiceCertificates == null ||
        _model.physicianInfoEntity.practiceCertificates.length == 0) {
      EasyLoading.showToast('请上传医师执业证');
      return false;
    }
    if (_model.physicianInfoEntity.practiceCertificates == null ||
        _model.physicianInfoEntity.practiceCertificates.length < 2) {
      EasyLoading.showToast('医师执业证至少上传两张图');
      return false;
    }
    if (_model.physicianInfoEntity.qualifications == null ||
        _model.physicianInfoEntity.qualifications.length == 0) {
      EasyLoading.showToast('请上传医师资格证');
      return false;
    }
    if (_model.physicianInfoEntity.qualifications == null ||
        _model.physicianInfoEntity.qualifications.length < 2) {
      EasyLoading.showToast('医师资格证至少上传两张图');
      return false;
    }

    if (_model.physicianInfoEntity.jobCertificates == null ||
        _model.physicianInfoEntity.jobCertificates.length == 0) {
      EasyLoading.showToast('请上传专业技术资格证');
      return false;
    }
    if (_model.physicianInfoEntity.signature == null) {
      EasyLoading.showToast('请输入电子签名');
      return false;
    }

    EasyLoading.instance.flash(() async {
      await API.shared.ucenter
          .commitDoctorVerifyInfo(_model.physicianInfoEntity.toJson());
    },text: '正在提交');

    EasyLoading.showToast("提交成功");

    return true;
  }
}
