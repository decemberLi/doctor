// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_circle_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorCircleEntity _$DoctorCircleEntityFromJson(Map<String, dynamic> json) {
  return DoctorCircleEntity()
    ..postTitle = json['postTitle'] as String
    ..postId = json['postId'] as int
    ..coverUrl = json['coverUrl'] as String
    ..videoUrl = json['videoUrl'] as String
    ..postContent = json['postContent'] as String
    ..viewNum = json['viewNum'] as int
    ..columnName = json['columnName'] as String
    ..postUserName = json['postUserName'] as String
    ..commentNum = json['commentNum'] as int
    ..postUserHeader = json['postUserHeader'] as String
    ..isClicked = json['isClicked'] as bool
    ..topComments = (json['topComments'] as List)
        ?.map((e) =>
            e == null ? null : CommentItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DoctorCircleEntityToJson(DoctorCircleEntity instance) =>
    <String, dynamic>{
      'postTitle': instance.postTitle,
      'postId': instance.postId,
      'coverUrl': instance.coverUrl,
      'videoUrl': instance.videoUrl,
      'postContent': instance.postContent,
      'viewNum': instance.viewNum,
      'columnName': instance.columnName,
      'postUserName': instance.postUserName,
      'commentNum': instance.commentNum,
      'postUserHeader': instance.postUserHeader,
      'isClicked': instance.isClicked,
      'topComments': instance.topComments,
    };
