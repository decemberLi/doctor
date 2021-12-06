// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_detail_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorDetailInfoEntity _$DoctorDetailInfoEntityFromJson(
    Map<String, dynamic> json) {
  print('----------------------${json['verifyInfo']}');
  return DoctorDetailInfoEntity(
    doctorName: json['doctorName'] as String,
    doctorMobile: json['doctorMobile'] as String,
    sex: json['sex'] as int,
    hospitalName: json['hospitalName'] as String,
    hospitalCode: json['hospitalCode'] as String,
    departmentsName: json['departmentsName'] as String,
    departmentsCode: json['departmentsCode'] as String,
    jobGradeName: json['jobGradeName'] as String,
    jobGradeCode: json['jobGradeCode'] as String,
    briefIntroduction: json['briefIntroduction'] as String,
    speciality: json['speciality'] as String,
    practiceDepartmentName: json['practiceDepartmentName'] as String,
    practiceDepartmentCode: json['practiceDepartmentCode'] as String,
    authStatus: json['authStatus'] as String,
    rejectReson: json['rejectReson'] as String,
    doctorUserId: json['doctorUserId'] as int,
    doctorId: json['doctorId'] as int,
    headPicUrl: json['headPicUrl'] as String,
    basicInfoAuthStatus: json['basicInfoAuthStatus'] as String,
      identityStatus:json['identityStatus'] as String,
  )..fullFacePhoto = json['fullFacePhoto'] == null
      ? null
      : FacePhoto.fromJson(json['fullFacePhoto'] as Map<String, dynamic>)
  ..authPlatform = json['verifyInfo'] == null
      ? null
      : (json['verifyInfo'] as List).map((e) => AuthPlatform.fromJson(e)).toList();
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
      'practiceDepartmentCode': instance.practiceDepartmentCode,
      'authStatus': instance.authStatus,
      'basicInfoAuthStatus': instance.basicInfoAuthStatus,
      'rejectReson': instance.rejectReson,
      'doctorUserId': instance.doctorUserId,
      'doctorId': instance.doctorId,
      'fullFacePhoto': instance.fullFacePhoto?.toJson() ?? null,
      'headPicUrl': instance.headPicUrl,
      'identityStatus':instance.identityStatus,
      'authPlatform':instance.authPlatform??[]
    };
