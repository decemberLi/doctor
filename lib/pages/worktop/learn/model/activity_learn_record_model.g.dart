// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_learn_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityVideoLectureDetail _$LearnRecordingItemFromJson(
    Map<String, dynamic> json) {
  return ActivityVideoLectureDetail(
    activityTaskId: json['activityTaskId'] as int,
    activityPackageId: json['activityPackageId'] as int,
    duration: json['duration'] as int,
    ossId: json['ossId'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    presenter: json['presenter'] as String,
    status: json['status:'] as String,
    rejectReason: json['rejectReason'] as String,
    videoUrl: json['videoUrl'] as String,
  );
}

Map<String, dynamic> _$LearnRecordingItemToJson(
        ActivityVideoLectureDetail instance) =>
    <String, dynamic>{
      'activityTaskId': instance.activityTaskId,
      'activityPackageId': instance.activityPackageId,
      'duration': instance.duration,
      'ossId': instance.ossId,
      'name': instance.name,
      'url': instance.url,
      'presenter': instance.presenter,
      'status': instance.status,
      'rejectReason': instance.rejectReason,
      'videoUrl': instance.videoUrl,
    };
