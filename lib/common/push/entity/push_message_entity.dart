class MessageEntity {
  String bizType;
  int messageId;
  int userId;
  Map<String, dynamic> data;

  MessageEntity(Map<String, dynamic> json) {
    bizType = json['bizType'];
    messageId = json['messageId'];
    userId = json['userId'];
    data = json['data'] == null ? {} : json['data'] as Map<String, dynamic>;
  }
}

class QualificationMessageEntity {
  String authStatus;

  QualificationMessageEntity(Map<String, dynamic> json) {
    authStatus = json['authStatus'];
  }
}

class LearnPlanMessageEntity {
  int planTaskId;
  int taskDetailId;


  LearnPlanMessageEntity(Map<String, dynamic> json) {
    taskDetailId = json['taskDetailId'];
    planTaskId = json['planTaskId'];
  }
}

class ActivityMessageEntity {
  int activityTaskId;
  int activityPackageId;
  String activityType;

  ActivityMessageEntity(Map<String, dynamic> json) {
    activityTaskId = json['activityTaskId'];
    activityPackageId = json['activityPackageId'];
    activityType = json['activityType'];
  }
}
