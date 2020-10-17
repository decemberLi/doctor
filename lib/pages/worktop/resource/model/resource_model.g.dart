// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceInfo _$ResourceInfoFromJson(Map<String, dynamic> json) {
  return ResourceInfo(
    json['presenter'] as String,
    json['duration'] as int,
    json['summary'] as String,
  );
}

Map<String, dynamic> _$ResourceInfoToJson(ResourceInfo instance) =>
    <String, dynamic>{
      'presenter': instance.presenter,
      'duration': instance.duration,
      'summary': instance.summary,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    json['index'] as int,
    json['type'] as String,
    json['question'] as String,
    (json['options'] as List)
        ?.map((e) => e == null
            ? null
            : QuestionOption.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'index': instance.index,
      'type': instance.type,
      'question': instance.question,
      'options': instance.options?.map((e) => e?.toJson())?.toList(),
    };

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) {
  return QuestionOption(
    json['answerOption'] as String,
    json['index'] as String,
    json['checked'] as int,
  );
}

Map<String, dynamic> _$QuestionOptionToJson(QuestionOption instance) =>
    <String, dynamic>{
      'answerOption': instance.answerOption,
      'index': instance.index,
      'checked': instance.checked,
    };

ResourceModel _$ResourceModelFromJson(Map<String, dynamic> json) {
  return ResourceModel(
    json['resourceId'] as int,
    json['createCompanyId'] as int,
    json['title'] as String,
    json['resourceName'] as String,
    json['createCompanyName'] as String,
    json['contentType'] as String,
    json['resourceType'] as String,
    json['planType'] as String,
    json['needLearnTime'] as int,
    json['info'] == null
        ? null
        : ResourceInfo.fromJson(json['info'] as Map<String, dynamic>),
    (json['questions'] as List)
        ?.map((e) =>
            e == null ? null : Question.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['context'] as String,
    json['thumbnailOssId'] as String,
    json['attachmentOssId'] as String,
    json['learnPlanId'] as int,
    json['learnPlanStatus'] as String,
    json['learnTime'] as int,
    json['visitsNumber'] as int,
    json['learnStatus'] as String,
    json['feedback'] as String,
    json['meetingSignInTime'] as int,
    json['meetingSignInCount'] as int,
  )..complete = json['complete'] as bool;
}

Map<String, dynamic> _$ResourceModelToJson(ResourceModel instance) =>
    <String, dynamic>{
      'resourceId': instance.resourceId,
      'createCompanyId': instance.createCompanyId,
      'title': instance.title,
      'resourceName': instance.resourceName,
      'createCompanyName': instance.createCompanyName,
      'contentType': instance.contentType,
      'resourceType': instance.resourceType,
      'planType': instance.planType,
      'needLearnTime': instance.needLearnTime,
      'info': instance.info?.toJson(),
      'questions': instance.questions?.map((e) => e?.toJson())?.toList(),
      'context': instance.context,
      'thumbnailOssId': instance.thumbnailOssId,
      'attachmentOssId': instance.attachmentOssId,
      'learnPlanId': instance.learnPlanId,
      'learnPlanStatus': instance.learnPlanStatus,
      'learnTime': instance.learnTime,
      'visitsNumber': instance.visitsNumber,
      'learnStatus': instance.learnStatus,
      'feedback': instance.feedback,
      'meetingSignInTime': instance.meetingSignInTime,
      'meetingSignInCount': instance.meetingSignInCount,
      'complete': instance.complete,
    };
