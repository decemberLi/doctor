// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentSecond _$CommentSecondFromJson(Map<String, dynamic> json) {
  return CommentSecond(
    json['commentContent'] as String,
    json['commentId'] as int,
    json['commentUserId'] as int,
    json['commentUserName'] as String,
    json['commentUserType'] as String,
    json['createTime'] as int,
    json['deleted'] as bool,
    json['id'] as int,
    json['parentId'] as int,
    json['respondent'] as String,
    json['respondentUserType'] as String,
    json['respondentContent'] as String,
  );
}

Map<String, dynamic> _$CommentSecondToJson(CommentSecond instance) =>
    <String, dynamic>{
      'commentContent': instance.commentContent,
      'commentId': instance.commentId,
      'commentUserId': instance.commentUserId,
      'commentUserName': instance.commentUserName,
      'commentUserType': instance.commentUserType,
      'createTime': instance.createTime,
      'deleted': instance.deleted,
      'id': instance.id,
      'parentId': instance.parentId,
      'respondent': instance.respondent,
      'respondentUserType': instance.respondentUserType,
      'respondentContent': instance.respondentContent,
    };

CommentListItem _$CommentListItemFromJson(Map<String, dynamic> json) {
  return CommentListItem(
    json['commentContent'] as String,
    json['commentId'] as int,
    json['commentUserId'] as int,
    json['commentUserName'] as String,
    json['commentUserType'] as String,
    json['createTime'] as int,
    json['deleted'] as bool,
    json['id'] as int,
    json['parentId'] as int,
    json['respondent'] as String,
    json['respondentUserType'] as String,
    (json['secondLevelCommentList'] as List)
        ?.map((e) => CommentSecond.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['respondentContent'] as String,
  );
}

Map<String, dynamic> _$CommentListItemToJson(CommentListItem instance) =>
    <String, dynamic>{
      'commentContent': instance.commentContent,
      'commentId': instance.commentId,
      'commentUserId': instance.commentUserId,
      'commentUserName': instance.commentUserName,
      'commentUserType': instance.commentUserType,
      'createTime': instance.createTime,
      'deleted': instance.deleted,
      'id': instance.id,
      'parentId': instance.parentId,
      'respondent': instance.respondent,
      'respondentUserType': instance.respondentUserType,
      'respondentContent': instance.respondentContent,
      'secondLevelCommentList':
          instance.secondLevelCommentList?.map((e) => e?.toJson())?.toList(),
    };
