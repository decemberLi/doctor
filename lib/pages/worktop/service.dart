import 'dart:async';

import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/model/doctor_info_entity.dart';
import 'package:doctor/pages/worktop/model/learn_plan_statistical_entity.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';

import 'learn/model/learn_list_model.dart';

HttpManager uCenter = HttpManager('ucenter');

HttpManager medServer = HttpManager('server');

/// 查询当前登陆的医生信息，token 参数由 http 请求统一提供。接口地址：
/// http://yapi.e-medclouds.com:3000/project/7/interface/api/1703
_obtainDoctorInfo() async {
  var doctorInfo = await uCenter.post('/my/query', showLoading: false);
  return DoctorInfoEntity.fromJson(doctorInfo);
}

/// 查询当前登陆的医生最近收到的未学习的计划列表数据，接口地址：
/// http://yapi.e-medclouds.com:3000/project/5/interface/api/4724
_obtainStatistical() async {
  Map<String, List<String>> param = {};
  param["taskTemplates"] = ['MEETING', 'SURVEY', 'VISIT'];
  var statistical = await medServer.post('/learn-plan/un-submit-num',
      params: param, showLoading: false);
  if (statistical is Exception) {
    return null;
  }
  return LearnPlanStatisticalEntity.fromJson(statistical);
}

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

/// 获取工作台页面数据
Future<WorktopPageEntity> obtainWorktopData() async {
  // 医生信息
  var doctorInfo = await _obtainDoctorInfo();
  print("obtainWorktopData#_obtainDoctorInfo result -> $doctorInfo");
  WorktopPageEntity entity = WorktopPageEntity();
  if (doctorInfo != null) {
    entity.doctorInfoEntity = doctorInfo;
  }

  // 学习计划统计
  var statistical = await _obtainStatistical();
  print("obtainWorktopData#_obtainStatistical result -> $statistical");
  if (statistical != null) {
    entity.learnPlanStatisticalEntity = statistical;
  }

  // 最近学习计划
  var list = await _obtainRecentLearnPlan();
  print("obtainWorktopData#_obtainRecentLearnPlan result -> $list");
  if (list != null) {
    entity.learnPlanList = list;
  }

  return Future.value(entity);
}
