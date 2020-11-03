import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('server');

/// 提交学习计划
Future learnSubmit(params) async {
  return await http.post('/learn-plan/submit', params: params);
}

// 提交问卷
submitQuestion(params) {
  print('调用接口$params');
  return http.post(
    '/submit/question',
    params: params,
  );
}

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

// 上传学习时间
updateLearnTime(params) {
  print('调用接口$params');
  return http.post(
    '/learn-resource/learn-time-submit',
    params: params,
  );
}

// 会议签到
meetingSign(params) {
  return http.post('/meeting/sign-in', params: params);
}
