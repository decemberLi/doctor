const NAME = 'DOCTOR';

const APP_NAME = '易学术';

const SESSION_KEY = '$NAME-ticket';
const LAST_PHONE = '$NAME-last-phone';
const KEY_DOCTOR_ID_MODIFIED_PWD = '$NAME-key_doctor_id_modified_pwd';

const LOGIN_INFO = '$NAME-login-info';

const ONLY_WIFI = 'only_wifi';
const KEY_UPDATE_USER_INFO = 'update_user_info';

/// 任务类型
const Map<String, String> TASK_TEMPLATE = {
  'SALON': '会议',
  'DEPART': '会议',
  'SURVEY': '调研',
  'DOCTOR_LECTURE': '讲课邀请',
  'VISIT': '拜访',
  'MEDICAL_SURVEY':'医学调研',
};

// 资源类型
const Map<String, String> MAP_RESOURCE_TYPE = {
  'ARTICLE': '文章',
  'VIDEO': '视频',
  'QUESTIONNAIRE': '问卷',
  'MEDICAL_TEMPLATE':'问卷',
};

const TASK_TYPE_MAP = [
  {
    'text': '全部',
    'taskTemplate': [],
  },
  {
    'text': '会议',
    'taskTemplate': ['SALON', 'DEPART'],
  },
  {
    'text': '拜访',
    'taskTemplate': ['VISIT', 'DOCTOR_LECTURE'],
  },
  {
    'text': '调研',
    'taskTemplate': ['SURVEY'],
  },
];

/// 药品用药频率列表
const List<String> FREQUENCY_LIST = [
  '每日一次',
  '每日两次',
  '每日三次',
  '每日四次',
  '隔日一次',
  '每周一次',
  '每周两次',
  '每周三次',
  '隔周一次',
  '每两周一次',
  '每三周一次',
  '每四周一次',
  '30分钟一次',
  '每小时一次',
  '每两小时一次',
  '每三小时一次',
  '每四小时一次',
  '六小时一次',
  '八小时一次',
  '12小时一次',
  '必要时',
  '禁忌时',
];

/// 药品剂量列表
const List<String> DOSEUNIT_LIST = [
  '片/次',
  '粒/次',
  '袋/次',
  '支/次',
  '丸/次',
  '贴/次',
  '吸/次',
  '滴/次',
  '揿/次',
  'ml/次',
  'mg/次',
  'g/次',
  'ug/次',
  '适量/次',
  '微克',
  '枚',
  '盒',
  '国际单位',
  '单位',
  '万单位',
  '万IU',
];

/// 药品用药方式列表
const List<String> USEPATTERN_LIST = [
  '口服',
  '含服',
  '舌下',
  '外用',
  '喷鼻',
  '口腔吸入',
  '直肠给药',
  '滴眼',
  '滴鼻',
  '滴耳',
  '阴道给药',
  '静脉推注',
  '静脉滴注',
  '肌肉注射',
  '皮下注射',
  '餐中服',
  '眼内注射',
  '喷于患处',
  '涂于眼睑内',
  '涂于患处',
  '含漱',
  '雾化吸入',
  '宫腔内给药',
  '敷于患处',
];
