// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_center_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCenterEntity _$MessageCenterEntityFromJson(Map<String, dynamic> json) {
  return MessageCenterEntity(
    json['systemCount'] as String,
    json['prescriptionCount'] as String,
    json['leanPlanCount'] as String,
    json['interactiveCount'] as String,
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
