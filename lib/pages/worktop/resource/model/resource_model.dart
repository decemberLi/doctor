import 'package:json_annotation/json_annotation.dart';

part 'resource_model.g.dart';

/// 资料其他信息
@JsonSerializable()
class ResourceInfo {
  String presenter;
  int duration;
  String summary;
  ResourceInfo(this.presenter, this.duration, this.summary);
  factory ResourceInfo.fromJson(Map<String, dynamic> json) =>
      _$ResourceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceInfoToJson(this);
}

/// 问卷问题
@JsonSerializable(explicitToJson: true)
class Question {
  int index;
  String type;
  String question;
  List<QuestionOption> options;
  Question(this.index, this.type, this.question, this.options);
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

/// 问卷问题选项
@JsonSerializable()
class QuestionOption {
  String answerOption;
  String index;
  int checked;
  QuestionOption(this.answerOption, this.index, this.checked);
  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ResourceModel {
  int resourceId;
  int createCompanyId;
  String title;
  String resourceName;
  String createCompanyName;
  String contentType;
  String resourceType;
  String planType;
  int needLearnTime;
  ResourceInfo info;
  List<Question> questions;
  String context;
  String thumbnailOssId;
  String attachmentOssId;
  int learnPlanId;
  String learnPlanStatus;
  int learnTime;
  int visitsNumber;
  String learnStatus;
  String feedback;
  int meetingSignInTime;
  int meetingSignInCount;

  bool complete;
  ResourceModel(
      this.resourceId,
      this.createCompanyId,
      this.title,
      this.resourceName,
      this.createCompanyName,
      this.contentType,
      this.resourceType,
      this.planType,
      this.needLearnTime,
      this.info,
      this.questions,
      this.context,
      this.thumbnailOssId,
      this.attachmentOssId,
      this.learnPlanId,
      this.learnPlanStatus,
      this.learnTime,
      this.visitsNumber,
      this.learnStatus,
      this.feedback,
      this.meetingSignInTime,
      this.meetingSignInCount);
  factory ResourceModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceModelToJson(this);
}
