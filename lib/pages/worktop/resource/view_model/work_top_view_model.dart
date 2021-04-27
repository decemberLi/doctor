import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/http/server.dart';
import 'package:http_manager/manager.dart';

class WorkTopViewModel extends ViewStateRefreshListModel {
  @override
  Future<List> loadData({int pageNum}) async {
    WorktopPageEntity entity = WorktopPageEntity();
    // 学习计划统计
    var statistical = await queryLearnStatics();
    print("obtainWorktopData#_obtainStatistical result -> $statistical");
    if (statistical != null) {
      entity.learnPlanStatisticalEntity = statistical;
    }

    // 最近学习计划
    var list = await queryRecentLearnPlan();
    if (list != null) {
      entity.learnPlanList = list;
    }

    return Future.value([entity]);
  }

  Future queryLearnStatics() async {
    Map<String, List<String>> param = {};
    param["taskTemplates"] = ['MEETING', 'SURVEY', 'VISIT'];
    var statistical = await API.shared.server.learnPlanUnSubmitNum(
        param);
    if (statistical is Exception) {
      return null;
    }

    return statistical
        .map<LearnPlanStatisticalEntity>(
            (item) => LearnPlanStatisticalEntity.fromJson(item))
        .toList();
  }

  Future queryRecentLearnPlan() async {
    var list = await API.shared.server.learnPlanList(
      {
        'searchStatus': 'LEARNING',
        'taskTemplate': [],
        'ps': 10,
        'pn': 1
      },
    );

    return list['records']
        .map<LearnListItem>((item) => LearnListItem.fromJson(item))
        .toList();
  }

}
