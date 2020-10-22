// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrescriptionTemplateModel _$PrescriptionTemplateModelFromJson(
    Map<String, dynamic> json) {
  return PrescriptionTemplateModel(
    id: json['id'] as String,
    prescriptionTemplateName: json['prescriptionTemplateName'] as String,
    clinicalDiagnosis: json['clinicalDiagnosis'] as String,
    drugRp: (json['drugRp'] as List)
        ?.map((e) =>
            e == null ? null : DrugModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PrescriptionTemplateModelToJson(
        PrescriptionTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prescriptionTemplateName': instance.prescriptionTemplateName,
      'clinicalDiagnosis': instance.clinicalDiagnosis,
      'drugRp': instance.drugRp?.map((e) => e?.toJson())?.toList(),
    };
