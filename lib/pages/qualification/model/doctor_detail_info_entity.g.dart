// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_detail_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacePhoto _$FacePhotoFromJson(Map<String, dynamic> json) {
  return FacePhoto(
    json['ossId'] as String,
    json['url'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$FacePhotoToJson(FacePhoto instance) => <String, dynamic>{
      'ossId': instance.ossId,
      'url': instance.url,
      'name': instance.name,
    };

DoctorDetailInfoEntity _$DoctorDetailInfoEntityFromJson(
    Map<String, dynamic> json) {
  return DoctorDetailInfoEntity(
    json['doctorName'] as String,
    json['doctorMobile'] as String,
    json['sex'] as int,
    json['hospitalName'] as String,
    json['hospitalCode'] as String,
    json['departmentsName'] as String,
    json['departmentsCode'] as String,
    json['jobGradeName'] as String,
    json['jobGradeCode'] as String,
    json['briefIntroduction'] as String,
    json['speciality'] as String,
    json['practiceDepartmentName'] as String,
    json['authStatus'] as String,
    json['rejectReson'] as String,
    json['doctorUserId'] as int,
    json['doctorId'] as int,
    json['fullFacePhoto'] == null
        ? null
        : FacePhoto.fromJson(json['fullFacePhoto'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DoctorDetailInfoEntityToJson(
        DoctorDetailInfoEntity instance) =>
    <String, dynamic>{
      'doctorName': instance.doctorName,
      'doctorMobile': instance.doctorMobile,
      'sex': instance.sex,
      'hospitalName': instance.hospitalName,
      'hospitalCode': instance.hospitalCode,
      'departmentsName': instance.departmentsName,
      'departmentsCode': instance.departmentsCode,
      'jobGradeName': instance.jobGradeName,
      'jobGradeCode': instance.jobGradeCode,
      'briefIntroduction': instance.briefIntroduction,
      'speciality': instance.speciality,
      'practiceDepartmentName': instance.practiceDepartmentName,
      'authStatus': instance.authStatus,
      'rejectReson': instance.rejectReson,
      'doctorUserId': instance.doctorUserId,
      'doctorId': instance.doctorId,
      'fullFacePhoto': instance.fullFacePhoto,
    };
