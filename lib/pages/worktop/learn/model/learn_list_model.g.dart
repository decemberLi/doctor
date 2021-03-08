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

IllnessCase _IllnessCaseFromJson(Map<String, dynamic> json) {
  return IllnessCase(
    json['patientName'] as String,
    json['age'] as String,
    json['sex'] as String,
  );
}

Map<String, dynamic> _IllnessCaseToJson(IllnessCase instance) =>
    <String, dynamic>{
      'patientName': instance.patientName,
      'age': instance.age,
      'sex':instance.sex,
    };

LearnListItem _$LearnListItemFromJson(Map<String, dynamic> json) {
  return LearnListItem(
    learnPlanId: json['learnPlanId'] as int,
    taskDetailId: json['taskDetailId'] as int,
    taskTemplate: json['taskTemplate'] as String,
    taskName: json['taskName'] as String,
    resourceTypeResult: (json['resourceTypeResult'] as List)
        ?.map((e) => e == null
            ? null
            : ResourceTypeResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    representId: json['representId'] as int,
    representName: json['representName'] as String,
    createTime: json['createTime'] as int,
    meetingStartTime: json['meetingStartTime'] as int,
    meetingEndTime: json['meetingEndTime'] as int,
    learnProgress: json['learnProgress'] as int,
    status: json['status'] as String,
    reLearn: json['reLearn'] as bool,
    planImplementEndTime: json['planImplementEndTime'] as int,
    illnessCase: json['illnessCase'] != null ?
     IllnessCase.fromJson(json['illnessCase']) : null,
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
      'planImplementEndTime': instance.planImplementEndTime,
      'learnProgress': instance.learnProgress,
      'status': instance.status,
      'reLearn': instance.reLearn,
      'illnessCase':instance.illnessCase.toJson(),
    };
