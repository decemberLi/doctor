import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:http_manager/api.dart';

import '../entity/auth_basic_info.dart';

class AuthenticationViewModel extends ViewStateModel {
  AuthBasicInfoEntity _entity = new AuthBasicInfoEntity();

  var _showIdCardInfo = false;
  var _canNext = false;
  bool _agree = false;

  bool get needShowIdCardInfo => _showIdCardInfo;

  AuthBasicInfoEntity get data => _entity;

  bool get canNext => _canNext;

  bool get agree => _agree;

  void changeAgreeState(bool value) {
    _agree = value;
    checkDataIntegrity();
    notifyListeners();
  }

  // 身份证反面
  setIdCardFaceSide(imgPath) {
    // 上传图片到阿里云 OSS
    // 获取识别的结果, 赋值到数据实体中
    _entity.idCardLicenseFront = null;
    _entity
      ..identityName = null
      ..identityNo = null
      ..identityDate = null
      ..identitySex = 0
      ..identityAddress = null
      ..idCardLicenseFront = null;
    _showIdCardInfo = false;
    checkDataIntegrity();
    notifyListeners();
  }

  // 身份证背面
  setIdCardBackgroundSide(imgPath) {
    // 获取识别的结果, 赋值到数据实体中
    _entity
      ..identityValidityStart = null
      ..idCardLicenseBehind = null;
    checkDataIntegrity();
    notifyListeners();
  }

  // 设置银行卡号
  setBankCard(String val) {
    debugPrint("setBankCard ---------> $val}");
    _entity.bankCard = val;
    checkDataIntegrity();
    notifyListeners();
  }

  // 设置签约号码
  setSignaturePhoneNumber(String val) {
    debugPrint("setSignaturePhoneNumber ---------> $val}");
    _entity.bankSignMobile = val;
    checkDataIntegrity();
    notifyListeners();
  }

  Future commitAuthenticationData() async {
    debugPrint("commitAuthenticationData");
    var completer = Completer();
    if (checkDataIntegrity()) {
      await API.shared.ucenter.postDoctorIdentityInfo(data.toJson()).then(
        (value) {
          debugPrint(value);
          completer.complete(true);
        },
        onError: (error, msg) {
          debugPrint("errorCode: $error");
          completer.completeError(error);
        },
      );
    }

    return completer.future;
  }

  checkDataIntegrity({bool needToast = false}) {
    _canNext = false;
    if (TextUtil.isEmpty(data.identityNo)) {
      return false;
    }
    if (TextUtil.isEmpty(data.identityName)) {
      return false;
    }
    if (data.idCardLicenseBehind == null) {
      return false;
    }
    if (TextUtil.isEmpty(data.bankSignMobile)) {
      if (needToast) {
        EasyLoading.showToast("请输入正确的手机号");
      }
      return false;
    }
    if (TextUtil.isEmpty(data.bankCard)) {
      if (needToast) {
        EasyLoading.showToast("请输入正确的银行卡号");
      }
      return false;
    }
    if (!_agree) {
      return false;
    }
    _canNext = true;
    return true;
  }

  void processBankCardResult(String args) async {
    debugPrint("processBankCardResult ---> $args");
    // 1、解析
    var json = jsonDecode(args);
    // 2、上传图片
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload bank card success");
    // 3、本地保存数据
    _entity
      ..bankCard = json['CardNo']
      ..bankCardCertificates = img;
    checkDataIntegrity();
    notifyListeners();
  }

  void processIdCardFaceSideResult(String args) async {
    debugPrint("processIdCardFaceSideResult ---> $args");
    // 1、解析
    var json = jsonDecode(args);
    // 2、上传图片
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload id card face side success");
    // 3、本地保存数据
    _entity
      ..identityName = json['Name']
      ..identityNo = json['IdNum']
      ..identityDate = json['Birth']
      ..identitySex = json['Sex'] == '男' ? 1 : 0
      ..identityAddress = json['Address']
      ..idCardLicenseFront = img;
    _showIdCardInfo = true;
    checkDataIntegrity();
    notifyListeners();
  }

  void processIdCardBackSideResult(String args) async {
    debugPrint("processIdCardBackSideResult ---> $args");
    if (args == null) {
      return;
    }
    // 1、解析
    var json = jsonDecode(args);
    // 2、上传图片
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload id card back side success");
    // 3、本地保存数据
    String endDate = json['ValidDate'];
    var split = endDate.split('-');
    _entity
      ..identityValidityStart = split[0]
      ..identityValidityEnd = split[1]
      ..idCardLicenseBehind = img;
    checkDataIntegrity();
    notifyListeners();
  }

  Future<FacePhoto> _uploadImg(path) async {
    UploadFileEntity entity = await uploadImageToOss(path);
    FacePhoto img = FacePhoto.create();
    img.url = entity.url;
    img.name = entity.ossFileName;
    img.ossId = entity.ossId;
    return img;
  }
}
