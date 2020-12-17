import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/server.dart';

class BizService {


  static Future queryLearnStatisic() async {
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

  static Future queryRecentLearnPlan() async {
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
