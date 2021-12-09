

const String channelGolden = 'GOLDEN';
const String channelCloudAccount = 'CLOUD_ACCOUNT';

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

  Map<String, dynamic> toJson() => <String, dynamic>{
        'channel': this.channel,
        'identityStatus': this.identityStatus,
      };
}
