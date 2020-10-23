import 'package:doctor/model/face_photo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_physician_qualification_entity.g.dart';

@JsonSerializable()
class DoctorPhysicianInfoEntity {
  num doctorUserId;

  String identityNo;
  String identityName;
  String identitySex;
  String identityDate;
  String identityAddress;
  String identityValidity;

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

  DoctorPhysicianInfoEntity(
      this.doctorUserId,
      this.identityNo,
      this.identityName,
      this.identitySex,
      this.identityDate,
      this.identityAddress,
      this.identityValidity,
      this.fullFacePhoto,
      this.idCardLicense1,
      this.idCardLicense2,
      this.qualifications,
      this.practiceCertificates,
      this.jobCertificates);

  factory DoctorPhysicianInfoEntity.create() =>
      DoctorPhysicianInfoEntity.fromJson(Map<String, dynamic>());

  factory DoctorPhysicianInfoEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorPhysicianInfoEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorPhysicianInfoEntityToJson(this);
}
