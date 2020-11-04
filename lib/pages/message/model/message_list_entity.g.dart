// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageListEntity _$MessageListEntityFromJson(Map<String, dynamic> json) {
  return MessageListEntity()
    ..messageTitle = json['messageTitle'] as String
    ..messageAbstract = json['messageAbstract'] as String
    ..bizType = json['bizType'] as String
    ..messageContent = json['messageContent'] as String
    ..createTime = json['createTime'] as num
    ..readed = json['readed'] as bool
    ..deleted = json['deleted'] as bool
    ..messageId = json['messageId'] as num
    ..params = json['params'];
}

Map<String, dynamic> _$MessageListEntityToJson(MessageListEntity instance) =>
    <String, dynamic>{
      'messageTitle': instance.messageTitle,
      'messageAbstract': instance.messageAbstract,
      'bizType': instance.bizType,
      'messageContent': instance.messageContent,
      'createTime': instance.createTime,
      'readed': instance.readed,
      'deleted': instance.deleted,
      'messageId': instance.messageId,
      'params': instance.params,
    };
