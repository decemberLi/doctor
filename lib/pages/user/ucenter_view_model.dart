import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:http_manager/manager.dart';

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
}
