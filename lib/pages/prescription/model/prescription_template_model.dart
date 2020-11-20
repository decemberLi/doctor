import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prescription_template_model.g.dart';

const String CLINICAL_DIAGNOSIS_SPLIT_MARK = ',';

/// 药品model
@JsonSerializable(explicitToJson: true)
class PrescriptionTemplateModel {
  num id;

  /// 处方模板名称
  String prescriptionTemplateName;

  /// 临床诊断
  String clinicalDiagnosis;

  /// 处方药品信息
  List<DrugModel> drugRps;

  PrescriptionTemplateModel({
    this.id,
    this.prescriptionTemplateName,
    this.clinicalDiagnosis,
    this.drugRps = const <DrugModel>[],
  });
  factory PrescriptionTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionTemplateModelToJson(this);

  // 临时方案
  List<String> get clinicaList =>
      this.clinicalDiagnosis?.split(CLINICAL_DIAGNOSIS_SPLIT_MARK) ?? [];

  set clinicaList(List<String> value) {
    if (value.isEmpty) {
      this.clinicalDiagnosis = null;
    } else {
      this.clinicalDiagnosis = value.join(CLINICAL_DIAGNOSIS_SPLIT_MARK);
    }
  }

  /// 新增临床诊断
  addClinica(String value) {
    List<String> list = this.clinicaList;
    list.add(value);
    this.clinicalDiagnosis = list.join(CLINICAL_DIAGNOSIS_SPLIT_MARK);
  }

  /// 删除临床诊断
  removeClinica(int index) {
    List<String> list = this.clinicaList;
    list.removeAt(index);
    this.clinicaList = list;
  }

}
