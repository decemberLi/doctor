import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/pages/worktop/service/service.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager http = HttpManager('server');

class LearnListViewModel extends ViewStateRefreshListModel {
  String learnStatus = 'learning';
  List taskTemplate = [];
  LearnListViewModel(this.learnStatus, this.taskTemplate);

  @override
  Future<List<LearnListItem>> loadData({int pageNum}) async {
    var list = await http.post('/learn-plan/list', params: {
      'searchStatus': this.learnStatus,
      'taskTemplate': this.taskTemplate,
      'ps': 10,
      'pn': pageNum
    });
    return list['records']
        .map<LearnListItem>((item) => LearnListItem.fromJson(item))
        .toList();
  }
}

class LearnDetailViewModel extends ViewStateModel {
  final int learnPlanId;

  LearnDetailItem data;

  LearnDetailViewModel(this.learnPlanId);

  initData() async {
    setBusy();
    try {
      data = await loadData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  Future<LearnDetailItem> loadData() async {
    var data = await http.post('/learn-plan/detail', params: {
      'learnPlanId': this.learnPlanId,
    });
    return LearnDetailItem.fromJson(data);
  }

  Future<bool> bindLearnPlan({
    int learnPlanId,
  }) async {
    try {
      await learnSubmit({
        'learnPlanId': learnPlanId,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

// 讲课视频
class LearnRecordingModel extends ViewStateModel {
  final String learnPlanId;
  final String resourceId;

  LearnRecordingItem data;

  LearnRecordingModel(this.learnPlanId, this.resourceId);

  initData() async {
    setBusy();
    try {
      data = (await loadData());
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  Future<LearnRecordingItem> loadData() async {
    var data = await http.post('/doctor-lecture/detail', params: {
      'learnPlanId': this.learnPlanId,
      'resourceId': this.resourceId,
    });
    return LearnRecordingItem.fromJson(data);
  }
}
