// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigDataEntity _$ConfigDataEntityFromJson(Map<String, dynamic> json) {
  return ConfigDataEntity(
    json['code'] as String,
    json['name'] as String,
    json['children'] as String,
  );
}

Map<String, dynamic> _$ConfigDataEntityToJson(ConfigDataEntity instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'children': instance.children,
    };

HospitalEntity _$HospitalEntityFromJson(Map<String, dynamic> json) {
  return HospitalEntity(
    json['num'] as String,
    json['hospitalName'] as String,
    json['address'] as String,
    json['level'] as String,
    json['hospitalCode'] as String,
  );
}

Map<String, dynamic> _$HospitalEntityToJson(HospitalEntity instance) =>
    <String, dynamic>{
      'num': instance.num,
      'hospitalName': instance.hospitalName,
      'address': instance.address,
      'level': instance.level,
      'hospitalCode': instance.hospitalCode,
    };
