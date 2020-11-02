
import 'package:json_annotation/json_annotation.dart';

part 'doctor_info_entity.g.dart';

@JsonSerializable()
class DoctorInfoEntity {
  /// 姓名
  String doctorName;
  /// 手机号
  String doctorMobile;
  /// 医院名称
  String hospitalName;
  /// 医院 code
  String hospitalCode;
  /// 科室名称
  String departmentsName;
  /// 科室 code
  String departmentsCode;
  /// 职称名称
  String jobGradeName;
  /// 职称 code
  String jobGradeCode;
  /// 医生用户 ID
  int doctorUserId;
  /// 医生 ID
  int doctorId;


  DoctorInfoEntity(
      this.doctorName,
      this.doctorMobile,
      this.hospitalName,
      this.hospitalCode,
      this.departmentsName,
      this.departmentsCode,
      this.jobGradeName,
      this.jobGradeCode,
      this.doctorUserId,
      this.doctorId);

  factory DoctorInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorInfoEntityToJson(this);
}
