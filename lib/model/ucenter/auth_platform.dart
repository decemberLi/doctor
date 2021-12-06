import 'package:doctor/pages/user/ucenter_view_model.dart';

class AuthPlatform {
  ///
  /// 渠道(GOLDEN-高灯,CLOUD_ACCOUNT-云账户)
  ///
  String channel;

  ///
  /// 身份认证状态（WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  ///
  String identityStatus;

  AuthPlatform();

  factory AuthPlatform.fromJson(Map<String, dynamic> json) => AuthPlatform()
    ..channel = json['channel'] as String
    ..identityStatus = json['identityStatus'] as String;

  Map<String, dynamic> toJson(AuthPlatform instance) => <String, dynamic>{
        'channel': instance.channel,
        'identityStatus': instance.identityStatus,
      };
}
