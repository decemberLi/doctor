import 'package:doctor/pages/message/model/message_list_entity.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:http_manager/manager.dart';
import 'package:doctor/http/foundationSystem.dart';


class MessageListModel extends ViewStateRefreshListModel<MessageListEntity> {
  String msgType;

  MessageListModel(this.msgType);

  @override
  Future<List<MessageListEntity>> loadData({int pageNum}) async {
    var result = await API.shared.foundationSys.messageListByType({
      'ps': 10,
      'pn': pageNum,
      'messageType': msgType,
    });

    return result['records']
        .map<MessageListEntity>((item) => MessageListEntity.fromJson(item))
        .toList();
  }

  Future mark(String messageId) async {
    await API.shared.foundationSys.messageUpdateStatus({
      'messageId':messageId
    });
  }
}
