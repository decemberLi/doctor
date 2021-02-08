import 'package:json_annotation/json_annotation.dart';

part 'banner_entity.g.dart';

@JsonSerializable()
class BannerEntity {
  int bannerId;
  String bannerName;
  String bannerUrl;
  String bannerType; // banner形式（内置内容，运营链接，无）
  String relatedContent; // 跳转链接
  String bannerStatus; // 状态
  int startTime; // 开始时间
  int endTime; // 结束时间
  int sort; // 排序

  BannerEntity();

  factory BannerEntity.fromJson(Map<String, dynamic> param) =>
      _$BannerEntityFromJson(param);

  Map<String, dynamic> toJson() => _$BannerEntityToJson(this);
}
