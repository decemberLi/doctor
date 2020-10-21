class LearnPlanStatisticalEntity {
  String taskTemplate;
  String unSubmitNum;

  LearnPlanStatisticalEntity(this.taskTemplate, this.unSubmitNum);

  LearnPlanStatisticalEntity.fromJson(Map<String, dynamic> json)
      : taskTemplate = json['taskTemplate'],
        unSubmitNum = json['unSubmitNum'];
}
