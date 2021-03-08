class EventHomeTab {
  final int index;

  EventHomeTab._(this.index);

  factory EventHomeTab.createWorkTopEvent() {
    return EventHomeTab._(0);
  }

  factory EventHomeTab.createDoctorCircleEvent() {
    return EventHomeTab._(1);
  }
}
