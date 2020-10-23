// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_file_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileEntity _$UploadFileEntityFromJson(Map<String, dynamic> json) {
  return UploadFileEntity(
    json['ossId'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$UploadFileEntityToJson(UploadFileEntity instance) =>
    <String, dynamic>{
      'ossId': instance.ossId,
      'url': instance.url,
    };
