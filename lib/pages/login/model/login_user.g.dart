// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) {
  return LoginUser(
    json['userId'] as int,
    json['userType'] as String,
    json['userName'] as String,
    json['realName'] as String,
    json['mobile'] as String,
  );
}

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
      'userId': instance.userId,
      'userType': instance.userType,
      'userName': instance.userName,
      'realName': instance.realName,
      'mobile': instance.mobile,
    };
