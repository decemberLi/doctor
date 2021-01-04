import 'package:json_annotation/json_annotation.dart';

part 'comment_list_model.g.dart';

/// 问卷问题
@JsonSerializable(explicitToJson: true)
class CommentSecond {
  String commentContent;
  int commentId;
  int commentUserId;
  String commentUserName;
  String commentUserType;
  int createTime;
  bool deleted;
  int id;
  int parentId;
  String respondent;
  String respondentUserType;
  String respondentContent;

  CommentSecond(
    this.commentContent,
    this.commentId,
    this.commentUserId,
    this.commentUserName,
    this.commentUserType,
    this.createTime,
    this.deleted,
    this.id,
    this.parentId,
    this.respondent,
    this.respondentUserType,
    this.respondentContent,
  );
  factory CommentSecond.fromJson(Map<String, dynamic> json) =>
      _$CommentSecondFromJson(json);

  Map<String, dynamic> toJson() => _$CommentSecondToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CommentListItem {
  String commentContent;
  int commentId;
  int commentUserId;
  String commentUserName;
  String commentUserType;
  int createTime;
  bool deleted;
  int id;
  int parentId;
  String respondent;
  String respondentUserType;
  List<CommentSecond> secondLevelCommentList;
  String respondentContent;
  CommentListItem(
    this.commentContent,
    this.commentId,
    this.commentUserId,
    this.commentUserName,
    this.commentUserType,
    this.createTime,
    this.deleted,
    this.id,
    this.parentId,
    this.respondent,
    this.respondentUserType,
    this.secondLevelCommentList,
      this.respondentContent
  );

  factory CommentListItem.fromJson(Map<String, dynamic> json) =>
      _$CommentListItemFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListItemToJson(this);
}
