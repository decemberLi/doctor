import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_physician_qualification_entity.dart';

import 'doctor_detail_info_entity.dart';

class DoctorQualificationModel {
  DoctorDetailInfoEntity doctorDetailInfo;
  HospitalEntity hospitalEntity;
  ConfigDataEntity configDataEntity;
  DoctorPhysicianInfoEntity physicianInfoEntity;
  bool canSubmit = false;
}
