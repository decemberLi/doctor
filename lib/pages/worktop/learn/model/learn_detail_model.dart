import 'package:json_annotation/json_annotation.dart';

part 'learn_detail_model.g.dart';

// /// 资源类型
// @JsonSerializable()
// class ResourceTypeResult {
//   String resourceType;
//   bool complete;
//   ResourceTypeResult(this.resourceType, this.complete);
//   factory ResourceTypeResult.fromJson(Map<String, dynamic> json) =>
//       _$ResourceTypeResultFromJson(json);

//   Map<String, dynamic> toJson() => _$ResourceTypeResultToJson(this);
// }

/// 学习计划详情项
@JsonSerializable(explicitToJson: true)
class LearnDetailItem {
  /// 学习计划id
  int learnPlanId;
  int taskDetailId;
  String taskTemplate;
  String taskName;
  // List<ResourceTypeResult> resourceTypeResult;
  int representId;
  String representName;
  int createTime;
  int meetingStartTime;
  int meetingEndTime;
  int learnProgress;
  String status;
  bool reLearn;
  LearnDetailItem(
      this.learnPlanId,
      this.taskDetailId,
      this.taskTemplate,
      this.taskName,
      // this.resourceTypeResult,
      this.representId,
      this.representName,
      this.createTime,
      this.meetingStartTime,
      this.meetingEndTime,
      this.learnProgress,
      this.status,
      this.reLearn);

  factory LearnDetailItem.fromJson(Map<String, dynamic> json) =>
      _$LearnDetailItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnDetailItemToJson(this);
}
