import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DoctorsViewMode extends RefreshableViewStateModel {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  @override
  Future<List> loadData({int pageNum}) {
    return Future.value([]);
  }

  @override
  int get size => 30;
}
