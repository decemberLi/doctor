import 'package:doctor/model/biz/learn_plan_statistical_entity.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';

class WorktopPageEntity {
  List<LearnPlanStatisticalEntity> learnPlanStatisticalEntity;

  List<LearnListItem> learnPlanList;
  List<ActivityEntity> activityPackages;

  WorktopPageEntity();

  factory WorktopPageEntity.from(Map<String, dynamic> json) {
    if (json == null) {
      return WorktopPageEntity();
    }
    return WorktopPageEntity()
      ..learnPlanList = json["learnPlanList"] != null
          ? (json["learnPlanList"] as List)
              .map((e) => LearnListItem.fromJson(e))
              .toList()
          : []
      ..activityPackages = json["activityPackages"] != null
          ? (json["activityPackages"] as List)
              .map((e) => ActivityEntity(e))
              .toList()
          : [];
  }
}
