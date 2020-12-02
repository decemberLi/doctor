// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialMessageModel _$SocialMessageModelFromJson(Map<String, dynamic> json) {
  return SocialMessageModel()
    ..messageAbstract = json['messageAbstract'] as String
    ..messageTitle = json['messageTitle'] as String
    ..messageContent = json['messageContent'] as String
    ..readed = json['readed'] as String
    ..postId = json['postId'] as String
    ..postType = json['postType'] as String
    ..anonymityName = json['anonymityName'] as String
    ..sendUserUrl = json['sendUserUrl'] as String
    ..createTime = json['createTime'] as String;
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
      'sendUserUrl': instance.sendUserUrl,
      'createTime': instance.createTime,
    };
