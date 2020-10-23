// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oss_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OssPolicy _$OssPolicyFromJson(Map<String, dynamic> json) {
  return OssPolicy(
    json['accessKeyId'] as String,
    json['expire'] as num,
    json['ossFileName'] as String,
    json['host'] as String,
    json['policy'] as String,
    json['signature'] as String,
    json['fileNamePrefix'] as String,
  );
}

Map<String, dynamic> _$OssPolicyToJson(OssPolicy instance) => <String, dynamic>{
      'accessKeyId': instance.accessKeyId,
      'expire': instance.expire,
      'ossFileName': instance.ossFileName,
      'host': instance.host,
      'policy': instance.policy,
      'signature': instance.signature,
      'fileNamePrefix': instance.fileNamePrefix,
    };
