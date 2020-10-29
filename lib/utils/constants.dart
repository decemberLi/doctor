const NAME = 'DOCTOR';

const APP_NAME = '易学术';

const SESSION_KEY = '$NAME-ticket';
const LAST_PHONE = '$NAME-last-phone';

const LOGIN_INFO = '$NAME-login-info';

/// 任务类型
const Map<String, String> TASK_TEMPLATE = {
  'SALON': '会议',
  'DEPART': '会议',
  'SURVEY': '调研',
  'DOCTOR_LECTURE': '讲课邀请',
  'VISIT': '拜访'
};

// 资源类型
const Map<String, String> MAP_RESOURCE_TYPE = {
  'ARTICLE': '文章',
  'VIDEO': '视频',
  'QUESTIONNAIRE': '问卷',
};
