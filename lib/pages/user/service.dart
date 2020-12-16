import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('ucenter');

// 获取基本信息
getBasicData() {
  return http.post('/personal/query-doctor-detail', showLoading: false);
}

// 患者和收藏数量
getBasicNum() {
  return http.post('/personal/query-favorite-and-patient-number',
      showLoading: false);
}

updateUserInfo(params) {
  return http.post('/personal/edit-doctor-info',
      params: params, showLoading: false);
}

// 修改头像
updateHeadPic(params) {
  return http.post('/personal/change-head-pic',
      params: params, showLoading: false);
}
