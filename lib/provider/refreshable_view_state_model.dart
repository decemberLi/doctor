import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class RefreshableViewStateModel<T> extends ViewStateRefreshListModel {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<T> _dataList = List();

  int get size => _dataList.length;

  RefreshController get refreshController => _refreshController;
}
