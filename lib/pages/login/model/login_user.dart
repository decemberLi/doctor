import 'package:json_annotation/json_annotation.dart';

part 'login_user.g.dart';

/// 登录用户
@JsonSerializable()
class LoginUser {
  /// 用户id
  final int userId;

  /// 用户类型 DOCTOR
  final String userType;

  /// 用户名
  final String userName;

  /// 真实姓名
  final String realName;

  /// 手机号
  final String mobile;
  LoginUser(
    this.userId,
    this.userType,
    this.userName,
    this.realName,
    this.mobile,
  );
  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}
