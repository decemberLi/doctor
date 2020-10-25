// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageListEntity _$MessageListEntityFromJson(Map<String, dynamic> json) {
  return MessageListEntity(
    json['messageTitle'] as String,
    json['messageContent'] as String,
    json['createTime'] as String,
    json['readed'] as bool,
  );
}

Map<String, dynamic> _$MessageListEntityToJson(MessageListEntity instance) =>
    <String, dynamic>{
      'messageTitle': instance.messageTitle,
      'messageContent': instance.messageContent,
      'createTime': instance.createTime,
      'readed': instance.readed,
    };
