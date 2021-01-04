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
    prescriptionPatientSex: json['prescriptionPatientSex'] as int,
    clinicalDiagnosis: json['clinicalDiagnosis'] as String,
    pharmacist: json['pharmacist'] as String,
    furtherConsultation: json['furtherConsultation'] as bool ?? true,
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
    weight: json['weight'] as num,
      doctorSignatureUrl:json['doctorSignatureUrl']
  )
    ..expireTime = json['expireTime'] as num
    ..doctorName = json['doctorName'] as String
    ..depart = json['depart'] as String
    ..auditorId = json['auditorId'] as num
    ..auditor = json['auditor'] as String
    ..auditTime = json['auditTime'] as num
    ..exitPatient = json['exitPatient'] as bool;
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
      'expireTime': instance.expireTime,
      'attachments': instance.attachments?.map((e) => e?.toJson())?.toList(),
      'doctorName': instance.doctorName,
      'depart': instance.depart,
      'auditorId': instance.auditorId,
      'auditor': instance.auditor,
      'auditTime': instance.auditTime,
      'weight': instance.weight,
      'doctorSignatureUrl': instance.doctorSignatureUrl,
      'exitPatient': instance.exitPatient,
    };
