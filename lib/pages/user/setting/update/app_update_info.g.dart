// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdateInfo _$AppUpdateInfoFromJson(Map<String, dynamic> json) {
  return AppUpdateInfo()
    ..appVersion = json['appVersion'] as String
    ..appContent = json['appContent'] as String
    ..forceUpgrade = json['forceUpgrade'] as bool
    ..downloadUrl = json['downloadUrl'] as String
    ..packageSize = json['packageSize'] as String;
}

Map<String, dynamic> _$AppUpdateInfoToJson(AppUpdateInfo instance) =>
    <String, dynamic>{
      'appVersion': instance.appVersion,
      'appContent': instance.appContent,
      'forceUpgrade': instance.forceUpgrade,
      'downloadUrl': instance.downloadUrl,
      'packageSize': instance.packageSize,
    };
