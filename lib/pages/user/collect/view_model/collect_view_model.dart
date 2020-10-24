import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/user/collect/model/collect_list_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('server');

class CollectListViewModel extends ViewStateRefreshListModel {
  @override
  Future<List<CollectResources>> loadData({int pageNum}) async {
    var list =
        await http.post('/favorite/list', params: {'ps': 10, 'pn': pageNum});
    return list['records']
        .map<CollectResources>((item) => CollectResources.fromJson(item))
        .toList();
  }
}
