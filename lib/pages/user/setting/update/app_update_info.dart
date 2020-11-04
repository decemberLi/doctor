import 'package:json_annotation/json_annotation.dart';

part 'app_update_info.g.dart';

@JsonSerializable()
class AppUpdateInfo {
  String appVersion;
  String appContent;
  bool forceUpgrade;
  String downloadUrl;
  String packageSize;


  AppUpdateInfo();

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppUpdateInfoToJson(this);
}
