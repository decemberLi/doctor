// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_physician_qualification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorPhysicianInfoEntity _$DoctorPhysicianInfoEntityFromJson(
    Map<String, dynamic> json) {
  return DoctorPhysicianInfoEntity(
    json['doctorUserId'] as num,
    json['identityNo'] as String,
    json['identityName'] as String,
    json['identitySex'] as int,
    json['identityDate'] as String,
    json['identityAddress'] as String,
    json['identityValidityStart'] as String,
    json['identityValidityEnd'] as String,
    json['fullFacePhoto'] == null
        ? null
        : FacePhoto.fromJson(json['fullFacePhoto'] as Map<String, dynamic>),
    json['idCardLicense1'] == null
        ? null
        : FacePhoto.fromJson(json['idCardLicense1'] as Map<String, dynamic>),
    json['idCardLicense2'] == null
        ? null
        : FacePhoto.fromJson(json['idCardLicense2'] as Map<String, dynamic>),
    (json['qualifications'] as List)
        ?.map((e) =>
            e == null ? null : FacePhoto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['practiceCertificates'] as List)
        ?.map((e) =>
            e == null ? null : FacePhoto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['jobCertificates'] as List)
        ?.map((e) =>
            e == null ? null : FacePhoto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DoctorPhysicianInfoEntityToJson(
        DoctorPhysicianInfoEntity instance) =>
    <String, dynamic>{
      'doctorUserId': instance.doctorUserId,
      'identityNo': instance.identityNo,
      'identityName': instance.identityName,
      'identitySex': instance.identitySex,
      'identityDate': instance.identityDate,
      'identityAddress': instance.identityAddress,
      'identityValidityStart': instance.identityValidityStart,
      'identityValidityEnd': instance.identityValidityEnd,
      'fullFacePhoto': instance.fullFacePhoto?.toJson(),
      'idCardLicense1': instance.idCardLicense1?.toJson(),
      'idCardLicense2': instance.idCardLicense2?.toJson(),
      'qualifications':
          instance.qualifications?.map((e) => e?.toJson())?.toList(),
      'practiceCertificates':
          instance.practiceCertificates?.map((e) => e?.toJson())?.toList(),
      'jobCertificates':
          instance.jobCertificates?.map((e) => e?.toJson())?.toList(),
    };
