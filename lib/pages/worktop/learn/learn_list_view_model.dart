import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('server');

class LearnListViewModel extends ViewStateRefreshListModel {
  @override
  Future<List> loadData({int pageNum}) async {
    return await http.post('/learn-plan/list');
  }
}
