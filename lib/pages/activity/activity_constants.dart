/// 病例收集
const String TYPE_CASE_COLLECTION = "CASE_COLLECTION";

/// 医学调研
const String TYPE_MEDICAL_SURVEY = "MEDICAL_SURVEY";
const String TYPE_RWS = "RWS";

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
  if (type == TYPE_RWS) {
    return 'RWS';
  }
  if (type == TYPE_CASE_COLLECTION) {
    return '病例征集';
  }
  if (type == TYPE_MEDICAL_SURVEY) {
    return '医学调研';
  }
  return '';
}

String activityStatus(String status, bool disable) {
  if(disable){
    return '已结束';
  }
  switch (status) {
    case STATUS_WAIT:
      return '未开始';
    case STATUS_EXECUTING:
      return '进行中';
    case STATUS_FINISH:
      return '已结束';
  }
  return '';
}
