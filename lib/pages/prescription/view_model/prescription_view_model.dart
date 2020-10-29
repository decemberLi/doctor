import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 开处方主页面viewModel
class PrescriptionViewModel extends ViewStateModel {
  PrescriptionModel data = PrescriptionModel();
  // PrescriptionModel data = PrescriptionModel(attachments: [
  //   OssFileEntity(
  //     ossId: '20201026A37A3BC727384B7C995382481D8B79B0',
  //     name: '测试',
  //     type: 'PRESCRIPTION_PAPER',
  //   )
  // ]);

  PrescriptionViewModel();

  Future<String> get prescriptionQRCode async {
    String qrCodeUrl = await loadBindQRCode(data.prescriptionNo);
    return qrCodeUrl;
  }

  /// 总价
  double get totalPrice =>
      data.drugRps?.fold(
        0,
        (previousValue, element) => previousValue + (element?.drugPrice ?? 0),
      ) ??
      0;

  List<String> get clinicaList => this.data.clinicalDiagnosis?.split(',') ?? [];

  set clinicaList(List<String> value) {
    if (value.isEmpty) {
      this.data.clinicalDiagnosis = null;
    } else {
      this.data.clinicalDiagnosis = value.join(',');
    }
  }

  /// 新增临床诊断
  addClinica(String value) {
    List<String> list = this.clinicaList;
    list.add(value);
    this.data.clinicalDiagnosis = list.join(',');
    notifyListeners();
  }

  /// 删除临床诊断
  removeClinica(int index) {
    List<String> list = this.clinicaList;
    list.removeAt(index);
    this.clinicaList = list;
    notifyListeners();
  }

  addByTemplate(PrescriptionTemplateModel data) {
    this.data.clinicalDiagnosis = data.clinicalDiagnosis;
    this.data.drugRps = data.drugRps;
    notifyListeners();
  }

  bool validateData() {
    if (this.data.prescriptionPatientName == null ||
        this.data.prescriptionPatientName.isEmpty) {
      EasyLoading.showToast('请输入姓名');
      return false;
    }
    if (this.data.prescriptionPatientAge == null ||
        this.data.prescriptionPatientAge < 1) {
      EasyLoading.showToast('请输入年龄');
      return false;
    }
    if (this.data.clinicalDiagnosis == null ||
        this.data.clinicalDiagnosis.isEmpty) {
      EasyLoading.showToast('请添加临床诊断');
      return false;
    }
    if (this.data.drugRps == null || this.data.drugRps.isEmpty) {
      EasyLoading.showToast('请添加药品');
      return false;
    }
    if (this.data.attachments == null || this.data.attachments.isEmpty) {
      EasyLoading.showToast('请上传纸质处方图片');
      return false;
    }
    return true;
  }

  /// 重新设置开处方数据
  setData(
    PrescriptionModel newData, {
    bool isNew = false,
    VoidCallback callBack,
  }) {
    this.data = newData;
    if (isNew) {
      this.data.prescriptionNo = null;
      // 纸质处方重新设置
      this.data.attachments = [];
    }
    notifyListeners();
    if (callBack != null) {
      callBack();
    }
  }

  savePrescription(Function callBack) async {
    if (!this.validateData()) {
      return;
    }
    this.data.prescriptionNo = null;
    var params = this.data.toJson();
    var res = await addPrescription(params);
    String prescriptionNo = res['prescriptionNo'];
    // this.data = new PrescriptionModel();
    notifyListeners();
    if (callBack != null) {
      callBack(prescriptionNo);
    }
  }

  updatePrescription() async {
    if (!this.validateData()) {
      return;
    }
    try {
      var params = this.data.toJson();
      await updatePrescriptionServive(params);
      this.data = new PrescriptionModel();
      notifyListeners();
      EasyLoading.showToast('修改成功');
    } catch (e) {}
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方记录viewModel
class PrescriptionListViewModel extends ViewStateRefreshListModel {
  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    var list = await loadPrescriptionList({
      'ps': 10,
      'pn': pageNum,
    });
    return list['records']
        .map<PrescriptionModel>((item) => PrescriptionModel.fromJson(item))
        .toList();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方详情viewModel
class PrescriptionDetailModel extends ViewStateModel {
  final String prescriptionNo;
  PrescriptionModel data;

  PrescriptionDetailModel(this.prescriptionNo);

  initData() async {
    setBusy();
    data = await loadData();
    setIdle();
  }

  /// 获取处方详情
  Future<PrescriptionModel> loadData() async {
    var res = await loadPrescriptionDetail({
      'prescriptionNo': this.prescriptionNo,
    });
    PrescriptionModel data = PrescriptionModel.fromJson(res);
    // data.status = 'REJECT';
    // data.reason = '不给过';
    return data;
  }
}
