
import 'package:json_annotation/json_annotation.dart';

part 'comment_item.g.dart';

@JsonSerializable()
class CommentItem{
  int id;
  String commentUserName;
  String commentContent;
  String respondentUserName;
  String respondentContent;

  CommentItem();
  factory CommentItem.fromJson(Map<String, dynamic> param) =>
      _$CommentItemFromJson(param);

  Map<String, dynamic> toJson() => _$CommentItemToJson(this);
}
