import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/resource/model/comment_list_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager http = HttpManager('server');

class CommentListViewModel extends ViewStateRefreshListModel {
  final String resourceId;
  final String learnPlanId;
  CommentListViewModel(this.resourceId, this.learnPlanId);

  @override
  Future<List<CommentListItem>> loadData({int pageNum}) async {
    var list = await http.post('/comment/list', params: {
      'resourceId': this.resourceId,
      'learnPlanId': this.learnPlanId,
      'ps': 20,
      'pn': pageNum
    });
    print('list:$list');
    return list['records']
        .map<CommentListItem>((item) => CommentListItem.fromJson(item))
        .toList();
  }
}
