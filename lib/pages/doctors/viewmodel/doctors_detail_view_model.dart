import 'dart:convert';

import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';

import '../model/doctor_article_detail_entity.dart';

HttpManager dtp = HttpManager('dtp');

class DoctorsDetailViewMode extends ViewStateModel {
  DoctorArticleDetailEntity _detailEntity;

  DoctorArticleDetailEntity get detailEntity => _detailEntity;

  void initArticleDetail(int postId) async {
    var result = await dtp.post('/post/query', params: {'postId': postId});
    _detailEntity = DoctorArticleDetailEntity.fromJson(result);
    notifyListeners();
  }

  void like(int postId) async {
    await dtp.post('/like/post-or-comment',
        params: {'postId': postId}, showLoading: false);
    _detailEntity.likeFlag = true;
    notifyListeners();
  }

  void collect(int postId) async {
    await dtp.post('/post/favorite',
        params: {'postId': postId}, showLoading: false);
    if (!_detailEntity.favoriteFlag) {
      EasyLoading.showToast('收藏成功');
    } else {
      EasyLoading.showToast('收藏取消');
    }
    _detailEntity.favoriteFlag = !_detailEntity.favoriteFlag;
    notifyListeners();
  }

  void updateDetail(dynamic message) {
    _detailEntity = DoctorArticleDetailEntity.fromJson(message);
    notifyListeners();
  }

  void postComment(postId, commentId, commentContent) async {
    await dtp.post('/comment/add-comment',
        params: {
          'postId': postId,
          'commentId': commentId,
          'commentContent': commentContent
        },
        showLoading: false);
    if (_detailEntity != null) {
      _detailEntity.commentNum++;
      notifyListeners();
    }
  }

}
