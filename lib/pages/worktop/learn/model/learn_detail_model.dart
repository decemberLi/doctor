import 'package:json_annotation/json_annotation.dart';

part 'learn_detail_model.g.dart';

// /// 资源类型
@JsonSerializable()
class Resource {
  String resourceType;
  String contentType;
  String resourceName;
  int resourceId;
  String title;
  int needLearnTime;
  int learnTime;
  String ststus;
  String thumbnailOssId;
  String thumbnailUrl;
  String feedback;
  List<Info> info;
  Resource(
    this.resourceType,
    this.contentType,
    this.resourceName,
    this.resourceId,
    this.title,
    this.needLearnTime,
    this.learnTime,
    this.ststus,
    this.thumbnailOssId,
    this.thumbnailUrl,
    this.feedback,
    this.info,
  );
  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceToJson(this);
}

@JsonSerializable()
class Info {
  String duration;
  String summary;
  Info(this.duration, this.summary);
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
  List<Resource> resource;
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
      this.resource,
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
