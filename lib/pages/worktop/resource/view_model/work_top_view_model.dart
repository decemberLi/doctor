import 'package:doctor/pages/worktop/model/work_top_entity.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/service/biz/biz_service.dart';

class WorkTopViewModel extends ViewStateRefreshListModel {
  @override
  Future<List> loadData({int pageNum}) async {
    WorktopPageEntity entity = WorktopPageEntity();
    // 学习计划统计
    var statistical = await BizService.queryLearnStatisic();
    print("obtainWorktopData#_obtainStatistical result -> $statistical");
    if (statistical != null) {
      entity.learnPlanStatisticalEntity = statistical;
    }

    // 最近学习计划
    var list = await BizService.queryRecentLearnPlan();
    if (list != null) {
      entity.learnPlanList = list;
    }

    return Future.value([entity]);
  }
}
