import 'package:doctor/model/face_photo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_physician_qualification_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class DoctorPhysicianInfoEntity {
  num doctorUserId;

  String identityNo;
  String identityName;
  int identitySex;
  String identityDate;
  String identityAddress;
  // 身份证有效期开始日期
  String identityValidityStart;
  // 身份证有效期结束日期
  String identityValidityEnd;
  /// 头像(正面照)
  FacePhoto fullFacePhoto;

  /// 身份证-正面照URL
  FacePhoto idCardLicense1;

  /// 身份证-反面照URL
  FacePhoto idCardLicense2;

  /// 医师资格证
  List<FacePhoto> qualifications;

  /// 医师执业证
  List<FacePhoto> practiceCertificates;

  /// 医师职称证
  List<FacePhoto> jobCertificates;

  FacePhoto signature;

  DoctorPhysicianInfoEntity(
      this.doctorUserId,
      this.identityNo,
      this.identityName,
      this.identitySex,
      this.identityDate,
      this.identityAddress,
      this.identityValidityStart,
      this.identityValidityEnd,
      this.fullFacePhoto,
      this.idCardLicense1,
      this.idCardLicense2,
      this.qualifications,
      this.practiceCertificates,
      this.jobCertificates,
      this.signature);

  factory DoctorPhysicianInfoEntity.create() =>
      DoctorPhysicianInfoEntity.fromJson(Map<String, dynamic>());

  factory DoctorPhysicianInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorPhysicianInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorPhysicianInfoEntityToJson(this);
}
