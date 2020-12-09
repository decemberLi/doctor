// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_article_detail_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorArticleDetailEntity _$DoctorArticleDetailEntityFromJson(
    Map<String, dynamic> json) {
  return DoctorArticleDetailEntity()
    ..postTitle = json['postTitle'] as String
    ..postId = json['postId'] as int
    ..postContent = json['postContent'] as String
    ..viewNum = json['viewNum'] as int
    ..postType = json['postType'] as String
    ..departName = json['departName'] as String
    ..columnName = json['columnName'] as String
    ..postUserName = json['postUserName'] as String
    ..postUserHeader = json['postUserHeader'] as String
    ..commentNum = json['commentNum'] as int
    ..likeNum = json['likeNum'] as int
    ..updateShelvesTime = json['updateShelvesTime'] as num
    ..likeFlag = json['likeFlag'] as bool
    ..favoriteFlag = json['favoriteFlag'] as bool;
}

Map<String, dynamic> _$DoctorArticleDetailEntityToJson(
        DoctorArticleDetailEntity instance) =>
    <String, dynamic>{
      'postTitle': instance.postTitle,
      'postId': instance.postId,
      'postContent': instance.postContent,
      'viewNum': instance.viewNum,
      'postType': instance.postType,
      'departName': instance.departName,
      'columnName': instance.columnName,
      'postUserName': instance.postUserName,
      'postUserHeader': instance.postUserHeader,
      'commentNum': instance.commentNum,
      'likeNum': instance.likeNum,
      'updateShelvesTime': instance.updateShelvesTime,
      'likeFlag': instance.likeFlag,
      'favoriteFlag': instance.favoriteFlag,
    };
