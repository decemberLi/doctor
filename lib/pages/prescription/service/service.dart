import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('dtp');
HttpManager httpFoundation = HttpManager('foundation');
HttpManager foundationWeb = HttpManager('foundationWeb');

/// 新增处方
Future addPrescription(params) async {
  return await http.post('/prescription/add', params: params);
}

/// 修改处方
Future updatePrescriptionServive(params) async {
  return await http.post('/prescription/update', params: params);
}

/// 处方记录列表
Future loadPrescriptionList(params) async {
  return await http.post('/prescription/list', params: params);
}

/// 处方详情
Future loadPrescriptionDetail(params) async {
  return await http.post('/prescription/query', params: params);
}

/// 处方模板列表
Future loadPrescriptionTemplateList(params) async {
  return await http.post('/prescription-template/list', params: params);
}

/// 新增处方模板
Future addPrescriptionTemplate(params) async {
  return await http.post('/prescription-template/add', params: params);
}

/// 处方绑定校验
Future checkPrescriptionBeforeBind(String prescriptionNo) async {
  try {
    await http.post('/patient-prescription-check', params: {
      'prescriptionNo': prescriptionNo,
    });
    return true;
  } catch (e) {
    return false;
  }
}

/// 获取绑定二维码
Future<String> loadBindQRCode(String prescriptionNo) async {
  try {
    var res = await foundationWeb.post(
      '/wechat-accounts/temp-qr-code',
      params: {
        'bizType': 'PRESCRIPTION_BIND',
        'bizId': prescriptionNo,
      },
      ignoreErrorTips: true,
      showLoading: false,
    );
    return res['qrCodeUrl'];
  } catch (e) {
    return null;
  }
}
