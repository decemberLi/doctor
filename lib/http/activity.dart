import 'package:http_manager/manager.dart';

import 'host.dart';

extension ActivityAPI on API {
  Activity get activity => Activity();
}

class Activity extends SubAPI {
  String get middle =>
      "/medclouds-activity/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  /// 工作台任务包列表
  workbenchTaskList() async => await normalPost("/workbench/task-list");

  /// 活动任务包详情
  packageDetail(int activityPackageId) async => await normalPost(
        "/activity-package/detail",
        params: {"activityPackageId": activityPackageId},
      );

  /// 活动任务包分页列表
  packageList(int pageNumber, {int pageSize = 10}) async => await normalPost(
        "/activity-package/list",
        params: {
          "ps":  pageSize,
          "pn": pageNumber,
        },
      );



  /// 活动子任务列表
  activityTaskList(int activityPackageId, int pageNumber, {int pageSize = 10}) async =>
      normalPost(
        "/activity-task/list",
        params: {
          "activityPackageId": activityPackageId,
          "ps": pageSize,
          "pn": pageNumber,
        },
      );

  /// 保存病例收集任务
  saveActivityCaseCollection(int activityPackageId, List<Map<String,dynamic>> attachments,
      {int activityTaskId}) async {
    var params = {};
    params["activityPackageId"] = activityPackageId;
    if (activityTaskId != null) {
      params["activityTaskId"] = activityTaskId;
    }
    params['attachments'] = attachments;
    return await normalPost(
      "/activity-task/case-collection/save-or-update",
      params: Map<String,dynamic>.from(params),
    );
  }

  ///查询病例收集图片
  activityCaseCollectionDetail(int activityTaskId) async => normalPost(
        "/activity-task/case-collection/detail",
        params: {
          "activityTaskId": activityTaskId,
        },
      );

  /// 医学调研保存患者病例
  activityIllnessCaseSave(int activityPackageId,
      {int activityTaskId,
      String patientName,
      String patientCode,
      String age,
      String sex,
      String hospital}) async {
    var params = {};
    params["activityPackageId"] = activityPackageId;
    params["activityTaskId"] = activityTaskId;
    params["patientName"] = patientName;
    params["patientCode"] = patientCode;
    params["age"] = age;
    params["sex"] = sex;
    params["hospital"] = hospital;
    return await normalPost(
      "/activity-task/illness-case/save-or-update",
      params: params,
    );
  }

  activityIllnessCaseSaveWithJson(int activityPackageId,
      Map params,{int activityTaskId}) async {
    params["activityPackageId"] = activityPackageId;
    params["activityTaskId"] = activityTaskId;
    return await normalPost(
      "/activity-task/illness-case/save-or-update",
      params: params,
    );
  }

  /// 医学调研查询资源问卷列表
  activityQuestionnaireList(int activityPackageId, {int activityTaskId}) async {
    Map<String,dynamic> params = {};
    params["activityPackageId"] = activityPackageId;
    if (activityTaskId != null) {
      params["activityTaskId"] = activityTaskId;
    }
    return await normalPost(
      "/activity-task/questionnaire/list",
      params: params,
    );
  }

  /// 医学调研保存问卷
  activityQuestionnaireSave(
    int activityPackageId,
    int resourceId,
    int activityTaskId,
    int questionnaireId,
    String title,
    String summary,
    String noteInfo,
    String questions,
    String sort,
  ) async {
    var params = {};
    params["activityPackageId"] = activityPackageId;
    params["resourceId"] = resourceId;
    params["activityTaskId"] = activityTaskId;
    params["questionnaireId"] = questionnaireId;
    params["title"] = title;
    params["summary"] = summary;
    params["noteInfo"] = noteInfo;
    params["questions"] = questions;
    params["sort"] = sort;
    return await normalPost(
      "/activity-task/questionnaire/save-or-update",
      params: params,
    );
  }

  /// 医学调研查询资源问卷详情
  activityQuestionnaireDetail(
      int activityPackageId, int questionnaireId, int resourceId,
      {int activityTaskId}) async {
    var params = {};
    params["activityPackageId"] = activityPackageId;
    params["questionnaireId"] = questionnaireId;
    params["resourceId"] = resourceId;
    if (activityTaskId != null) {
      params["activityTaskId"] = activityTaskId;
    }
    return await normalPost(
      "/activity-task/questionnaire/detail",
      params: params,
    );
  }
  
  /// 讲课资料查询
  lectureResourceQuery(int activityPackageId) async {
    return await normalPost("/lecture-resource/query",params: {"activityPackageId":"$activityPackageId"});
  }

  activityVideoLectureDetail(
      int activityPackageId) async {
    var params = {};
    params["activityTaskId"] = activityPackageId;
    return await normalPost(
      "/activity-task/lecture-video/detaill",
      params: params,
    );
  }

  doctorLectureSharePic(int activityTaskId) {
    return normalPost('/doctor-lecture/share-pic',params:{'lectureId':activityTaskId});
  }

  saveVideo(dynamic params) async{
    return await normalPost("/activity-task/lecture-video/save-or-update",params: params);
  }
}
