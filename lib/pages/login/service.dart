import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('sso');

loginByPassword(params) {
  return http.post('/user/login-by-pwd',
      params: params, ignoreSession: true, loadingText: '登录中...');
}
