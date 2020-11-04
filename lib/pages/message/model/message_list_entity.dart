import 'package:json_annotation/json_annotation.dart';

part 'message_list_entity.g.dart';

@JsonSerializable()
class MessageListEntity {
  String messageTitle;
  // 消息摘要
  String messageAbstract;
  // AUTH_STATUS 资质认证；PRESCRIPTION_REJECT 处方驳回；DOCTOR_RE_LEARN 再次拜访；COMMENT 被评论
  String bizType;
  String messageContent;
  num createTime;
  bool readed;
  bool deleted;
  num messageId;
  dynamic params;

  MessageListEntity();

  factory MessageListEntity.create() =>
      _$MessageListEntityFromJson(Map<String, dynamic>());

  factory MessageListEntity.fromJson(Map<String, dynamic> param) =>
      _$MessageListEntityFromJson(param);

  Map<String, dynamic> toJson() => _$MessageListEntityToJson(this);
}
