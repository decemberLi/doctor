
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
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

}

@JsonSerializable()
class ActivityDetailEntity extends ActivityEntity {
  String activityContent;
  int waitExecuteTask;
}