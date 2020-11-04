import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager foundation = HttpManager('foundationSystem');

class MessageListModel extends ViewStateRefreshListModel<MessageListEntity> {
  String msgType;

  MessageListModel(this.msgType);

  @override
  Future<List<MessageListEntity>> loadData({int pageNum}) async {
    var result = await foundation.post('/message/list',
        params: {
          'ps': 10,
          'pn': pageNum,
          'messageType': msgType,
        },
        showLoading: false);

    return result['records']
        .map<MessageListEntity>((item) => MessageListEntity.fromJson(item))
        .toList();
  }

  Future mark(String messageId) async {
    await foundation.post('/message/update-status',params: {
      'messageId':messageId
    }, showLoading: false);
  }
}
