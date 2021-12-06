
class ActivityEntity {

  int activityPackageId;

  String activityName;

  /// 状态(WAIT_START-未开始、EXECUTING-进行中、END-已结束）
  String status;

  /// 活动类型（CASE_COLLECTION-病例收集、MEDICAL_SURVEY-医学调研）
  String activityType;

  String companyName;

  int endTime;

  int schedule;

  bool disable;
  String reason;
  String remitChannel;

  ActivityEntity(Map<String,dynamic> json){
    if (json == null){
      return;
    }
    activityPackageId = json["activityPackageId"] as int;
    activityName = json["activityName"] as String;
    status = json["status"] as String;
    activityType = json["activityType"] as String;
    companyName = json["companyName"] as String;
    endTime = json["endTime"] as int;
    schedule = json["schedule"] as int;
    disable = json["disable"] as bool;
    reason = json["reason"] as String;
    remitChannel = json["remitChannel"] as String;
  }
}

class ActivityDetailEntity extends ActivityEntity {
  String activityContent;
  int waitExecuteTask;
  int startTime;
  ActivityDetailEntity(Map<String,dynamic> json):super(json){
    activityContent = json["activityContent"] as String;
    waitExecuteTask = json["waitExecuteTask"] as int;
    startTime = json["startTime"] as int;
  }
}