import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/http/dtp.dart';
import 'package:http_manager/api.dart';

import '../model/doctor_article_detail_entity.dart';


class DoctorsDetailViewMode extends ViewStateModel {
  DoctorArticleDetailEntity _detailEntity;

  DoctorArticleDetailEntity get detailEntity => _detailEntity;

  void initArticleDetail(int postId) async {
    var result = await API.shared.dtp.postQuery({'postId': postId});
    _detailEntity = DoctorArticleDetailEntity.fromJson(result);
    notifyListeners();
  }

  void like(int postId) async {
    await API.shared.dtp.postLike(
        {
          'postId': postId,
          'status': 'LIKE_POST',
        },
        );
    if (_detailEntity == null) {
      return;
    }
    _detailEntity.likeFlag = true;
    _detailEntity.likeNum++;
    notifyListeners();
  }

  void collect(int postId) async {
    if (_detailEntity == null) {
      return;
    }
    await API.shared.dtp.postFavorite(
        {
          'postId': postId,
          'status': _detailEntity.favoriteFlag ?? false ? 'CANCEL' : 'FAVORITE'
        },
        );
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

  postComment(postId, commentId, commentContent) async {
    await API.shared.dtp.postComment(
        {
          'postId': postId,
          'commentId': commentId,
          'commentContent': commentContent
        },
        );
    if (_detailEntity != null) {
      _detailEntity.commentNum++;
      notifyListeners();
    }
  }

  bool isAcademic() => _detailEntity?.postType == 'ACADEMIC';
}
