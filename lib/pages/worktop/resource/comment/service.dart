import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('server');

// 发表评论
sendComment(params) {
  print(params);
  return http.post(
    '/comment/add',
    params: params,
  );
}
