
import 'package:json_annotation/json_annotation.dart';

part 'message_center_entity.g.dart';

@JsonSerializable()
class MessageCenterEntity {
  String systemCount;
  String prescriptionCount;
  String leanPlanCount;
  String interactiveCount;


  MessageCenterEntity(this.systemCount, this.prescriptionCount,
      this.leanPlanCount, this.interactiveCount);

  factory MessageCenterEntity.create() =>
      _$MessageCenterEntityFromJson(Map<String, dynamic>());

  factory MessageCenterEntity.fromJson(Map<String, dynamic> param) =>
      _$MessageCenterEntityFromJson(param);

  Map<String, dynamic> toJson() => _$MessageCenterEntityToJson(this);
}
