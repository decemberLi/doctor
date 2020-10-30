import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('sso');
HttpManager foundation = HttpManager('foundation');

loginByPassword(params) {
  return http.post(
    '/user/login-by-pwd',
    params: params,
    ignoreSession: true,
    loadingText: '登录中...',
    showLoading: true,
  );
}

loginByCaptCha(params) {
  return http.post(
    '/user/login-after-register',
    params: params,
    ignoreSession: true,
    loadingText: '登录中...',
    showLoading: true,
  );
}

sendSms(params) {
  return foundation.post(
    '/sms/send-captcha',
    params: params,
    loadingText: '发送中...',
    ignoreSession: true,
    showLoading: true,
  );
}

checkUserExists(params) {
  return http.post(
    '/user/exists',
    params: params,
    showLoading: false,
    ignoreSession: true,
  );
}

findPwd(params) {
  return http.post(
    '/forget/pwd',
    params: params,
    showLoading: true,
  );
}
