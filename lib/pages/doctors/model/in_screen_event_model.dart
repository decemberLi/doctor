import 'package:doctor/common/event/event_model.dart';
import 'package:doctor/provider/view_state_model.dart';

class ScrollOutScreenViewModel extends ViewStateModel {
  Map<String, OutScreenEvent> map = {
    PAGE_DOCTOR: OutScreenEvent.of(PAGE_DOCTOR, false),
    PAGE_GOSSIP: OutScreenEvent.of(PAGE_GOSSIP, false)
  };

  OutScreenEvent _currentEvent;

  OutScreenEvent get event => _currentEvent;

  void updateState(String page, bool inScreen) {
    if (!map.containsKey(page)) {
      throw Error();
    }
    var event = map[page];
    event.isOutScreen = inScreen;
    notifyListeners();
  }

  void setCurrent(String page) {
    if (!map.containsKey(page)) {
      throw Error();
    }
    _currentEvent = map[page];
    notifyListeners();
  }

  void clean() {
    map[PAGE_DOCTOR].isOutScreen = false;
    map[PAGE_GOSSIP].isOutScreen = false;
  }
}
