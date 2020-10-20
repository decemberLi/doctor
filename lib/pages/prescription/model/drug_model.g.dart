// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrugModel _$DrugModelFromJson(Map<String, dynamic> json) {
  return DrugModel(
    json['drugId'] as String,
    json['drugName'] as String,
    json['drugSize'] as String,
    json['frequency'] as String,
    json['singleDose'] as String,
    json['doseUnit'] as String,
    json['usePattern'] as String,
    json['quantity'] as String,
  );
}

Map<String, dynamic> _$DrugModelToJson(DrugModel instance) => <String, dynamic>{
      'drugId': instance.drugId,
      'drugName': instance.drugName,
      'drugSize': instance.drugSize,
      'frequency': instance.frequency,
      'singleDose': instance.singleDose,
      'doseUnit': instance.doseUnit,
      'usePattern': instance.usePattern,
      'quantity': instance.quantity,
    };
