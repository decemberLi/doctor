class MessageEntity {
  String bizType;
  int messageId;
  int userId;

  MessageEntity(Map<String, dynamic> json) {
    bizType = json['bizType'];
    messageId = json['messageId'];
    userId = json['userId'];
  }
}

class QualificationMessageEntity extends MessageEntity {
  String authStatus;

  QualificationMessageEntity(Map<String, dynamic> json) : super(json) {
    authStatus = json['authStatus'];
  }
}

class LearnPlanMessageEntity extends MessageEntity {
  int planTaskId;
  int taskDetailId;

  LearnPlanMessageEntity(Map<String, dynamic> json) : super(json) {
    taskDetailId = json['taskDetailId'];
    planTaskId = json['planTaskId'];
  }
}

class ActivityMessageEntity extends MessageEntity {
  int activityTaskId;
  int activityPackageId;
  String activityType;

  ActivityMessageEntity(Map<String, dynamic> json) : super(json) {
    activityTaskId = json['activityTaskId'];
    activityPackageId = json['activityPackageId'];
    activityType = json['activityType'];
  }
}
