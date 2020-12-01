abstract class Event {
  String page;
}

class RefreshEvent extends Event {
  bool refreshable;

  RefreshEvent();

  factory RefreshEvent.of(String page, bool refreshable) => RefreshEvent()
    ..page = page
    ..refreshable = refreshable;
}

class OutScreenEvent extends Event {
  bool isOutScreen;

  OutScreenEvent();

  factory OutScreenEvent.of(String page, bool inScreen) => OutScreenEvent()
    ..page = page
    ..isOutScreen = inScreen;
}

const String PAGE_DOCTOR = 'doctors_circle_page';
const String PAGE_GOSSIP = 'gossip_circle_page';
