import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/qualification/model/doctor_detail_info_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

HttpManager uCenter = HttpManager('ucenter');

class DoctorQualificationViewModel {
  StreamController<DoctorQualificationModel> _controller =
      StreamController<DoctorQualificationModel>();
  DoctorQualificationModel _dataModel = DoctorQualificationModel();

  get stream => _controller.stream;

  /// 查询当前登陆的医生信息，token 参数由 http 请求统一提供。接口地址：
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/1703
  _obtainDoctorInfo() async {
    var doctorInfo =
        await uCenter.post('/personal/query-doctor-detail', showLoading: false);
    print('doctor info  -> $doctorInfo');
    _dataModel = DoctorQualificationModel();
    if (doctorInfo is Exception) {
      _controller.sink.add(_dataModel);
      _dataModel.doctorDetailInfo = DoctorDetailInfoEntity.create();
    } else {
      _dataModel.doctorDetailInfo = DoctorDetailInfoEntity.fromJson(doctorInfo);
      _controller.sink.add(_dataModel);
    }
  }

  _modifyDoctorInfo(Map<String, dynamic> param) async {
    return await uCenter.post('/personal/edit-doctor-info', params: param);
  }

  refresh() {
    try {
      _obtainDoctorInfo();
    } on Exception {
      _controller.sink.addError('获取数据错误');
    }
  }

  dispose() {
    if (_controller != null && !_controller.isClosed) {
      _controller.close();
    }
  }

  submitBasicInfo() {
    if (!validateBasicInfo()) {
      return;
    }

    _modifyDoctorInfo(_dataModel.doctorDetailInfo.toJson());
    // TODO 接口联调完成，修改用户信息成功后，后期细节处理
  }

  bool validateBasicInfo({bool needShowMsg = true}) {
    if (_dataModel.doctorDetailInfo?.doctorName == null ||
        _dataModel.doctorDetailInfo.doctorName.isEmpty) {
      _showToastMessageIfNeeded("请输入姓名", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.sex == null) {
      _showToastMessageIfNeeded("请选择性别", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.hospitalName == null ||
        _dataModel.doctorDetailInfo.hospitalName.isEmpty) {
      _showToastMessageIfNeeded("请选择所在医院", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.departmentsName == null ||
        _dataModel.doctorDetailInfo.departmentsName.isEmpty) {
      _showToastMessageIfNeeded("请选择所在科室", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.jobGradeName == null ||
        _dataModel.doctorDetailInfo.jobGradeName.isEmpty) {
      _showToastMessageIfNeeded("请选择职称", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.practiceDepartmentName == null ||
        _dataModel.doctorDetailInfo.practiceDepartmentName.isEmpty) {
      _showToastMessageIfNeeded("请选择医学术执业科室", needShowMsg);
      return false;
    }

    return true;
  }

  _showToastMessageIfNeeded(String msg, bool needShowMsg) {
    if (needShowMsg) {
      EasyLoading.showToast(msg);
    }
  }

  void changeDataNotify() {
    _controller.sink.add(_dataModel);
    print(_dataModel.doctorDetailInfo.toJson());
  }
}
