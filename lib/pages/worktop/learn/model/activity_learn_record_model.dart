import 'package:json_annotation/json_annotation.dart';

part 'activity_learn_record_model.g.dart';

// 讲课视频
@JsonSerializable(explicitToJson: true)
class ActivityVideoLectureDetail {
  int activityTaskId;
  int activityPackageId;
  int duration;
  String ossId;
  String name;
  String url;
  String presenter;
  String status;
  String rejectReason;
  String videoUrl;
  ActivityVideoLectureDetail({
    this.activityTaskId,
    this.activityPackageId,
    this.duration,
    this.ossId,
    this.name,
    this.url,
    this.presenter,
    this.status,
    this.rejectReason,
    this.videoUrl,
  });

  factory ActivityVideoLectureDetail.fromJson(Map<String, dynamic> json) =>
      _$LearnRecordingItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnRecordingItemToJson(this);
}
