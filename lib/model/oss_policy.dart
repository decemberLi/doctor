

import 'package:json_annotation/json_annotation.dart';

part 'oss_policy.g.dart';

@JsonSerializable()
class OssPolicy{
  String accessKeyId;
  num expire;
  String ossFileName;
  String host;
  String policy;
  String signature;
  String fileNamePrefix;

  OssPolicy(this.accessKeyId, this.expire, this.ossFileName, this.host,
      this.policy, this.signature,this.fileNamePrefix);

  factory OssPolicy.fromJson(Map<String, dynamic> json) =>
      _$OssPolicyFromJson(json);

  factory OssPolicy.create() => _$OssPolicyFromJson(Map<String, dynamic>());

  Map<String, dynamic> toJson() => _$OssPolicyToJson(this);
}