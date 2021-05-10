/// 病例收集
const String TYPE_CASE_COLLECTION = "CASE_COLLECTION";

/// 医学调研
const String TYPE_MEDICAL_SURVEY = "MEDICAL_SURVEY";

/// 未开始
const String STATUS_WAIT = "WAIT_START";

/// 进行中
const String STATUS_EXECUTING = "EXECUTING";
// 已结束
const String STATUS_FINISH = "END";

String activityName(String type) {
  return type == TYPE_CASE_COLLECTION ? '病例征集' : '医学调研';
}

String activityStatus(String status) {
  switch (status) {
    case STATUS_WAIT:
      return '未开始';
    case STATUS_EXECUTING:
      return '进行中';
    case STATUS_FINISH:
      return '结束';
  }
  return '';
}