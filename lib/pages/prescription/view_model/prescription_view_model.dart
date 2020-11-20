import 'package:common_utils/common_utils.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/utils/app_regex_util.dart';
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
        (previousValue, drugModel) => NumUtil.add(
          previousValue,
          NumUtil.multiply(
            drugModel.drugPrice ?? 0,
            drugModel.quantity ?? 0,
          ),
        ),
      ) ??
      0;

  List<String> get clinicaList =>
      this.data.clinicalDiagnosis?.split(CLINICAL_DIAGNOSIS_SPLIT_MARK) ?? [];

  set clinicaList(List<String> value) {
    if (value.isEmpty) {
      this.data.clinicalDiagnosis = null;
    } else {
      this.data.clinicalDiagnosis = value.join(CLINICAL_DIAGNOSIS_SPLIT_MARK);
    }
  }

  /// 新增临床诊断
  addClinica(String value) {
    List<String> list = this.clinicaList;
    list.add(value);
    this.data.clinicalDiagnosis = list.join(CLINICAL_DIAGNOSIS_SPLIT_MARK);
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
    if (data.prescriptionPatientName.length < 2 ||
        data.prescriptionPatientName.length > 6) {
      EasyLoading.showToast('姓名需要在2-6字');
      return false;
    }
    if (this.data.prescriptionPatientAge == null ||
        this.data.prescriptionPatientAge < 1) {
      EasyLoading.showToast('请输入年龄');
      return false;
    }
    if (this.data.prescriptionPatientAge < 1 ||
        this.data.prescriptionPatientAge > 120) {
      EasyLoading.showToast('年龄需要在0-120岁');
      return false;
    }
    if (!AppRegexUtil.isPositiveInteger(
        this.data.prescriptionPatientAge.toString())) {
      EasyLoading.showToast('年龄不能有小数');
      return false;
    }
    if (this.data.prescriptionPatientSex == null) {
      EasyLoading.showToast('请选择性别');
      return false;
    }
    if (this.data.prescriptionPatientAge > 14) {
      this.data.weight = null;
    } else {
      if (this.data.weight == null) {
        EasyLoading.showToast('体重不能为空');
        return false;
      }
      if (this.data.weight > 999) {
        EasyLoading.showToast('体重不能超过999kg');
        return false;
      }
      if (this.data.weight <= 0) {
        EasyLoading.showToast('体重不能为0kg哦');
        return false;
      }
    }
    if (this.data.clinicalDiagnosis == null ||
        this.data.clinicalDiagnosis.isEmpty) {
      EasyLoading.showToast('请添加临床诊断');
      return false;
    }
    if (this.data.drugRps == null || this.data.drugRps.isEmpty) {
      EasyLoading.showToast('请添加药品信息');
      return false;
    }
    if (this.data.attachments == null || this.data.attachments.isEmpty) {
      EasyLoading.showToast('请上传纸质处方图片');
      return false;
    }
    return true;
  }

  getDataByPatient(patientUserId) async {
    var res = await loadPrescriptionByPatient({'patientUserId': patientUserId});

    PrescriptionModel data = PrescriptionModel.fromJson(res);
    this.setData(data, isNew: true);
  }

  echoByHistoryPatient(PrescriptionModel model) {
    if (model != null && model.drugRps != null) {
      // filter
      model.drugRps.removeWhere((element) => element.disable ?? false);
      for (var each in model.drugRps) {
        if (each.quantity < each.purchaseLimit) {
          each.quantity = each.purchaseLimit;
        }
      }
    }
    this.setData(model, isNew: true);
  }

  resetData() {
    this.data = PrescriptionModel();
    this.changeDataNotify();
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
      this.data.createTime = null;
      this.data.status = null;
      this.data.auditTime = null;
      this.data.auditor = null;
      this.data.auditorId = null;
      this.data.doctorName = null;
      this.data.expireTime = null;
      this.data.id = null;
      this.data.orderStatus = null;
      this.data.reason = null;
      this.data.pharmacist = null;
      // 纸质处方重新设置
      this.data.attachments = [
        // OssFileEntity(
        //   ossId: '20201026A37A3BC727384B7C995382481D8B79B0',
        //   name: '测试',
        //   type: 'PRESCRIPTION_PAPER',
        // )
      ];
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
    if (callBack != null) {
      callBack(prescriptionNo);
    }
  }

  updatePrescription(Function callBack) async {
    if (!this.validateData()) {
      return;
    }
    try {
      var params = this.data.toJson();
      await updatePrescriptionServive(params);
      this.data = new PrescriptionModel();
      notifyListeners();
      EasyLoading.showToast('修改成功');
      if (callBack != null) {
        callBack();
      }
    } catch (e) {}
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方记录viewModel
class PrescriptionListViewModel extends ViewStateRefreshListModel {
  String _queryKey;

  set queryKey(String value) {
    _queryKey = value;
  }

  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    var list = await loadPrescriptionList(
        {'ps': 10, 'pn': pageNum, 'queryKey': _queryKey});
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
