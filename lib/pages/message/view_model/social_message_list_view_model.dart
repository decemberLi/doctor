import 'package:doctor/http/http_manager.dart';
import 'package:doctor/provider/refreshable_view_state_model.dart';

import '../model/social_message_model.dart';

HttpManager foundation = HttpManager('foundation');
enum SocialMessageType {
  TYPE_LIKE,
  TYPE_COMMENT,
}

class SocialMessageListViewModel extends RefreshableViewStateModel<SocialMessageModel> {
  final SocialMessageType type;

  SocialMessageListViewModel(this.type);

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (type == SocialMessageType.TYPE_LIKE) {
      result = await foundation.post('/message/like-list',
          params: {
            'ps': 10,
            'pn': pageNum,
          },
          showLoading: false);
    } else {
      result = await foundation.post('/message/comment-list',
          params: {
            'ps': 10,
            'pn': pageNum,
          },
          showLoading: false);
    }
    return result['records']
        .map<SocialMessageModel>((item) => SocialMessageModel.fromJson(item))
        .toList();
  }

  @override
  int get size => 10;
}
