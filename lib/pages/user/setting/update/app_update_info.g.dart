// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdateInfo _$AppUpdateInfoFromJson(Map<String, dynamic> json) {
  return AppUpdateInfo(
    json['appVersion'] as String,
    json['appContent'] as String,
    json['forceUpgrade'] as bool,
    json['downloadUrl'] as String,
  );
}

Map<String, dynamic> _$AppUpdateInfoToJson(AppUpdateInfo instance) =>
    <String, dynamic>{
      'appVersion': instance.appVersion,
      'appContent': instance.appContent,
      'forceUpgrade': instance.forceUpgrade,
      'downloadUrl': instance.downloadUrl,
    };
