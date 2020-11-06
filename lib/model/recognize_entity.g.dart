// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognize_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrontResult _$FrontResultFromJson(Map<String, dynamic> json) {
  return FrontResult()
    ..address = json['address'] as String
    ..name = json['name'] as String
    ..nationality = json['nationality'] as String
    ..iDNumber = json['iDNumber'] as String
    ..gender = json['gender'] as String
    ..birthDate = json['birthDate'] as String;
}

Map<String, dynamic> _$FrontResultToJson(FrontResult instance) =>
    <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
      'nationality': instance.nationality,
      'iDNumber': instance.iDNumber,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
    };

BackResult _$BackResultFromJson(Map<String, dynamic> json) {
  return BackResult()
    ..startDate = json['startDate'] as String
    ..endDate = json['endDate'] as String
    ..issue = json['issue'] as String;
}

Map<String, dynamic> _$BackResultToJson(BackResult instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'issue': instance.issue,
    };

RecognizeEntity _$RecognizeEntityFromJson(Map<String, dynamic> json) {
  return RecognizeEntity()
    ..frontResult = json['frontResult'] == null
        ? null
        : FrontResult.fromJson(json['frontResult'] as Map<String, dynamic>)
    ..backResult = json['backResult'] == null
        ? null
        : BackResult.fromJson(json['backResult'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RecognizeEntityToJson(RecognizeEntity instance) =>
    <String, dynamic>{
      'frontResult': instance.frontResult,
      'backResult': instance.backResult,
    };
