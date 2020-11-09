// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resources _$ResourcesFromJson(Map<String, dynamic> json) {
  return Resources(
    json['resourceType'] as String,
    json['contentType'] as String,
    json['resourceName'] as String,
    json['resourceId'] as int,
    json['title'] as String,
    json['needLearnTime'] as int,
    json['learnTime'] as int,
    json['status'] as String,
    json['thumbnailOssId'] as String,
    json['thumbnailUrl'] as String,
    json['feedback'] as String,
    json['info'] == null
        ? null
        : Info.fromJson(json['info'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResourcesToJson(Resources instance) => <String, dynamic>{
      'resourceType': instance.resourceType,
      'contentType': instance.contentType,
      'resourceName': instance.resourceName,
      'resourceId': instance.resourceId,
      'title': instance.title,
      'needLearnTime': instance.needLearnTime,
      'learnTime': instance.learnTime,
      'status': instance.status,
      'thumbnailOssId': instance.thumbnailOssId,
      'thumbnailUrl': instance.thumbnailUrl,
      'feedback': instance.feedback,
      'info': instance.info,
    };

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info(
    json['duration'] as int,
    json['presenter'] as String,
    json['summary'] as String,
  );
}

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'duration': instance.duration,
      'presenter': instance.presenter,
      'summary': instance.summary,
    };

LearnDetailItem _$LearnDetailItemFromJson(Map<String, dynamic> json) {
  return LearnDetailItem(
    json['learnPlanId'] as int,
    json['taskDetailId'] as int,
    json['taskTemplate'] as String,
    json['taskName'] as String,
    json['doctorName'] as String,
    json['doctorUserId'] as int,
    (json['resources'] as List)
        ?.map((e) =>
            e == null ? null : Resources.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['companyName'] as String,
    json['representId'] as int,
    json['representName'] as String,
    json['createTime'] as int,
    json['meetingStartTime'] as int,
    json['meetingEndTime'] as int,
    json['learnProgress'] as int,
    json['planImplementStartTime'] as int,
    json['planImplementEndTime'] as int,
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
      'doctorName': instance.doctorName,
      'doctorUserId': instance.doctorUserId,
      'resources': instance.resources?.map((e) => e?.toJson())?.toList(),
      'companyName': instance.companyName,
      'representId': instance.representId,
      'representName': instance.representName,
      'createTime': instance.createTime,
      'meetingStartTime': instance.meetingStartTime,
      'meetingEndTime': instance.meetingEndTime,
      'learnProgress': instance.learnProgress,
      'planImplementStartTime': instance.planImplementStartTime,
      'planImplementEndTime': instance.planImplementEndTime,
      'status': instance.status,
      'reLearn': instance.reLearn,
      'reLearnReason': instance.reLearnReason,
    };
