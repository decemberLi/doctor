import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:http_manager/manager.dart';
import 'host.dart';

extension ucenterAPI on API {
  UCenter get ucenter => UCenter();
}

class UCenter extends SubAPI {
  String get middle =>
      "/medclouds-ucenter/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  /// 患者列表
  Future loadPatientList(params) async =>
      await normalPost('/patient/list', params: params);

  /// 患者列表
  Future loadPatientDetailService(int patientUserId) async => await normalPost(
        '/patient/detail',
        params: {
          'patientUserId': patientUserId,
        },
      );

  /// 查询当前登录的医生信息，token 参数由 http 请求统一提供。接口地址：
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5025
  Future<DoctorDetailInfoEntity> queryDoctorDetailInfo() async {
    var info = await normalPost('/personal/query-doctor-detail');
    return DoctorDetailInfoEntity.fromJson(info);
  }

  /// 基础信息修改
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5046
  Future modifyDoctorInfo(Map<String, dynamic> param) async =>
      await normalPost('/personal/edit-doctor-info', params: param);

  Future queryDoctorRelation() async =>
      normalPost('/personal/query-dtp-represent-exist');
}
