// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginInfoModel _$LoginInfoModelFromJson(Map<String, dynamic> json) {
  return LoginInfoModel(
    ticket: json['ticket'] as String,
    wechatAccounts: json['wechatAccounts'] as bool,
    userId: json['userId'] as int,
    userType: json['userType'] as String,
    companyId: json['companyId'] as int,
    organizationId: json['organizationId'] as int,
    admin: json['admin'] as bool,
    loginTimes: json['loginTimes'] as int,
    modifiedPassword: json['modifiedPassword'] as bool,
    authStatus: json['authStatus'] as String,
    loginUser: json['loginUser'] == null
        ? null
        : LoginUser.fromJson(json['loginUser'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginInfoModelToJson(LoginInfoModel instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
      'wechatAccounts': instance.wechatAccounts,
      'userId': instance.userId,
      'userType': instance.userType,
      'companyId': instance.companyId,
      'organizationId': instance.organizationId,
      'admin': instance.admin,
      'loginTimes': instance.loginTimes,
      'modifiedPassword': instance.modifiedPassword,
      'authStatus': instance.authStatus,
      'loginUser': instance.loginUser?.toJson(),
    };
