import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctor/pages/doctors/viewmodel/banner_view_model.dart';
import 'package:doctor/pages/doctors/widget/circleflow/hot_post_widget.dart';
import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import '../model/doctor_circle_entity.dart';
import '../model/doctor_article_detail_entity.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/dtp.dart';

import 'academic_circle_view_model.dart';
import 'gossip_view_model.dart';

String formatViewCount(int count) {
  if (count == null) {
    return '';
  }
  if (count < 10000) {
    return '$count';
  }

  double w = count / 10000;
  double mainPart = w.floorToDouble();
  double pointPart = ((count % 10000) / 1000).floorToDouble();
  // var pointValue = pointPart.toInt() > 0 ? '.${pointPart.toInt()}' : '';
  var pointValue = '.${pointPart.toInt()}';
  return '${mainPart.toInt()}${pointValue}W';
}
String formatChineseViewCount(int count) {
  if (count == null) {
    return '';
  }
  if (count < 10000) {
    return '$count';
  }

  double w = count / 10000;
  double mainPart = w.floorToDouble();
  double pointPart = ((count % 10000) / 1000).floorToDouble();
  // var pointValue = pointPart.toInt() > 0 ? '.${pointPart.toInt()}' : '';
  var pointValue = '.${pointPart.toInt()}';
  return '${mainPart.toInt()}$pointValue万';
}

class DoctorsViewMode extends RefreshableViewStateModel<DoctorCircleEntity> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // ignore: close_sinks
  StreamController<List<HotPostEntity>> _hotPostStreamController =
      StreamController<List<HotPostEntity>>();

  SharedPreferences _sharedPreferences;

  final String type;

  DoctorsViewMode({this.type});

  final _academicCircleViewModel = AcademicCircleViewModel();
  final _gossipCircleViewMode = GossipViewModel();

  get topBannerStream => _academicCircleViewModel.topBannerStream;

  get flowBannerStream => _academicCircleViewModel.flowBannerStream;

  get onlineClassStream => _academicCircleViewModel.onlineClassStream;

  get openClassStream => _academicCircleViewModel.openClassStream;

  get categoryStream => _academicCircleViewModel.categoryStream;

  get hotPostStream => _hotPostStreamController.stream;

  get gossipTopBannerStream => _gossipCircleViewMode.bannerStream;

  Future<SharedPreferences> _references() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }

    return Future.value(_sharedPreferences);
  }

  RefreshController get refreshController => _refreshController;

  @override
  Future<List> refresh({bool init = false}) async {
    if (type == 'ACADEMIC') {
      await _academicCircleViewModel.refreshData();
      var listData = await super.refresh(init: init);
      if (listData.length > 3) {
        List<HotPostEntity> results = List<HotPostEntity>();
        for (DoctorCircleEntity each in listData.sublist(0,3)) {
            results.add(HotPostEntity(
              each.postId,
              each.postTitle,
            ));
        }
        _hotPostStreamController.sink.add(results);
        list = listData.sublist(3);
        return Future.value(list);
      } else {
        return Future.value(listData);
      }
    } else {
      _gossipCircleViewMode.refresh();
      return super.refresh(init: init);
    }
  }

  @override
  Future<List> loadData({int pageNum}) async {
    var list = await API.shared.dtp.postList(
      {'postType': this.type, 'ps': 20, 'pn': pageNum},
    );
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

  markToNative(itemData) async {
    itemData.read = true;
    notifyListeners();
  }

  Future<DoctorArticleDetailEntity> queryDetail(int postId) async {
    var result = await API.shared.dtp.postQuery({'postId': postId});
    return Future.value(DoctorArticleDetailEntity.fromJson(result));
  }

  Future<bool> like(int postId) async {
    try {
      await API.shared.dtp.postLike(
        {
          'postId': postId,
          'status': 'LIKE_POST',
        },
      );
      for (DoctorCircleEntity each in list) {
        if (each.postId == postId) {
          each.likeFlag = true;
          each.likeNum++;
          notifyListeners();
          break;
        }
      }
    } on DioError catch (e) {
      EasyLoading.showToast(e.message);
    }
    return Future.value(true);
  }

  Future<bool> collect(int postId) async {
    await API.shared.dtp.postFavorite({'postId': postId});
    return Future.value(true);
  }

  @override
  void dispose() {
    if (type == 'ACADEMIC') {
      _academicCircleViewModel.dispose();
    } else {
      _gossipCircleViewMode.dispose();
    }
    super.dispose();
  }
}
