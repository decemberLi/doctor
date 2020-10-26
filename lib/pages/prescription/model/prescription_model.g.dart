// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrescriptionModel _$PrescriptionModelFromJson(Map<String, dynamic> json) {
  return PrescriptionModel(
    id: json['id'] as int,
    prescriptionPatientName: json['prescriptionPatientName'] as String,
    prescriptionNo: json['prescriptionNo'] as String,
    reason: json['reason'] as String,
    prescriptionPatientAge: json['prescriptionPatientAge'] as int,
    prescriptionPatientSex: json['prescriptionPatientSex'] as int ?? 1,
    clinicalDiagnosis: json['clinicalDiagnosis'] as String,
    pharmacist: json['pharmacist'] as String,
    furtherConsultation: json['furtherConsultation'] as String ?? '1',
    status: json['status'] as String,
    orderStatus: json['orderStatus'] as String,
    drugRps: (json['drugRps'] as List)
        ?.map((e) =>
            e == null ? null : DrugModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    createTime: json['createTime'] as num,
    attachments: (json['attachments'] as List)
        ?.map((e) => e == null
            ? null
            : OssFileEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..doctorName = json['doctorName'] as String
    ..depart = json['depart'] as String
    ..auditorId = json['auditorId'] as String
    ..auditor = json['auditor'] as String
    ..auditTime = json['auditTime'] as String;
}

Map<String, dynamic> _$PrescriptionModelToJson(PrescriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prescriptionPatientName': instance.prescriptionPatientName,
      'prescriptionNo': instance.prescriptionNo,
      'reason': instance.reason,
      'prescriptionPatientAge': instance.prescriptionPatientAge,
      'prescriptionPatientSex': instance.prescriptionPatientSex,
      'clinicalDiagnosis': instance.clinicalDiagnosis,
      'pharmacist': instance.pharmacist,
      'furtherConsultation': instance.furtherConsultation,
      'status': instance.status,
      'orderStatus': instance.orderStatus,
      'drugRps': instance.drugRps?.map((e) => e?.toJson())?.toList(),
      'createTime': instance.createTime,
      'attachments': instance.attachments?.map((e) => e?.toJson())?.toList(),
      'doctorName': instance.doctorName,
      'depart': instance.depart,
      'auditorId': instance.auditorId,
      'auditor': instance.auditor,
      'auditTime': instance.auditTime,
    };
