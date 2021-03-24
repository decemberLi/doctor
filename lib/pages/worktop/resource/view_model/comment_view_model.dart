import 'package:doctor/pages/worktop/resource/model/comment_list_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/http/server.dart';
import 'package:http_manager/manager.dart';


class CommentListViewModel extends ViewStateRefreshListModel {
  final int resourceId;
  final int learnPlanId;
  CommentListViewModel(this.resourceId, this.learnPlanId);

  @override
  Future<List<CommentListItem>> loadData({int pageNum}) async {
    var list = await API.shared.server.commentList({
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
