// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorCircleModel _$DoctorCircleModelFromJson(Map<String, dynamic> json) {
  return DoctorCircleModel()
    ..postTitle = json['postTitle'] as String
    ..postId = json['postId'] as int
    ..postContent = json['postContent'] as String
    ..viewNum = json['viewNum'] as int
    ..columnName = json['columnName'] as String
    ..postUserName = json['postUserName'] as String
    ..commentNum = json['commentNum'] as int
    ..postUserHeader = json['postUserHeader'] as String;
}

Map<String, dynamic> _$DoctorCircleModelToJson(DoctorCircleModel instance) =>
    <String, dynamic>{
      'postTitle': instance.postTitle,
      'postId': instance.postId,
      'postContent': instance.postContent,
      'viewNum': instance.viewNum,
      'columnName': instance.columnName,
      'postUserName': instance.postUserName,
      'commentNum': instance.commentNum,
      'postUserHeader': instance.postUserHeader,
    };
