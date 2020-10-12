import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('ucenter');

changePassword(params) {
  return http.post('/user/change-pwd', params: params);
}
