// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oss_file_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OssFileEntity _$OssFileEntityFromJson(Map<String, dynamic> json) {
  return OssFileEntity(
    ossId: json['ossId'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$OssFileEntityToJson(OssFileEntity instance) =>
    <String, dynamic>{
      'ossId': instance.ossId,
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
    };
