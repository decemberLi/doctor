import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('ucenter');
HttpManager foundation = HttpManager('foundation');

// 获取基本信息
getBasicData() {
  return http.post('/personal/query-doctor-detail', showLoading: false);
}

// 患者和收藏数量
getBasicNum() {
  return http.post('/personal/query-favorite-and-patient-number',
      showLoading: false);
}

//下拉基础信息
getSelectInfo(params) {
  return foundation.post('/pull-down-config/list',
      params: params, showLoading: false);
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
