// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentItem _$CommentItemFromJson(Map<String, dynamic> json) {
  return CommentItem()
    ..id = json['id'] as int
    ..commentUserName = json['commentUserName'] as String
    ..commentContent = json['commentContent'] as String
    ..respondentUserName = json['respondentUserName'] as String
    ..respondentContent = json['respondentContent'] as String;
}

Map<String, dynamic> _$CommentItemToJson(CommentItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commentUserName': instance.commentUserName,
      'commentContent': instance.commentContent,
      'respondentUserName': instance.respondentUserName,
      'respondentContent': instance.respondentContent,
    };
