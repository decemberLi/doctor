// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacePhoto _$FacePhotoFromJson(Map<String, dynamic> json) {
  return FacePhoto(
    json['ossId'] as String,
    json['url'] as String,
    json['name'] as String,
  )..path = json['path'] as String;
}

Map<String, dynamic> _$FacePhotoToJson(FacePhoto instance) => <String, dynamic>{
      'ossId': instance.ossId,
      'url': instance.url,
      'name': instance.name,
      'path': instance.path,
    };
