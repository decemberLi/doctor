// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorInfoEntity _$DoctorInfoEntityFromJson(Map<String, dynamic> json) {
  return DoctorInfoEntity(
    json['doctorName'] as String,
    json['doctorMobile'] as String,
    json['hospitalName'] as String,
    json['hospitalCode'] as String,
    json['departmentsName'] as String,
    json['departmentsCode'] as String,
    json['jobGradeName'] as String,
    json['jobGradeCode'] as String,
    json['doctorUserId'] as int,
    json['doctorId'] as int,
  );
}

Map<String, dynamic> _$DoctorInfoEntityToJson(DoctorInfoEntity instance) =>
    <String, dynamic>{
      'doctorName': instance.doctorName,
      'doctorMobile': instance.doctorMobile,
      'hospitalName': instance.hospitalName,
      'hospitalCode': instance.hospitalCode,
      'departmentsName': instance.departmentsName,
      'departmentsCode': instance.departmentsCode,
      'jobGradeName': instance.jobGradeName,
      'jobGradeCode': instance.jobGradeCode,
      'doctorUserId': instance.doctorUserId,
      'doctorId': instance.doctorId,
    };
