import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/doctor_circle_entity.dart';
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
}
