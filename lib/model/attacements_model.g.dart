// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attacements_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttacementsModel _$AttacementsModelFromJson(Map<String, dynamic> json) {
  return AttacementsModel(
    ossId: json['ossId'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$AttacementsModelToJson(AttacementsModel instance) =>
    <String, dynamic>{
      'ossId': instance.ossId,
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
    };
