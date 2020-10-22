import 'package:json_annotation/json_annotation.dart';

part 'learn_plan_statistical_entity.g.dart';

@JsonSerializable()
class LearnPlanStatisticalEntity {
  String taskTemplate;
  int unSubmitNum;

  LearnPlanStatisticalEntity(this.taskTemplate, this.unSubmitNum);

  factory LearnPlanStatisticalEntity.fromJson(Map<String, dynamic> param) =>
      _$LearnPlanStatisticalEntityFromJson(param);

  Map<String, dynamic> toJson() => _$LearnPlanStatisticalEntityToJson(this);
}
