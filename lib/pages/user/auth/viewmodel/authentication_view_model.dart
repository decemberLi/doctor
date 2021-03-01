import 'package:common_utils/common_utils.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../entity/authentication_basic_info.dart';

class AuthenticationViewModel extends ViewStateModel {
  AuthenticationBasicInfoEntity _entity = new AuthenticationBasicInfoEntity();

  var _showIdCardInfo = false;
  var _canNext = false;

  bool get needShowIdCardInfo => _showIdCardInfo;

  AuthenticationBasicInfoEntity get data => _entity;

  bool get canNext => _canNext;

  // 身份证反面
  setIdCardFaceSide(imgPath) {
    // 上传图片到阿里云 OSS

    // 获取识别的结果, 赋值到数据实体中

    checkDataIntegrity();
    notifyListeners();
  }

  // 身份证背面
  setIdCardBackgroundSide(imgPath) {
    // 上传图片到阿里云 OSS

    // 获取识别的结果, 赋值到数据实体中

    checkDataIntegrity();
    notifyListeners();
  }

  // 银行卡
  setBankImage(imgPath) {
    // 上传图片到阿里云 OSS

    // 获取识别的结果, 赋值到数据实体中

    checkDataIntegrity();
    notifyListeners();
  }

  // 设置银行卡号
  setBankCard(String val) {
    print("setBankCard ---------> $val}");
    _entity.bankCard = val;
    checkDataIntegrity();
    notifyListeners();
  }

  // 设置签约号码
  setSignaturePhoneNumber(String val) {
    print("setSignaturePhoneNumber ---------> $val}");
    _entity.bankSignMobile = val;
    checkDataIntegrity();
    notifyListeners();
  }

  commitAuthenticationData() {
    print("commitAuthenticationData");
  }

  checkDataIntegrity() {
    _canNext = false;
    if (TextUtil.isEmpty(data.identityNo)) {
      return;
    }
    if (TextUtil.isEmpty(data.identityName)) {
      return;
    }
    if (TextUtil.isEmpty(data.bankSignMobile) ||
        data.bankSignMobile.length < 11) {
      EasyLoading.showToast("请输入正确的手机号");
      return;
    }
    if (TextUtil.isEmpty(data.bankCard) || data.bankSignMobile.length < 20) {
      EasyLoading.showToast("请输入正确的手机号");
      return;
    }

    _canNext = true;
  }
}
