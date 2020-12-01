import 'package:doctor/provider/refreshable_view_state_model.dart';

class InteractionMessageListViewModel extends RefreshableViewStateModel {
  @override
  Future<List> loadData({int pageNum}) {
    return Future.value([]);
  }

  @override
  int get size => 10;
}
