import 'dart:async';

import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/qualification/view_model/doctory_physician_qualification_view_model.dart';
import 'package:doctor/service/ucenter/ucenter_service.dart';

import 'learn/model/learn_list_model.dart';

HttpManager medServer = HttpManager('server');

HttpManager foundation = HttpManager('foundation');

/// 查询最近学习计划，接口地址：
/// http://yapi.e-medclouds.com:3000/project/5/interface/api/1553
_obtainRecentLearnPlan() async {
  var list = await medServer.post('/learn-plan/list',
      params: {
        'searchStatus': 'LEARNING',
        'taskTemplate': [],
        'ps': 10,
        'pn': 1
      },
      showLoading: false);

  return list['records']
      .map<LearnListItem>((item) => LearnListItem.fromJson(item))
      .toList();
}

/// 获取学习计划新数量
getPlanCount(params) {
  return medServer.post(
    '//learn-plan/status-count',
    params: params,
    showLoading: false,
  );
}

//反馈信息
getFeedbackInfo(params) {
  print('调用接口$params');
  return foundation.post(
    '/feedback-config/random-list',
    params: params,
  );
}

//上传反馈信息
feedbackService(params) {
  return medServer.post(
    '/learn-resource/feedback',
    params: params,
  );
}

//上传讲课视频
addLectureSubmit(params) {
  return medServer.post(
    '/doctor-lecture/submit',
    params: params,
  );
}
