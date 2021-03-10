import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'learn_list_model.g.dart';

/// 资源类型
@JsonSerializable()
class ResourceTypeResult {
  String resourceType;
  bool complete;

  ResourceTypeResult(this.resourceType, this.complete);

  factory ResourceTypeResult.fromJson(Map<String, dynamic> json) =>
      _$ResourceTypeResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceTypeResultToJson(this);
}

@JsonSerializable()
class IllnessCase {
  int illnessCaseId;
  String patientCode;
  String patientName;
  String hospital;
  String status;
  int showIndex;
  int age;
  int sex;
  int schedule;
  List<dynamic> showFields;

  IllnessCase(
    this.patientName,
    this.age,
    this.sex,
    this.illnessCaseId,
    this.hospital,
    this.status,
    this.showIndex,
    this.patientCode,
    this.schedule,
    this.showFields,
  );

  factory IllnessCase.fromJson(Map<String, dynamic> json) =>
      _IllnessCaseFromJson(json);

  Map<String, dynamic> toJson() => _IllnessCaseToJson(this);
}

/// 学习计划列表项
@JsonSerializable(explicitToJson: true)
class LearnListItem {
  /// 学习计划id
  int learnPlanId;
  int taskDetailId;
  String taskTemplate;
  String taskName;
  List<ResourceTypeResult> resourceTypeResult;
  int representId;
  String representName;
  int createTime;
  int meetingStartTime;
  int meetingEndTime;
  int planImplementEndTime;
  int learnProgress;
  String status;
  bool reLearn;
  IllnessCase illnessCase;

  LearnListItem({
    this.learnPlanId,
    this.taskDetailId,
    this.taskTemplate,
    this.taskName,
    this.resourceTypeResult,
    this.representId,
    this.representName,
    this.createTime,
    this.meetingStartTime,
    this.meetingEndTime,
    this.learnProgress,
    this.status,
    this.reLearn,
    this.planImplementEndTime,
    this.illnessCase,
  });

  factory LearnListItem.fromJson(Map<String, dynamic> json) =>
      _$LearnListItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnListItemToJson(this);
}
