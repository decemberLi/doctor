import 'package:json_annotation/json_annotation.dart';

part 'doctor_detail_info_entity.g.dart';

@JsonSerializable()
class FacePhoto {
  String ossId;

  String url;

  String name;

  FacePhoto(this.ossId, this.url, this.name);

  factory FacePhoto.fromJson(Map<String, dynamic> param) =>
      _$FacePhotoFromJson(param);

  Map<String, dynamic> toJson() => _$FacePhotoToJson(this);
}

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

  /// 认证状态
  /// 认证状态(WAIT_VERIFY-待认证、VERIFING-认证中、FAIL-认证失败、PASS-认证通过）
  String authStatus;

  /// 驳回理由
  String rejectReson;

  /// 医生用户 ID
  int doctorUserId;

  /// 医生 ID
  int doctorId;

  FacePhoto fullFacePhoto;

  DoctorDetailInfoEntity(
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
      this.authStatus,
      this.rejectReson,
      this.doctorUserId,
      this.doctorId,
      this.fullFacePhoto);

  factory DoctorDetailInfoEntity.create() =>
      DoctorDetailInfoEntity.fromJson(Map<String, dynamic>());

  factory DoctorDetailInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorDetailInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorDetailInfoEntityToJson(this);
}
