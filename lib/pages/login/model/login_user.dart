/// 通用请求返回结果封装
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
      this.userId, this.userType, this.userName, this.realName, this.mobile);
  LoginUser.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userType = json['userType'],
        userName = json['userName'],
        realName = json['realName'],
        mobile = json['mobile'];
}
