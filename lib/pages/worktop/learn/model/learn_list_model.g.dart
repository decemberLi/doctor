// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceTypeResult _$ResourceTypeResultFromJson(Map<String, dynamic> json) {
  return ResourceTypeResult(
    json['resourceType'] as String,
    json['complete'] as bool,
  );
}

Map<String, dynamic> _$ResourceTypeResultToJson(ResourceTypeResult instance) =>
    <String, dynamic>{
      'resourceType': instance.resourceType,
      'complete': instance.complete,
    };

LearnListItem _$LearnListItemFromJson(Map<String, dynamic> json) {
  return LearnListItem(
    json['learnPlanId'] as int,
    json['taskDetailId'] as int,
    json['taskTemplate'] as String,
    json['taskName'] as String,
    (json['resourceTypeResult'] as List)
        ?.map((e) => e == null
            ? null
            : ResourceTypeResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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

Map<String, dynamic> _$LearnListItemToJson(LearnListItem instance) =>
    <String, dynamic>{
      'learnPlanId': instance.learnPlanId,
      'taskDetailId': instance.taskDetailId,
      'taskTemplate': instance.taskTemplate,
      'taskName': instance.taskName,
      'resourceTypeResult':
          instance.resourceTypeResult?.map((e) => e?.toJson())?.toList(),
      'representId': instance.representId,
      'representName': instance.representName,
      'createTime': instance.createTime,
      'meetingStartTime': instance.meetingStartTime,
      'meetingEndTime': instance.meetingEndTime,
      'learnProgress': instance.learnProgress,
      'status': instance.status,
      'reLearn': instance.reLearn,
    };
