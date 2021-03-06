import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:doctor/http/developer.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

import '../entity/auth_basic_info.dart';

class AuthenticationViewModel extends ViewStateModel {
  AuthBasicInfoEntity _entity = new AuthBasicInfoEntity();

  var _showIdCardInfo = false;
  var _canNext = false;
  bool _agree = false;
  var _customerServicePhone = '13198064238';
  var _isCommitting = false;
  var _isScanBankCard = false;
  var _isBankCardEnable = true;
  var _isMobileEnable = true;
  var _isIdCardCanModified = true;

  bool get needShowIdCardInfo => _showIdCardInfo;

  AuthBasicInfoEntity get data => _entity;

  bool get canNext => _canNext;

  bool get agree => _agree;

  bool get isCommitting => _isCommitting;

  String get customServicePhone => _customerServicePhone;

  bool get isScanBankCard => _isScanBankCard;

  get isMobileEnable => _isMobileEnable;

  get isScanBankCardEnable => _isBankCardEnable;

  bool get isIdCardCanModified => _isIdCardCanModified;

  void setIsScanBankCard(bool value) {
    _isScanBankCard = value;
  }

  void changeAgreeState(bool value) {
    _agree = value;
    checkDataIntegrity();
    notifyListeners();
  }

  void initData() async {
    try {
      var data = await API.shared.developer.customServicePhone();
      var records = data["records"] as List;
      var item = records[0];
      var phone = item["value"];
      if (TextUtil.isEmpty(phone)) {
        return;
      }
      _customerServicePhone = phone;
    } catch (e) {
      debugPrint(e);
    }
  }

  // ???????????????
  setIdCardFaceSide(imgPath) {
    // ???????????????????????? OSS
    // ?????????????????????, ????????????????????????
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

  // ???????????????
  setIdCardBackgroundSide(imgPath) {
    // ?????????????????????, ????????????????????????
    _entity
      ..identityValidityStart = null
      ..idCardLicenseBehind = null;
    checkDataIntegrity();
    notifyListeners();
  }

  // ??????????????????
  setBankCard(String val) {
    debugPrint("setBankCard ---------> $val}");
    _entity.bankCard = val;
    checkDataIntegrity();
    _isScanBankCard = false;
    notifyListeners();
  }

  // ??????????????????
  setSignaturePhoneNumber(String val) {
    debugPrint("setSignaturePhoneNumber ---------> $val}");
    _entity.bankSignMobile = val;
    checkDataIntegrity();
    notifyListeners();
  }

  Future commitAuthenticationData() async {
    _isCommitting = true;
    debugPrint("commitAuthenticationData");
    var completer = Completer();
    if (checkDataIntegrity()) {
      EasyLoading.instance.flash(() async {
        await API.shared.ucenter.postDoctorIdentityInfo(data.toJson()).then(
          (value) {
            _isCommitting = false;
            debugPrint("$value");
            completer.complete(value);
          },
          onError: (error, msg) {
            _isCommitting = false;
            debugPrint("errorCode: $error");
            completer.completeError(error);
          },
        );
      });
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
    if (!TextUtil.isEmpty(data.bankSignMobile) &&
        data.bankSignMobile.length != 11) {
      if (needToast) {
        EasyLoading.showToast("???????????????????????????");
      }
      return false;
    }
    if (TextUtil.isEmpty(data.bankCard)) {
      if (needToast) {
        EasyLoading.showToast("??????????????????????????????");
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
    // 1?????????
    var json = jsonDecode(args);
    // 2???????????????
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload bank card success");
    // 3?????????????????????
    _entity
      ..bankCard = json['CardNo']
      ..bankCardCertificates = img;
    _isScanBankCard = true;
    checkDataIntegrity();
    notifyListeners();
  }

  void processIdCardFaceSideResult(String args) async {
    debugPrint("processIdCardFaceSideResult ---> $args");
    // 1?????????
    var json = jsonDecode(args);
    // 2???????????????
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload id card face side success");
    // 3?????????????????????
    _entity
      ..identityName = json['Name']
      ..identityNo = json['IdNum']
      ..identityDate = json['Birth']
      ..identitySex = json['Sex'] == '???' ? 1 : 0
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
    // 1?????????
    var json = jsonDecode(args);
    // 2???????????????
    FacePhoto img = await _uploadImg(json['imgPath']);
    debugPrint("Upload id card back side success");
    // 3?????????????????????
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

  refreshData(
    TextEditingController phoneController,
    TextEditingController bankCardController,
  ) async {
    var result = await API.shared.ucenter.queryDoctorVerifyInfo();
    if (result is DioError) {
      return;
    }
    _entity = AuthBasicInfoEntity.fromJson(result);
    if (_entity.idCardLicenseFront != null) {
      _isIdCardCanModified = false;
      _showIdCardInfo = true;
    }
    if (!TextUtil.isEmpty(_entity.bankCard)) {
      _isScanBankCard = true;
      _isBankCardEnable = false;
    }
    if(!TextUtil.isEmpty(_entity.bankSignMobile)) {
      _isMobileEnable = false;
      phoneController.text = _entity.bankSignMobile ?? '';
    }
    checkDataIntegrity();
    notifyListeners();
  }

  void setChannel(String channel) {
    if(!TextUtil.isEmpty(_entity.channel)){
      return;
    }
    // ????????????
    _entity.channel = channel;
  }
}
