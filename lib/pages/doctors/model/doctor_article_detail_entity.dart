import 'package:json_annotation/json_annotation.dart';

part 'doctor_article_detail_entity.g.dart';

@JsonSerializable()
class DoctorArticleDetailEntity {
  String postTitle;
  int postId;
  String postContent;
  int viewNum;
  String postType;
  String departName;
  String columnName;
  String postUserName;
  String postUserHeader;
  int commentNum;
  int likeNum;
  num updateShelvesTime;
  bool likeFlag;
  bool favoriteFlag;

  DoctorArticleDetailEntity();

  factory DoctorArticleDetailEntity.fromJson(Map<String, dynamic> param) =>
      _$DoctorArticleDetailEntityFromJson(param);

  Map<String, dynamic> toJson() => _$DoctorArticleDetailEntityToJson(this);
}
