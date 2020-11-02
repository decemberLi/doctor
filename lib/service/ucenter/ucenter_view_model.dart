import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/provider/view_state_model.dart';

import 'ucenter_service.dart';

class UserInfoViewModel extends ViewStateModel {
  DoctorDetailInfoEntity data;

  Future queryDoctorInfo({Map<String, dynamic> param}) async {
    var doctorInfo = await UCenter.queryDoctorDetailInfo();
    return DoctorDetailInfoEntity.fromJson(doctorInfo);
  }

  Future modifyDoctorInfo(Map<String, dynamic> param) async {
    return await UCenter.modifyDoctorInfo(param);
  }
}
