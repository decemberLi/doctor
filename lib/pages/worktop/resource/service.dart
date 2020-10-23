import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('server');

// 获取评论
getCommentNum(params) {
  return http.post(
    '/comment/num',
    params: params,
  );
}

// 收藏
getFavoriteStatus(params) {
  return http.post(
    '/favorite/exists',
    params: params,
  );
}

// 设置收藏
setFavoriteStatus(params) {
  return http.post(
    '/favorite/add-or-cancel',
    params: params,
  );
}
