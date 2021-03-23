import 'package:http_manager/manager.dart';
import 'host.dart';

extension dtpAPI on API {
  Dtp get dtp => Dtp();
}

class Dtp extends SubAPI {
  String get middle =>
      "/medclouds-dtp/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  favoriteList(int page, {int ps = 10}) async =>
      await normalPost("/favorite/list", params: {'pn': page, 'ps': ps});

  loadPatientPrescriptionList(params) async =>
      await normalPost('/patient/prescription/list', params: params);

  bindPrescriptionService(params) async =>
      await normalPost('/patient-prescription-bind', params: params);

  postList(params) async => await normalPost("/post/list", params: params);

  postQuery(params) async => await normalPost('/post/query', params: params);

  postFavorite(params) async =>
      await normalPost('/post/favorite', params: params);

  postLike(params) async =>
      await normalPost('/like/post-or-comment', params: params);

  postComment(params) async =>
      await normalPost('/comment/add-comment', params: params);

  drugList(params) async => await normalPost("/drug/list",params: params);

  drugQuery(params) async => await normalPost("/drug/query",params: params);

  /// 新增处方
  Future addPrescription(params) async {
    return await normalPost('/prescription/add', params: params);
  }

  /// 修改处方
  Future updatePrescriptionServive(params) async {
    return await normalPost('/prescription/update', params: params);
  }

  /// 处方记录列表
  Future loadPrescriptionList(params) async {
    return await normalPost('/prescription/list', params: params);
  }

  /// 处方详情
  Future loadPrescriptionDetail(params) async {
    return await normalPost('/prescription/query', params: params);
  }

  /// 患者最近的一个处方
  Future loadPrescriptionByPatient(params) async {
    return await normalPost('/patient/prescription/lately-one', params: params);
  }

  /// 处方模板列表
  Future loadPrescriptionTemplateList(params) async {
    return await normalPost('/prescription-template/list', params: params);
  }

  /// 新增处方模板
  Future addPrescriptionTemplate(params) async {
    return await normalPost('/prescription-template/add', params: params);
  }
  /// 编辑处方模板
  Future modifyPrescriptionTemplate(params) async {
    return await normalPost('/prescription-template/edit', params: params);
  }

  /// 处方绑定校验
  Future<bool> checkPrescriptionBeforeBind(String prescriptionNo) async {
    try {
      await normalPost('/patient-prescription-check', params: {
        'prescriptionNo': prescriptionNo,
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
