import 'package:doctor/pages/login/model/login_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_info.g.dart';

/// 登录信息
@JsonSerializable(explicitToJson: true)
class LoginInfoModel {
  /// ticket
  String ticket;

  /// 是否关注公众号
  bool wechatAccounts;

  /// 用户ID
  int userId;

  /// 用户类型 DOCTOR
  String userType;

  /// 当前登录人公司id
  int companyId;

  /// 当前登录人公司组织id
  int organizationId;

  /// 是否超级管理员（true-是、false-否）
  bool admin;

  /// 登录次数
  int loginTimes;

  /// 是否改过密码(true-是、false-否）
  bool modifiedPassword;

  /// 认证状态(WAIT_VERIFY-待认证、VERIFYING-认证中、FAIL-认证失败、PASS-认证通过）
  String authStatus;

  /// 登录用户详细信息
  LoginUser loginUser;

  static LoginInfoModel shared;

  LoginInfoModel({
    this.ticket,
    this.wechatAccounts,
    this.userId,
    this.userType,
    this.companyId,
    this.organizationId,
    this.admin,
    this.loginTimes,
    this.modifiedPassword,
    this.authStatus,
    this.loginUser,
  });
  factory LoginInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LoginInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginInfoModelToJson(this);
}
