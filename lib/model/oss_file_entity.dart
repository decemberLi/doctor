import 'package:json_annotation/json_annotation.dart';

part 'oss_file_entity.g.dart';

/// 附件model
@JsonSerializable()
class OssFileEntity {
  /// ossId
  String ossId;

  /// 名称
  String name;

  /// 类型
  String type;

  /// 地址
  String url;

  OssFileEntity({
    this.ossId,
    this.name,
    this.type,
    this.url,
  });
  factory OssFileEntity.fromJson(Map<String, dynamic> json) =>
      _$OssFileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OssFileEntityToJson(this);
}
