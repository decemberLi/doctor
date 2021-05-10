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

/// 审核状态(WAIT_VERIFY-待审核，VERIFIED-已审核通过，REJECT-驳回)
const String VERIFY_STATUS_WAIT = 'WAIT_VERIFY';
/// 已审核通过
const String VERIFY_STATUS_VERIFIED = 'VERIFIED';
/// 驳回
const String VERIFY_STATUS_REJECT = 'REJECT';


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
