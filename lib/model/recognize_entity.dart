import 'package:json_annotation/json_annotation.dart';

part 'recognize_entity.g.dart';

@JsonSerializable()
class FrontResult {
  String address;

  String name;

  String nationality;

  String iDNumber;

  String gender;

  String birthDate;

  FrontResult();

  factory FrontResult.fromJson(Map<String, dynamic> json) =>
      _$FrontResultFromJson(json);

  Map<String, dynamic> toJson() => _$FrontResultToJson(this);
}

@JsonSerializable()
class BackResult {
  String startDate;

  String endDate;

  String issue;

  BackResult();

  factory BackResult.fromJson(Map<String, dynamic> json) =>
      _$BackResultFromJson(json);

  Map<String, dynamic> toJson() => _$BackResultToJson(this);
}

@JsonSerializable()
class RecognizeEntity {
  FrontResult frontResult;
  BackResult backResult;

  RecognizeEntity();

  factory RecognizeEntity.fromJson(Map<String, dynamic> json) =>
      _$RecognizeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecognizeEntityToJson(this);
}
