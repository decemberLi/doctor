import 'package:json_annotation/json_annotation.dart';

part 'learn_detail_model.g.dart';

// /// 资源类型
@JsonSerializable()
class Resources {
  String resourceType;
  String contentType;
  String resourceName;
  int resourceId;
  String title;
  int needLearnTime;
  int learnTime;
  String status;
  String thumbnailOssId;
  String thumbnailUrl;
  String feedback;
  Info info;
  Resources(
    this.resourceType,
    this.contentType,
    this.resourceName,
    this.resourceId,
    this.title,
    this.needLearnTime,
    this.learnTime,
    this.status,
    this.thumbnailOssId,
    this.thumbnailUrl,
    this.feedback,
    this.info,
  );
  factory Resources.fromJson(Map<String, dynamic> json) =>
      _$ResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$ResourcesToJson(this);
}

@JsonSerializable()
class Info {
  int duration;
  String presenter;
  String summary;
  Info(this.duration, this.presenter, this.summary);
  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

/// 学习计划详情项
@JsonSerializable(explicitToJson: true)
class LearnDetailItem {
  /// 学习计划id
  int learnPlanId;
  int taskDetailId;
  String taskTemplate;
  String taskName;
  String doctorName;
  int doctorUserId;
  List<Resources> resources;
  String companyName;
  int representId;
  String representName;
  int createTime;
  int meetingStartTime;
  int meetingEndTime;
  int learnProgress;
  String status;
  bool reLearn;
  String reLearnReason;
  LearnDetailItem(
      this.learnPlanId,
      this.taskDetailId,
      this.taskTemplate,
      this.taskName,
      this.doctorName,
      this.doctorUserId,
      this.resources,
      this.companyName,
      this.representId,
      this.representName,
      this.createTime,
      this.meetingStartTime,
      this.meetingEndTime,
      this.learnProgress,
      this.status,
      this.reLearn,
      this.reLearnReason);

  factory LearnDetailItem.fromJson(Map<String, dynamic> json) =>
      _$LearnDetailItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnDetailItemToJson(this);
}
