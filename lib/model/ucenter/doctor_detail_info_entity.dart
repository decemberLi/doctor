import 'package:doctor/model/face_photo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'auth_platform.dart';

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

  /// 认证状态(WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  /// 第一步：
  /// 基础信息完善状态(NOT_COMPLETE-未完善,COMPLETED-已完善)
  ///
  /// 身份认证状态：
  /// 认证状态(WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  /// 资质认证状态：
  /// 认证状态(WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  /// 身份认证结果是同步返回，因此，理论上认证中、认证失败不是持续状态，可能会存在瞬态
  String authStatus;
  String identityStatus;

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

  /// 认证渠道
  List<AuthPlatform> authPlatform;

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
    this.identityStatus,
  });
  factory DoctorDetailInfoEntity.create() =>
      DoctorDetailInfoEntity.fromJson(Map<String, dynamic>());

  factory DoctorDetailInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorDetailInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorDetailInfoEntityToJson(this);
}
