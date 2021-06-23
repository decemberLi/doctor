import 'dart:core';

class ActivityQuestionnaireEntity {
  int activityPackageId;
  int activityTaskId;
  int resourceId;
  List<ActivityQuestionnairesSubEntity> questionnaires;
  ActivityIllnessCaseEntity illnessCase;

  ActivityQuestionnaireEntity();

  factory ActivityQuestionnaireEntity.fromJson(Map<String, dynamic> json) {
    return ActivityQuestionnaireEntity()
      ..activityPackageId = json["activityPackageId"] as int
      ..activityTaskId = json["activityTaskId"] as int
      ..resourceId = json["resourceId"] as int
      ..questionnaires = (json["questionnaires"] as List)
          .map((e) => ActivityQuestionnairesSubEntity.fromJson(e))
          .toList()
      ..illnessCase = ActivityIllnessCaseEntity.fromJson(json["illnessCase"]);
  }
}

class ActivityQuestionnairesSubEntity {
  int questionnaireId;
  String title;
  String summary;
  int showIndex;
  int schedule;
  String status;
  int sort;
  int submitTime;
  int openTime;
  int endTime;
  String rejectReason;

  ActivityQuestionnairesSubEntity();

  factory ActivityQuestionnairesSubEntity.fromJson(Map<String, dynamic> json) {
    return ActivityQuestionnairesSubEntity()
      ..questionnaireId = json["questionnaireId"] as int
      ..title = json["title"] as String
      ..summary = json["summary"] as String
      ..showIndex = json["showIndex"] as int
      ..schedule = json["schedule"] as int
      ..status = json["status"] as String
      ..sort = json["sort"] as int
      ..submitTime = json["submitTime"] as int
      ..rejectReason = json["rejectReason"] as String
      ..openTime = json["openTime"] as int
      ..endTime = json["endTime"] as int;
  }
}

class ActivityIllnessCaseEntity {
  List<String> showFields;
  String patientName;
  String patientCode;
  int age;
  int sex;
  String hospital;
  String status;
  int schedule;
  int completeTime;

  ActivityIllnessCaseEntity();

  factory ActivityIllnessCaseEntity.fromJson(Map<String, dynamic> json) {
    return ActivityIllnessCaseEntity()
      ..showFields = (json["showFields"] as List).map((e) => "$e").toList()
      ..patientName = json["patientName"]
      ..patientCode = json["patientCode"]
      ..age = json["age"]
      ..sex = json["sex"]
      ..hospital = json["hospital"]
      ..status = json["status"]
      ..schedule = json["schedule"]
      ..completeTime = json["completeTime"];
  }

  Map<String, dynamic> toJson() {
    return {
      "showFields": showFields,
      "patientName": patientName,
      "patientCode": patientCode,
      "age": age,
      "sex": sex,
      "hospital": hospital,
      "status": status,
      "schedule": schedule,
      "completeTime": completeTime,
    };
  }
}
