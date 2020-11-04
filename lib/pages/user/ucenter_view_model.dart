import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/provider/view_state_model.dart';

import '../../service/ucenter/ucenter_service.dart';

/// 医生用户信息model
class UserInfoViewModel extends ViewStateModel {
  DoctorDetailInfoEntity data;

  /// 查询医生基础信息
  Future queryDoctorInfo() async {
    data = await UCenter.queryDoctorDetailInfo();
  }

  Future modifyDoctorInfo(Map<String, dynamic> param) async {
    return await UCenter.modifyDoctorInfo(param);
  }
}
