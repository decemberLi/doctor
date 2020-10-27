// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) {
  return PatientModel(
    patientUserId: json['patientUserId'] as int,
    patientName: json['patientName'] as String,
    age: json['age'] as int,
    sex: json['sex'] as int,
    diagnosisTime: json['diagnosisTime'] as num,
    diseaseName: json['diseaseName'] as String,
    diseaseType: json['diseaseType'] as String,
    patientHeaderUrl: json['patientHeaderUrl'] as String,
  );
}

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'patientUserId': instance.patientUserId,
      'patientName': instance.patientName,
      'age': instance.age,
      'sex': instance.sex,
      'diagnosisTime': instance.diagnosisTime,
      'diseaseName': instance.diseaseName,
      'diseaseType': instance.diseaseType,
      'patientHeaderUrl': instance.patientHeaderUrl,
    };
