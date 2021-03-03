import 'package:doctor/model/face_photo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_basic_info.g.dart';

@JsonSerializable()
class AuthBasicInfoEntity {
  String identityNo; // 身份证号
  String identityName; // 身份证姓名
  int identitySex; // 性别（0-女、1-男）
  String identityDate; // 身份证出生日期
  String identityAddress; // 身份证地址
  String identityValidityStart; // 身份证有效期起始时间
  String identityValidityEnd; // 身份证有效期结束时间
  String bankCard; // 银行卡号
  String bankSignMobile; // 银行卡签约手机号
  FacePhoto idCardLicenseFront; // 身份证-正面照URL
  FacePhoto idCardLicenseBehind; // 身份证-反面照URL
  FacePhoto bankCardCertificates; // 银行卡图片

  AuthBasicInfoEntity();

  factory AuthBasicInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationBasicInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationBasicInfoEntityToJson(this);

}
