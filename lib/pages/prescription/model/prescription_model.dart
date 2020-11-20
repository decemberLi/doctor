import 'package:common_utils/common_utils.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prescription_model.g.dart';

Map statusMap = {
  'WAIT_VERIFY': '审核中',
  'PASS': '已审核',
  'REJECT': '审核未通过',
  'EXPIRE': '已过期',
};

/// 处方model
@JsonSerializable(explicitToJson: true)
class PrescriptionModel {
  /// 处方id
  int id;

  /// 处方患者姓名
  String prescriptionPatientName;

  /// 处方单号
  String prescriptionNo;

  /// 驳回理由
  String reason;

  /// 处方患者年龄
  int prescriptionPatientAge;

  /// 处方患者性别（0-女，1-男）
  // @JsonKey(defaultValue: 1)
  int prescriptionPatientSex;

  String get prescriptionPatientSexLabel =>
      prescriptionPatientSex == 1 ? '男' : '女';

  /// 临床诊断
  String clinicalDiagnosis;

  /// 药师签名（URL，是一张图片）
  String pharmacist;

  /// 是否复诊患者（0-不是，1-是复诊患者）
  @JsonKey(defaultValue: true)
  bool furtherConsultation;

  /// 状态(药师审核：WAIT_VERIFY-待审核、PASS-通过，REJECT-驳回）
  String status;
  String get statusText => statusMap[status] ?? '';

  /// 订单状态（DONE 已取药、CANCEL 取消）
  String orderStatus;

  String get orderStatusImage =>
      orderStatus == 'DONE' ? 'order_status_done.png' : 'order_status_none.png';

  /// 处方药品信息
  List<DrugModel> drugRps;

  /// 创建时间
  num createTime;

  String get createTimeText => createTime != null
      ? DateUtil.formatDateMs(createTime, format: 'yyyy.MM.dd HH:mm')
      : '';

  /// 处方过期时间
  num expireTime;

  String get expireTimeText => expireTime != null
      ? DateUtil.formatDateMs(expireTime, format: 'yyyy.MM.dd HH:mm')
      : '';

  /// 处方纸质图片附件信息
  List<OssFileEntity> attachments;

  /// 医生姓名
  String doctorName;

  /// 科室
  String depart;

  /// 审核人(药师)id
  num auditorId;

  /// 审核人名称
  String auditor;

  /// 审核时间
  num auditTime;
  String get auditTimeText => auditTime != null
      ? DateUtil.formatDateMs(auditTime, format: 'yyyy.MM.dd HH:mm')
      : '';

  int weight;

  String doctorSignatureUrl;

  PrescriptionModel({
    this.id,
    this.prescriptionPatientName,
    this.prescriptionNo,
    this.reason,
    this.prescriptionPatientAge,
    this.prescriptionPatientSex,
    this.clinicalDiagnosis,
    this.pharmacist,
    this.furtherConsultation = true,
    this.status,
    this.orderStatus,
    this.drugRps = const <DrugModel>[],
    this.createTime,
    this.attachments,
    this.weight,
    this.doctorSignatureUrl,
  });
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionModelToJson(this);
}
