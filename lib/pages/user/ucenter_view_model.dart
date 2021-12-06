import 'dart:convert';

import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_manager/manager.dart';

enum AuthStatus {
  ///-待认证
  WAIT_VERIFY,

  ///-认证中
  VERIFYING,

  /// -认证失败
  FAIL,

  /// -认证通过
  PASS
}

/// 医生用户信息model
class UserInfoViewModel extends ViewStateModel {
  DoctorDetailInfoEntity data;

  /// 查询医生基础信息
  Future queryDoctorInfo() async {
    data = await API.shared.ucenter.queryDoctorDetailInfo();
    notifyListeners();
  }

  Future modifyDoctorInfo(Map<String, dynamic> param) async {
    return await API.shared.ucenter.modifyDoctorInfo(param);
  }

  ///
  /// 任何一个渠道身份认证通过，则表示该用户三要素通过
  ///
  bool isIdentityAuthPassed() {
    for( var each in data.authPlatform){
      if (each.identityStatus == 'PASS') {
        return true;
      }
    }
    return false;
  }

  ///
  /// 获取渠道的认证状态
  ///
  bool isIdentityAuthPassedByChannel(String channel) {
    return identityAuthStatusByChannel(channel) == 'PASS';
  }

  ///
  /// 通过渠道查询认证状态
  ///
  String identityAuthStatusByChannel(String channel) {
    for( var each in data.authPlatform){
      if (each.channel == channel) {
        return each.identityStatus;
      }
    }

    debugPrint('Unsupported channel , channel name -> $channel');
    return '';
  }

}
