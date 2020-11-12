// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearnRecordingItem _$LearnRecordingItemFromJson(Map<String, dynamic> json) {
  return LearnRecordingItem(
    videoTitle: json['videoTitle'] as String,
    presenter: json['presenter'] as String,
    videoOssId: json['videoOssId'] as String,
    videoUrl: json['videoUrl'] as String,
    lectureId: json['lectureId'] as int,
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
