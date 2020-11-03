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
  });

  factory LearnListItem.fromJson(Map<String, dynamic> json) =>
      _$LearnListItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnListItemToJson(this);
}
