// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectResources _$CollectResourcesFromJson(Map<String, dynamic> json) {
  return CollectResources(
    json['resourceType'] as String,
    json['contentType'] as String,
    json['resourceName'] as String,
    json['resourceId'] as int,
    json['title'] as String,
    json['thumbnailOssId'] as String,
    json['thumbnailUrl'] as String,
    json['info'] == null
        ? null
        : CollectInfo.fromJson(json['info'] as Map<String, dynamic>),
  )
    ..favoriteId = json['favoriteId'] as int
    ..favoriteType = json['favoriteType'] as String;
}

Map<String, dynamic> _$CollectResourcesToJson(CollectResources instance) =>
    <String, dynamic>{
      'resourceName': instance.resourceName,
      'favoriteId': instance.favoriteId,
      'favoriteType': instance.favoriteType,
      'title': instance.title,
      'resourceType': instance.resourceType,
      'contentType': instance.contentType,
      'resourceId': instance.resourceId,
      'thumbnailOssId': instance.thumbnailOssId,
      'thumbnailUrl': instance.thumbnailUrl,
      'info': instance.info,
    };

CollectInfo _$CollectInfoFromJson(Map<String, dynamic> json) {
  return CollectInfo(
    json['duration'] as int,
    json['summary'] as String,
  );
}

Map<String, dynamic> _$CollectInfoToJson(CollectInfo instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'summary': instance.summary,
    };

CollectTimeLineResources _$CollectTimeLineResourcesFromJson(
    Map<String, dynamic> json) {
  return CollectTimeLineResources(
    json['postType'] as String,
    json['postUserName'] as String,
    json['postUserHeader'] as String,
    json['anonymityName'] as String,
    json['postTitle'] as String,
    json['postStatus'] as String,
    json['postId'] as String,
  );
}

Map<String, dynamic> _$CollectTimeLineResourcesToJson(
        CollectTimeLineResources instance) =>
    <String, dynamic>{
      'postType': instance.postType,
      'postUserName': instance.postUserName,
      'postUserHeader': instance.postUserHeader,
      'anonymityName': instance.anonymityName,
      'postTitle': instance.postTitle,
      'postStatus': instance.postStatus,
      'postId': instance.postId,
    };
