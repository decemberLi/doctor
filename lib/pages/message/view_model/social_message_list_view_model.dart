import 'package:doctor/provider/refreshable_view_state_model.dart';
import 'package:doctor/http/foundationSystem.dart';
import 'package:http_manager/manager.dart';

import '../model/social_message_entity.dart';

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
      result = await API.shared.foundationSys.messageLikeList({
        'ps': 10,
        'pn': pageNum,
      });
    } else {
      result = await API.shared.foundationSys.messageCommentList({
        'ps': 10,
        'pn': pageNum,
      });
    }
    return result['records']
        .map<SocialMessageModel>((item) => SocialMessageModel.fromJson(item))
        .toList();
  }

  Future messageClicked(int messageId) async {
    await API.shared.foundationSys.messageUpdateStatus({
      'messageId':messageId
    });
    await refresh();
    notifyListeners();
  }

}
