import 'package:json_annotation/json_annotation.dart';

part 'social_message_entity.g.dart';

@JsonSerializable()
class SocialMessageModel {
  /// 消息摘要（只有评论列表需要）
  String messageAbstract;

  /// 消息标题
  String messageTitle;

  /// 消息内容
  String messageContent;

  /// 是否已读（0-未读，1-已读）
  bool readed;

  /// 帖子Id（点赞，评论的是帖子则取bizId
  int postId;

  /// 帖子类型
  String postType;

  /// 匿名名称（八卦圈时有）
  String anonymityName;

  /// 发送消息人头像（只有学术圈会返）
  String sendUserHeader;

  /// 点赞时间
  num createTime;

  int messageId;

  SocialMessageModel();

  factory SocialMessageModel.fromJson(Map<String, dynamic> param) =>
      _$SocialMessageModelFromJson(param);

  Map<String, dynamic> toJson() => _$SocialMessageModelToJson(this);
}
