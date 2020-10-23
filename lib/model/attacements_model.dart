import 'package:json_annotation/json_annotation.dart';

part 'attacements_model.g.dart';

/// 附件model
@JsonSerializable()
class AttacementsModel {
  /// ossId
  String ossId;

  /// 名称
  String name;

  /// 类型
  String type;

  /// 地址
  String url;

  AttacementsModel({
    this.ossId,
    this.name,
    this.type,
    this.url,
  });
  factory AttacementsModel.fromJson(Map<String, dynamic> json) =>
      _$AttacementsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttacementsModelToJson(this);
}
