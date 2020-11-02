import 'dart:async';

import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/message/model/message_center_entity.dart';

HttpManager foundation = HttpManager('foundationSystem');

class MessageCenterModel {
  StreamController<MessageCenterEntity> _controller =
      StreamController<MessageCenterEntity>();

  get stream => _controller.stream;

  queryMessageCount() async {
    var result = await foundation.post('/message/unread-type-count');
    return MessageCenterEntity.fromJson(result);
  }

  dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
