// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learn_plan_statistical_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearnPlanStatisticalEntity _$LearnPlanStatisticalEntityFromJson(
    Map<String, dynamic> json) {
  return LearnPlanStatisticalEntity(
    json['taskTemplate'] as String,
    json['unSubmitNum'] as int,
  );
}

Map<String, dynamic> _$LearnPlanStatisticalEntityToJson(
        LearnPlanStatisticalEntity instance) =>
    <String, dynamic>{
      'taskTemplate': instance.taskTemplate,
      'unSubmitNum': instance.unSubmitNum,
    };
