// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialMessageModel _$SocialMessageModelFromJson(Map<String, dynamic> json) {
  return SocialMessageModel()
    ..messageAbstract = json['messageAbstract'] as String
    ..messageTitle = json['messageTitle'] as String
    ..messageContent = json['messageContent'] as String
    ..readed = json['readed'] as bool
    ..postId = json['postId'] as int
    ..postType = json['postType'] as String
    ..anonymityName = json['anonymityName'] as String
    ..sendUserHeader = json['sendUserHeader'] as String
    ..createTime = json['createTime'] as num
    ..messageId = json['messageId'] as int;
}

Map<String, dynamic> _$SocialMessageModelToJson(SocialMessageModel instance) =>
    <String, dynamic>{
      'messageAbstract': instance.messageAbstract,
      'messageTitle': instance.messageTitle,
      'messageContent': instance.messageContent,
      'readed': instance.readed,
      'postId': instance.postId,
      'postType': instance.postType,
      'anonymityName': instance.anonymityName,
      'sendUserHeader': instance.sendUserHeader,
      'createTime': instance.createTime,
      'messageId': instance.messageId,
    };
