import 'dart:async';

import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/message/model/message_center_entity.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager foundation = HttpManager('foundationSystem');

class MessageCenterViewModel extends ViewStateModel {
  MessageCenterEntity data;

  initData() async {
    var result = await foundation.post('/message/unread-type-count');
    data = MessageCenterEntity.fromJson(result);
  }
}
