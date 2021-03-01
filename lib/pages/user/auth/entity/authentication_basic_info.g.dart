// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_basic_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationBasicInfoEntity _$AuthenticationBasicInfoEntityFromJson(
    Map<String, dynamic> json) {
  return AuthenticationBasicInfoEntity()
    ..identityNo = json['identityNo'] as String
    ..identityName = json['identityName'] as String
    ..identitySex = json['identitySex'] as int
    ..identityDate = json['identityDate'] as String
    ..identityAddress = json['identityAddress'] as String
    ..identityValidityStart = json['identityValidityStart'] as String
    ..identityValidityEnd = json['identityValidityEnd'] as String
    ..bankCard = json['bankCard'] as String
    ..bankSignMobile = json['bankSignMobile'] as String
    ..idCardLicenseFront = json['idCardLicenseFront'] == null
        ? null
        : FacePhoto.fromJson(json['idCardLicenseFront'] as Map<String, dynamic>)
    ..idCardLicenseBehind = json['idCardLicenseBehind'] == null
        ? null
        : FacePhoto.fromJson(
            json['idCardLicenseBehind'] as Map<String, dynamic>)
    ..bankCardCertificates = json['bankCardCertificates'] == null
        ? null
        : FacePhoto.fromJson(
            json['bankCardCertificates'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AuthenticationBasicInfoEntityToJson(
        AuthenticationBasicInfoEntity instance) =>
    <String, dynamic>{
      'identityNo': instance.identityNo,
      'identityName': instance.identityName,
      'identitySex': instance.identitySex,
      'identityDate': instance.identityDate,
      'identityAddress': instance.identityAddress,
      'identityValidityStart': instance.identityValidityStart,
      'identityValidityEnd': instance.identityValidityEnd,
      'bankCard': instance.bankCard,
      'bankSignMobile': instance.bankSignMobile,
      'idCardLicenseFront': instance.idCardLicenseFront,
      'idCardLicenseBehind': instance.idCardLicenseBehind,
      'bankCardCertificates': instance.bankCardCertificates,
    };
