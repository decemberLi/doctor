// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) {
  return Resource(
    json['resourceType'] as String,
    json['contentType'] as String,
    json['resourceName'] as String,
    json['resourceId'] as String,
    json['title'] as String,
    json['needLearnTime'] as String,
    json['learnTime'] as String,
    json['ststus'] as String,
    json['thumbnailOssId'] as String,
    json['thumbnailUrl'] as String,
    json['feedback'] as String,
  );
}

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'resourceType': instance.resourceType,
      'contentType': instance.contentType,
      'resourceName': instance.resourceName,
      'resourceId': instance.resourceId,
      'title': instance.title,
      'needLearnTime': instance.needLearnTime,
      'learnTime': instance.learnTime,
      'ststus': instance.ststus,
      'thumbnailOssId': instance.thumbnailOssId,
      'thumbnailUrl': instance.thumbnailUrl,
      'feedback': instance.feedback,
    };

LearnDetailItem _$LearnDetailItemFromJson(Map<String, dynamic> json) {
  return LearnDetailItem(
    json['learnPlanId'] as int,
    json['taskDetailId'] as int,
    json['taskTemplate'] as String,
    json['taskName'] as String,
    (json['resource'] as List)
        ?.map((e) =>
            e == null ? null : Resource.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['info'] as List)
        ?.map(
            (e) => e == null ? null : Info.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['companyName'] as String,
    json['representId'] as int,
    json['representName'] as int,
    json['createTime'] as int,
    json['meetingStartTime'] as int,
    json['meetingEndTime'] as int,
    json['learnProgress'] as int,
    json['status'] as String,
    json['reLearn'] as bool,
    json['reLearnReason'] as String,
  );
}

Map<String, dynamic> _$LearnDetailItemToJson(LearnDetailItem instance) =>
    <String, dynamic>{
      'learnPlanId': instance.learnPlanId,
      'taskDetailId': instance.taskDetailId,
      'taskTemplate': instance.taskTemplate,
      'taskName': instance.taskName,
      'resource': instance.resource?.map((e) => e?.toJson())?.toList(),
      'info': instance.info?.map((e) => e?.toJson())?.toList(),
      'companyName': instance.companyName,
      'representId': instance.representId,
      'representName': instance.representName,
      'createTime': instance.createTime,
      'meetingStartTime': instance.meetingStartTime,
      'meetingEndTime': instance.meetingEndTime,
      'learnProgress': instance.learnProgress,
      'status': instance.status,
      'reLearn': instance.reLearn,
      'reLearnReason': instance.reLearnReason,
    };
