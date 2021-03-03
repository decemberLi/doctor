import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../entity/auth_basic_info.dart';

class AuthenticationViewModel extends ViewStateModel {
  AuthBasicInfoEntity _entity = new AuthBasicInfoEntity();

  var _showIdCardInfo = false;
  var _canNext = false;

  bool get needShowIdCardInfo => _showIdCardInfo;

  AuthBasicInfoEntity get data => _entity;

  bool get canNext => _canNext;

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
    checkDataIntegrity(needToast: false);
    notifyListeners();
  }

  // 身份证背面
  setIdCardBackgroundSide(imgPath) {
    // 获取识别的结果, 赋值到数据实体中
    _entity
      ..identityValidityStart = null
      ..idCardLicenseBehind = null;
    checkDataIntegrity(needToast: false);
    notifyListeners();
  }

  // 设置银行卡号
  setBankCard(String val) {
    print("setBankCard ---------> $val}");
    _entity.bankCard = val;
    checkDataIntegrity(needToast: false);
    notifyListeners();
  }

  // 设置签约号码
  setSignaturePhoneNumber(String val) {
    print("setSignaturePhoneNumber ---------> $val}");
    _entity.bankSignMobile = val;
    checkDataIntegrity(needToast: false);
    notifyListeners();
  }

  commitAuthenticationData() {
    print("commitAuthenticationData");
    checkDataIntegrity(needToast: true);
  }

  checkDataIntegrity({bool needToast = false}) {
    _canNext = false;
    if (TextUtil.isEmpty(data.identityNo)) {
      return;
    }
    if (TextUtil.isEmpty(data.identityName)) {
      return;
    }
    if(data.idCardLicenseBehind == null){
      return;
    }
    if (TextUtil.isEmpty(data.bankSignMobile)) {
      if(needToast ) {
        EasyLoading.showToast("请输入正确的手机号");
      }
      return;
    }
    if (TextUtil.isEmpty(data.bankCard)) {
      if(needToast) {
        EasyLoading.showToast("请输入正确的银行卡号");
      }
      return;
    }
    _canNext = true;
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
      ..identityValidityStart = json['CardNo']
      ..idCardLicenseBehind = img;
    checkDataIntegrity(needToast: false);
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
    checkDataIntegrity(needToast: false);
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
    _entity
      ..identityValidityStart = json['Authority']
      ..identityValidityEnd = json['ValidDate']
      ..idCardLicenseBehind = img;
    checkDataIntegrity(needToast: false);
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
