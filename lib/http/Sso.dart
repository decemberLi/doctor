import 'package:http_manager/manager.dart';

import 'host.dart';

extension ssoAPI on API {
  Sso get sso => Sso();
}

class Sso extends SubAPI {

  String get middle =>
      "/medclouds-ucenter/${API.shared.defaultClient}";


  loginByPassword(params) async{
    var result = await normalPost(
      '/user/login-by-pwd',
      params: params,
    );
    return result;
  }

  loginByCaptCha(params) async{
    var result = await normalPost(
      '/user/login-after-register',
      params: params,
    );
    return result;
  }

  checkUserExists(params) async{
    return normalPost(
      '/user/exists',
      params: params,
    );
  }

  findPwd(params) async{
    var result = await normalPost(
      '/forget/pwd',
      params: params,
    );
    return result;
  }

  Future cloudAccountAgreement() async{
    return await normalPost('/cloud-account/query-cloud-account--agreement');
  }

}
