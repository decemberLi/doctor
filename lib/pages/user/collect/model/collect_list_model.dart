import 'package:json_annotation/json_annotation.dart';

part 'collect_list_model.g.dart';

// /// 资源类型
@JsonSerializable()
class CollectResources {
  String resourceName;
  int favoriteId;
  String favoriteType;
  String title;
  String resourceType;
  String contentType;
  int resourceId;
  String thumbnailOssId;
  String thumbnailUrl;
  CollectInfo info;
  CollectResources(
    this.resourceType,
    this.contentType,
    this.resourceName,
    this.resourceId,
    this.title,
    this.thumbnailOssId,
    this.thumbnailUrl,
    this.info,
  );
  factory CollectResources.fromJson(Map<String, dynamic> json) =>
      _$CollectResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$CollectResourcesToJson(this);
}

@JsonSerializable()
class CollectInfo {
  int duration;
  String summary;
  CollectInfo(this.duration, this.summary);
  factory CollectInfo.fromJson(Map<String, dynamic> json) =>
      _$CollectInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CollectInfoToJson(this);
}

@JsonSerializable()
class CollectTimeLineResources {
  String postType;
  String postUserName;
  String postUserHeader;
  String anonymityName;
  String postTitle;
  String postStatus;
  int postId;
  CollectTimeLineResources(
      this.postType,
      this.postUserName,
      this.postUserHeader,
      this.anonymityName,
      this.postTitle,
      this.postStatus,
      this.postId);
  factory CollectTimeLineResources.fromJson(Map<String, dynamic> json) =>
      _$CollectTimeLineResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$CollectTimeLineResourcesToJson(this);
}
