// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerEntity _$BannerEntityFromJson(Map<String, dynamic> json) {
  return BannerEntity()
    ..bannerId = json['bannerId'] as int
    ..bannerName = json['bannerName'] as String
    ..bannerUrl = json['bannerUrl'] as String
    ..bannerType = json['bannerType'] as String
    ..relatedContent = json['relatedContent'] as String
    ..bannerStatus = json['bannerStatus'] as String
    ..startTime = json['startTime'] as int
    ..endTime = json['endTime'] as int
    ..sort = json['sort'] as int;
}

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'bannerId': instance.bannerId,
      'bannerName': instance.bannerName,
      'bannerUrl': instance.bannerUrl,
      'bannerType': instance.bannerType,
      'relatedContent': instance.relatedContent,
      'bannerStatus': instance.bannerStatus,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'sort': instance.sort,
    };
