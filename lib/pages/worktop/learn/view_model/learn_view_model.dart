import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('server');

class LearnListViewModel extends ViewStateRefreshListModel {
  String learnStatus = 'learning';

  LearnListViewModel(this.learnStatus);

  @override
  Future<List<LearnListItem>> loadData({int pageNum}) async {
    var list = await http.post('/learn-plan/list', params: {
      'searchStatus': this.learnStatus,
      'taskTemplate': [],
      'ps': 10,
      'pn': pageNum
    });
    print(list['records']);
    return list['records']
        .map<LearnListItem>((item) => LearnListItem.fromJson(item))
        .toList();
  }
}
