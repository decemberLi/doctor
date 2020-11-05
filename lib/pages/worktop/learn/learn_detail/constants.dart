import 'package:common_utils/common_utils.dart';
import 'package:doctor/utils/constants.dart';

defaultFormatDate(int value) =>
    DateUtil.formatDateMs(value, format: 'yyyy年MM月dd日');
formatDateDay(int value) => DateUtil.formatDateMs(value, format: 'yyyy年MM月dd日');

taskTemplateFormat(String value) => TASK_TEMPLATE[value];

const taskTemplate = {
  'field': 'taskTemplate',
  'label': '学习计划类型',
  'format': taskTemplateFormat,
};
const taskName = {
  'field': 'taskName',
  'label': '学习计划名称',
  'notCollapse': true,
};
const companyName = {
  'field': 'companyName',
  'label': '来自企业',
};
const representName = {
  'field': 'representName',
  'label': '医学信息推广专员',
};
const createTime = {
  'field': 'createTime',
  'label': '收到学习计划日期',
  'format': defaultFormatDate,
};
const planImplementEndTime = {
  'field': 'meetingStartTime',
  'label': '截止日期',
  'format': formatDateDay,
};
const meetingStartTime = {
  'field': 'meetingStartTime',
  'label': '会议开始时间',
  'format': defaultFormatDate,
};

const meetingEndTime = {
  'field': 'meetingEndTime',
  'label': '结束时间',
  'format': defaultFormatDate,
};

const SALON = [
  taskName,
  taskTemplate,
  companyName,
  representName,
  createTime,
  planImplementEndTime,
  meetingStartTime,
  meetingEndTime,
];

const VISIT = [
  taskName,
  taskTemplate,
  companyName,
  representName,
  createTime,
  planImplementEndTime,
];

const SURVEY = [
  taskName,
  taskTemplate,
  companyName,
  representName,
  createTime,
  planImplementEndTime,
];

const DOCTOR_LECTURE = [
  taskName,
  taskTemplate,
  companyName,
  representName,
  createTime,
  planImplementEndTime,
];

// 学习计划列表显示字段
const Map<String, List<Map>> LEARN_LIST = {
  'SALON': SALON,
  'DEPART': SALON,
  'VISIT': VISIT,
  'SURVEY': VISIT,
  'DOCTOR_LECTURE': DOCTOR_LECTURE,
};
