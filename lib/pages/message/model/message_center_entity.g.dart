// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_center_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCenterEntity _$MessageCenterEntityFromJson(Map<String, dynamic> json) {
  return MessageCenterEntity(
    json['systemCount'] as int,
    json['prescriptionCount'] as int,
    json['leanPlanCount'] as int,
    json['interactiveCount'] as int,
  );
}

Map<String, dynamic> _$MessageCenterEntityToJson(
        MessageCenterEntity instance) =>
    <String, dynamic>{
      'systemCount': instance.systemCount,
      'prescriptionCount': instance.prescriptionCount,
      'leanPlanCount': instance.leanPlanCount,
      'interactiveCount': instance.interactiveCount,
    };
