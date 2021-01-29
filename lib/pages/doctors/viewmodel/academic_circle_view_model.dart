import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/pages/doctors/model/banner_entity.dart';
import 'package:doctor/pages/doctors/model/doctor_circle_entity.dart';
import 'package:doctor/pages/doctors/widget/circleflow/category_widget.dart';
import 'package:doctor/pages/doctors/widget/circleflow/enterprise_open_class_widget.dart';
import 'package:doctor/pages/doctors/widget/circleflow/hot_post_widget.dart';
import 'package:doctor/pages/doctors/widget/circleflow/online_classic.dart';
import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/dtp.dart';
import 'package:doctor/http/developer.dart';

import 'banner_view_model.dart';

class AcademicCircleViewModel {
  // ignore: close_sinks
  StreamController<List<BannerEntity>> _topBannerStreamController =
      StreamController<List<BannerEntity>>();

  // ignore: close_sinks
  StreamController<List<BannerEntity>> _flowBannerStreamController =
      StreamController<List<BannerEntity>>();

  // ignore: close_sinks
  StreamController<List<OnlineClassicEntity>> _onlineClassStreamController =
      StreamController<List<OnlineClassicEntity>>();

  // ignore: close_sinks
  StreamController<List<OpenClassEntity>> _openClassStreamController =
      StreamController<List<OpenClassEntity>>();

  // ignore: close_sinks
  StreamController<List<CategoryEntity>> _categoryStreamController =
      StreamController<List<CategoryEntity>>();

  BannerViewModel _topBannerModel;
  BannerViewModel _flowBannerModel;

  AcademicCircleViewModel() {
    _topBannerModel = BannerViewModel("ACADEMIC_TOP");
    _flowBannerModel = BannerViewModel("ACADEMIC_MIDDLE");
  }

  dispose() {
    if (_topBannerStreamController != null &&
        !_topBannerStreamController.isClosed) {
      _topBannerStreamController.sink.close();
    }
    if (_flowBannerStreamController != null &&
        !_flowBannerStreamController.isClosed) {
      _flowBannerStreamController.sink.close();
    }
    if (_onlineClassStreamController != null &&
        !_onlineClassStreamController.isClosed) {
      _onlineClassStreamController.sink.close();
    }
    if (_categoryStreamController != null &&
        !_categoryStreamController.isClosed) {
      _categoryStreamController.sink.close();
    }
  }

  get topBannerStream => _topBannerStreamController.stream;

  get flowBannerStream => _flowBannerStreamController.stream;

  get onlineClassStream => _onlineClassStreamController.stream;

  get openClassStream => _openClassStreamController.stream;

  get categoryStream => _categoryStreamController.stream;

  refreshTopBanner() async {
    var banner = await _topBannerModel.getBanner();
    _topBannerStreamController.sink.add(banner);
  }

  refreshFlowBanner() async {
    var banner = await _flowBannerModel.getBanner();
    _flowBannerStreamController.sink.add(banner);
  }

  refreshOnlineClass() async {
    try {
      var list = await API.shared.dtp.postList(
        {'postType': 'VIDEO_ZONE', 'ps': 3, 'pn': 1},
      );
      List<DoctorCircleEntity> posts = list['records']
          .map<DoctorCircleEntity>((item) => DoctorCircleEntity.fromJson(item))
          .toList();
      List<OnlineClassicEntity> results = List<OnlineClassicEntity>();
      for (DoctorCircleEntity each in posts) {
        results.add(OnlineClassicEntity(
          each.postId,
          each.coverUrl,
          each.postTitle,
          each.viewNum,
        ));
      }
      _onlineClassStreamController.sink.add(results);
    } on DioError catch (e) {
      _onlineClassStreamController.sink.add(List<OnlineClassicEntity>());
    }
  }

  refreshOpenClass() async {
    try {
      var list = await API.shared.dtp.postList(
        {'postType': 'OPEN_CLASS', 'ps': 3, 'pn': 1},
      );
      List<DoctorCircleEntity> posts = list['records']
          .map<DoctorCircleEntity>((item) => DoctorCircleEntity.fromJson(item))
          .toList();
      List<OpenClassEntity> results = List<OpenClassEntity>();
      for (DoctorCircleEntity each in posts) {
        results.add(OpenClassEntity(
          each.postId,
          each.coverUrl,
          each.postContent,
          each.postTitle,
          each.viewNum,
          each.postUserName,
        ));
      }
      _openClassStreamController.sink.add(results);
    } on DioError catch (e) {
      _openClassStreamController.sink.add(List<OpenClassEntity>());
    }
  }

  refreshCategoryData() async {
    try {
      var data = await API.shared.developer.dictCategoryList();
      var list = data["records"] as List;
      print(data);
      if (list.length > 0) {
        var configList = jsonDecode(list[0]['value'])
            .map<CategoryEntity>((each) => CategoryEntity(
                  each['type'],
                  each['iconUrl'],
                  each['title'],
                  each['code'],
                ))
            .toList();
        _categoryStreamController.sink.add(configList);
      } else {
        _categoryStreamController.sink.add(List<CategoryEntity>());
      }
    } on DioError catch (e) {
      _categoryStreamController.sink.add(List<CategoryEntity>());
    }
  }

  refreshData() async {
    await refreshTopBanner();
    await refreshFlowBanner();
    await refreshOnlineClass();
    await refreshOpenClass();
    await refreshCategoryData();
  }
}
