// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearnRecordingItem _$LearnRecordingItemFromJson(Map<String, dynamic> json) {
  return LearnRecordingItem(
    json['videoTitle'] as String,
    json['presenter'] as String,
    json['videoOssId'] as String,
    json['videoUrl'] as String,
    json['lectureId'] as int,
  );
}

Map<String, dynamic> _$LearnRecordingItemToJson(LearnRecordingItem instance) =>
    <String, dynamic>{
      'videoTitle': instance.videoTitle,
      'presenter': instance.presenter,
      'videoOssId': instance.videoOssId,
      'videoUrl': instance.videoUrl,
      'lectureId': instance.lectureId,
    };
