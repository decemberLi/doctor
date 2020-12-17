import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/doctor_circle_entity.dart';
import '../model/doctor_article_detail_entity.dart';

HttpManager dtp = HttpManager('dtp');

/*
  /// Test case
  print(formatViewCount(0));
  print(formatViewCount(9999));
  print(formatViewCount(11100));
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
  // var pointValue = pointPart.toInt() > 0 ? '.${pointPart.toInt()}' : '';
  var pointValue = '.${pointPart.toInt()}';
  return '${mainPart.toInt()}$pointValue万阅读';
}

class DoctorsViewMode extends RefreshableViewStateModel<DoctorCircleEntity> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SharedPreferences _sharedPreferences;

  final String type;

  DoctorsViewMode({this.type});

  Future<SharedPreferences> _references() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }

    return Future.value(_sharedPreferences);
  }

  RefreshController get refreshController => _refreshController;

  @override
  Future<List> loadData({int pageNum}) async {
    var list = await dtp.post('/post/list',
        params: {'postType': this.type, 'ps': 20, 'pn': pageNum},
        showLoading: false);
    List posts = list['records']
        .map<DoctorCircleEntity>((item) => DoctorCircleEntity.fromJson(item))
        .toList();
    SharedPreferences refs = await _references();
    List<String> clickedList = refs.getStringList('${type ?? '_'}click_post');
    _populateData(posts, clickedList);
    return Future.value(posts);
  }

  void _populateData(List posts, List<String> clickedList) {
    if (posts != null) {
      clickedList = clickedList == null ? [] : clickedList;
      for (var each in posts) {
        each.isClicked = clickedList.contains('${each.postId}');
      }
    }
  }

  markToNative(int postId) async {
    SharedPreferences refs = await _references();
    List<String> clickedList = refs.getStringList('${type ?? '_'}click_post');
    if (clickedList == null) {
      clickedList = [];
    }
    if (clickedList.contains('$postId')) {
      return;
    }
    clickedList.add('$postId');
    _populateData(list, clickedList);
    refs.setStringList('${type ?? '_'}click_post', clickedList);
    notifyListeners();
  }

  Future<DoctorArticleDetailEntity> queryDetail(int postId) async {
    var result = await dtp.post('/post/query', params: {'postId': postId});
    return Future.value(DoctorArticleDetailEntity.fromJson(result));
  }

  Future<bool> like(int postId) async {
    await dtp.post('/like/post-or-comment',
        params: {'postId': postId}, showLoading: false);
    return Future.value(true);
  }

  Future<bool> collect(int postId) async {
    await dtp.post('/post/favorite',
        params: {'postId': postId}, showLoading: false);
    return Future.value(true);
  }
}
