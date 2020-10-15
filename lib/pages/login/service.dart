import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('sso');
HttpManager foundation = HttpManager('foundation');

loginByPassword(params) {
  return http.post('/user/login-by-pwd',
      params: params, ignoreSession: true, loadingText: '登录中...');
}

loginByCaptCha(params) {
  return http.post('/user/login-by-code',
      params: params, ignoreSession: true, loadingText: '登录中...');
}

sendSms(params) {
  return foundation.post(
    '/sms/send-code',
    params: params,
    ignoreSession: true,
  );
}

findPwd(params) {
  return http.post(
    '/forget/pwd',
    params: params,
  );
}
