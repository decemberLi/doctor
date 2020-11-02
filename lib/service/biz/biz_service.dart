import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';

class BizService {
  static HttpManager _server = HttpManager('server');


  static HttpManager get server => _server;

  static Future queryLearnStatisic() async {
    Map<String, List<String>> param = {};
    param["taskTemplates"] = ['MEETING', 'SURVEY', 'VISIT'];
    var statistical = await server.post('/learn-plan/un-submit-num',
        params: param, showLoading: false);
    if (statistical is Exception) {
      return null;
    }

    return statistical
        .map<LearnPlanStatisticalEntity>(
            (item) => LearnPlanStatisticalEntity.fromJson(item))
        .toList();
  }

  static Future queryRecentLearnPlan() async {
    var list = await server.post('/learn-plan/list',
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
}
