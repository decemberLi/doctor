// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearnDetailItem _$LearnDetailItemFromJson(Map<String, dynamic> json) {
  return LearnDetailItem(
    json['learnPlanId'] as int,
    json['taskDetailId'] as int,
    json['taskTemplate'] as String,
    json['taskName'] as String,
    json['representId'] as int,
    json['representName'] as String,
    json['createTime'] as int,
    json['meetingStartTime'] as int,
    json['meetingEndTime'] as int,
    json['learnProgress'] as int,
    json['status'] as String,
    json['reLearn'] as bool,
  );
}

Map<String, dynamic> _$LearnDetailItemToJson(LearnDetailItem instance) =>
    <String, dynamic>{
      'learnPlanId': instance.learnPlanId,
      'taskDetailId': instance.taskDetailId,
      'taskTemplate': instance.taskTemplate,
      'taskName': instance.taskName,
      'representId': instance.representId,
      'representName': instance.representName,
      'createTime': instance.createTime,
      'meetingStartTime': instance.meetingStartTime,
      'meetingEndTime': instance.meetingEndTime,
      'learnProgress': instance.learnProgress,
      'status': instance.status,
      'reLearn': instance.reLearn,
    };
