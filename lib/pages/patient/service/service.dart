import 'package:doctor/http/http_manager.dart';

HttpManager http = HttpManager('dtp');
HttpManager ucenter = HttpManager('ucenter');

/// 患者列表
Future loadPatientList(params) async {
  return await ucenter.post('/patient/list', params: params);
}

/// 患者列表
Future loadPatientDetailService(int patientUserId) async {
  return await ucenter.post('/patient/detail', params: {
    'patientUserId': patientUserId,
  });
}

/// 患者的处方列表
Future loadPatientPrescriptionList(params) async {
  return await http.post('/patient/prescription/list', params: params);
}

/// 绑定处方
Future bindPrescriptionService(params) async {
  return await http.post('/patient-prescription-bind', params: params);
}
