
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';


part 'doctor_circle_entity.g.dart';

@JsonSerializable()
class DoctorCircleEntity {
  /// 帖子标题
  String postTitle;

  /// 帖子id
  int postId;

  /// 帖子内容
  String postContent;

  /// 浏览量
  int viewNum;

  /// 栏目类别
  String columnName;

  /// 发帖人
  String postUserName;

  /// 讨论量(仅八卦圈有)
  int commentNum;

  /// 发帖人头像
  String postUserHeader;

  DoctorCircleEntity();

  factory DoctorCircleEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorCircleEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorCircleEntityToJson(this);
}