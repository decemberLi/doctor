import 'package:json_annotation/json_annotation.dart';
import 'package:doctor/model/face_photo.dart';

part 'doctor_detail_info_entity.g.dart';

@JsonSerializable()
class DoctorDetailInfoEntity {
  /// 姓名
  String doctorName;

  /// 手机号
  String doctorMobile;

  /// 性别
  int sex;

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

  /// 个人简介
  String briefIntroduction;

  /// 擅长疾病
  String speciality;

  /// 易学术执业科室
  String practiceDepartmentName;

  /// 易学术执业科室编码
  String practiceDepartmentCode;

  /// 认证状态(WAIT_VERIFY-待认证、VERIFING-认证中、FAIL-认证失败、PASS-认证通过）
  String authStatus;

  /// 基础信息完善状态(NOT_COMPLETE-未完善,COMPLETED-已完善)
  String basicInfoAuthStatus;

  /// 驳回理由
  String rejectReson;

  /// 医生用户 ID
  int doctorUserId;

  /// 医生 ID
  int doctorId;

  /// 医生头像
  FacePhoto fullFacePhoto;


  String headPicUrl;

  DoctorDetailInfoEntity({
    this.doctorName,
    this.doctorMobile,
    this.sex,
    this.hospitalName,
    this.hospitalCode,
    this.departmentsName,
    this.departmentsCode,
    this.jobGradeName,
    this.jobGradeCode,
    this.briefIntroduction,
    this.speciality,
    this.practiceDepartmentName,
    this.practiceDepartmentCode,
    this.authStatus,
    this.rejectReson,
    this.doctorUserId,
    this.doctorId,
    this.headPicUrl,
    this.basicInfoAuthStatus,
  });

  factory DoctorDetailInfoEntity.create() =>
      DoctorDetailInfoEntity.fromJson(Map<String, dynamic>());

  factory DoctorDetailInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorDetailInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorDetailInfoEntityToJson(this);
}
