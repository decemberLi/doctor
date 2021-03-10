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
  print("the json is ${json}");
  return IllnessCase(
    json['patientName'] as String,
    json['age'] as int,
    json['sex'] as int,
    json['illnessCaseId'] as int,
    json['hospital'] as String,
    json['status'] as String,
    json['showIndex'] as int,
    json['patientCode'] as String,
    json['schedule'] as int,
    json['needFields'] as List<dynamic>,
  );
}

Map<String, dynamic> _IllnessCaseToJson(IllnessCase instance) =>
    <String, dynamic>{
      'patientName': instance.patientName,
      'age': instance.age,
      'sex': instance.sex,
      'illnessCaseId':instance.illnessCaseId,
      'hospital':instance.hospital,
      'status':instance.status,
      'showIndex':instance.showIndex,
      'patientCode':instance.patientCode,
      'schedule':instance.schedule,
      'needFields':instance.showFields,
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
    illnessCase: json['illnessCase'] != null
        ? IllnessCase.fromJson(json['illnessCase'])
        : null,
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
      'illnessCase': instance.illnessCase.toJson(),
    };
