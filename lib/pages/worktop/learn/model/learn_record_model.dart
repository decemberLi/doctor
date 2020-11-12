import 'package:json_annotation/json_annotation.dart';

part 'learn_record_model.g.dart';

// 讲课视频
@JsonSerializable(explicitToJson: true)
class LearnRecordingItem {
  String videoTitle;
  String presenter;
  String videoOssId;
  String videoUrl;
  int lectureId;
  LearnRecordingItem({
    this.videoTitle,
    this.presenter,
    this.videoOssId,
    this.videoUrl,
    this.lectureId,
  });

  factory LearnRecordingItem.fromJson(Map<String, dynamic> json) =>
      _$LearnRecordingItemFromJson(json);

  Map<String, dynamic> toJson() => _$LearnRecordingItemToJson(this);
}
