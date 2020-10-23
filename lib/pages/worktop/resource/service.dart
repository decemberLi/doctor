import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('server');

// 获取评论
getCommentNum(params) {
  print(params);
  return http.post(
    '/comment/num',
    params: params,
  );
}
