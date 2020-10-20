// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attacements_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttacementsModel _$AttacementsModelFromJson(Map<String, dynamic> json) {
  return AttacementsModel(
    json['ossId'] as String,
    json['name'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$AttacementsModelToJson(AttacementsModel instance) =>
    <String, dynamic>{
      'ossId': instance.ossId,
      'name': instance.name,
      'type': instance.type,
    };
