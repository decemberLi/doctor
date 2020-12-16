import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/doctor_circle_entity.dart';
import '../model/doctor_article_detail_entity.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/dtp.dart';

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
    var list = await API.shared.dtp.postList(
        {'postType': this.type, 'ps': 20, 'pn': pageNum},);
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
    var result = await API.shared.dtp.postQuery(  {'postId': postId});
    return Future.value(DoctorArticleDetailEntity.fromJson(result));
  }

  Future<bool> like(int postId) async {
    await API.shared.dtp.postLike(
        {'postId': postId}, );
    return Future.value(true);
  }

  Future<bool> collect(int postId) async {
    await API.shared.dtp.postFavorite(
         {'postId': postId});
    return Future.value(true);
  }
}
