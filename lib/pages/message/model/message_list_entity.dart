import 'package:json_annotation/json_annotation.dart';

part 'message_list_entity.g.dart';

@JsonSerializable()
class MessageListEntity {
  String messageTitle;
  String messageContent;
  String createTime;
  bool readed;


  MessageListEntity(
      this.messageTitle, this.messageContent, this.createTime, this.readed);

  factory MessageListEntity.create() =>
      _$MessageListEntityFromJson(Map<String, dynamic>());

  factory MessageListEntity.fromJson(Map<String, dynamic> param) =>
      _$MessageListEntityFromJson(param);

  Map<String, dynamic> toJson() => _$MessageListEntityToJson(this);
}
