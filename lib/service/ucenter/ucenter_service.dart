import 'package:doctor/http/http_manager.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import '../../model/ucenter/doctor_info_entity.dart';

HttpManager uCenter = HttpManager('ucenter');

class UCenter {
  /// 查询当前登陆的医生信息，token 参数由 http 请求统一提供。接口地址：
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5025
  static Future queryDoctorInfo() async {
    var doctorInfo =
        await uCenter.post('/personal/query-doctor-detail', showLoading: false);
    return DoctorInfoEntity.fromJson(doctorInfo);
  }

  /// 查询当前登陆的医生信息，token 参数由 http 请求统一提供。接口地址：
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5025
  static Future queryDoctorDetailInfo() async {
    var doctorInfo =
        await uCenter.post('/personal/query-doctor-detail', showLoading: false);
    return DoctorInfoModel.fromJson(doctorInfo);
  }

  /// 基础信息修改
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5046
  static Future modifyDoctorInfo(Map<String, dynamic> param) async {
    return await uCenter.post('/personal/edit-doctor-info', params: param);
  }
}
