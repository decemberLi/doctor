// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrugModel _$DrugModelFromJson(Map<String, dynamic> json) {
  return DrugModel(
    drugId: json['drugId'] as String,
    drugName: json['drugName'] as String,
    drugNo: json['drugNo'] as String,
    generalName: json['generalName'] as String,
    approvalNo: json['approvalNo'] as String,
    drugType: json['drugType'] as String,
    drugPrice: json['drugPrice'] as String,
    producer: json['producer'] as String,
    pictures: (json['pictures'] as List)?.map((e) => e as String)?.toList(),
    drugSize: json['drugSize'] as String,
    frequency: json['frequency'] as String,
    singleDose: json['singleDose'] as String,
    doseUnit: json['doseUnit'] as String,
    usePattern: json['usePattern'] as String,
    quantity: json['quantity'] as String,
  );
}

Map<String, dynamic> _$DrugModelToJson(DrugModel instance) => <String, dynamic>{
      'drugId': instance.drugId,
      'drugName': instance.drugName,
      'drugNo': instance.drugNo,
      'generalName': instance.generalName,
      'approvalNo': instance.approvalNo,
      'drugType': instance.drugType,
      'drugPrice': instance.drugPrice,
      'producer': instance.producer,
      'pictures': instance.pictures,
      'drugSize': instance.drugSize,
      'frequency': instance.frequency,
      'singleDose': instance.singleDose,
      'doseUnit': instance.doseUnit,
      'usePattern': instance.usePattern,
      'quantity': instance.quantity,
    };
