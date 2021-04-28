
import 'package:doctor/http/foundationSystem.dart';
import 'package:doctor/pages/message/model/message_center_entity.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:http_manager/manager.dart';


class MessageCenterViewModel extends ViewStateModel {
  MessageCenterEntity data;

  initData() async {
    var result =
        await API.shared.foundationSys.messageUnredTypeCount();
    data = MessageCenterEntity.fromJson(result);
    notifyListeners();
  }
}
