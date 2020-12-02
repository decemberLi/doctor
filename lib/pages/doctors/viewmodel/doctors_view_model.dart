import 'package:common_utils/common_utils.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/doctor_circle_model.dart';

HttpManager foundation = HttpManager('foundation');

void main() {}

/*
  /// Test case
  print(formatViewCount(0));
  print(formatViewCount(9999));
  print(formatViewCount(10000));
  print(formatViewCount(10999));
  print(formatViewCount(19999));
  print(formatViewCount(100000));
  print(formatViewCount(100100));
  print(formatViewCount(109000));
  print(formatViewCount(999999));
  print(formatViewCount(1000000));
  print(formatViewCount(1001000));
  print(formatViewCount(1009000));
  print(formatViewCount(10091000));
  print(formatViewCount(1009100000));
 */
String formatViewCount(int count) {
  if (count == null) {
    return '';
  }
  if (count < 10000) {
    return '$count阅读';
  }

  double w = count / 10000;
  double mainPart = w.floorToDouble();
  double pointPart = ((count % 10000) / 1000).floorToDouble();
  var pointValue = pointPart > 0 ? '.$pointPart' : '';
  return '$mainPart$pointValue万阅读';
}

class DoctorsViewMode extends RefreshableViewStateModel<DoctorCircleModel> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final String type;

  DoctorsViewMode(this.type);

  RefreshController get refreshController => _refreshController;

  @override
  Future<List> loadData({int pageNum}) async {
    var list = await foundation.post('/comment/list',
        params: {'type': this.type, 'ps': 20, 'pn': pageNum},
        showLoading: false);
    list['records']
        .map<DoctorCircleModel>((item) => DoctorCircleModel.fromJson(item))
        .toList();
    return Future.value([]);
  }

}
