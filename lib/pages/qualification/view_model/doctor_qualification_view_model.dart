import 'dart:async';

import 'package:doctor/http/foundation.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/qualification/model/config_data_entity.dart';
import 'package:doctor/pages/qualification/model/doctor_qualification_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';

class DoctorQualificationViewModel {
  StreamController<DoctorQualificationModel> _controller =
      StreamController<DoctorQualificationModel>();
  final DoctorQualificationModel _dataModel = DoctorQualificationModel();

  get stream => _controller.stream;

  void setHospital(HospitalEntity entity) {
    _dataModel.hospitalEntity =
        _dataModel.hospitalEntity ?? HospitalEntity.create();
    _dataModel.doctorDetailInfo.hospitalCode = entity.hospitalCode;
    _dataModel.doctorDetailInfo.hospitalName = entity.hospitalName;
  }

  void setDepartment(ConfigDataEntity entity) {
    _dataModel.hospitalEntity =
        _dataModel.hospitalEntity ?? HospitalEntity.create();
    _dataModel.doctorDetailInfo.departmentsCode = entity.code;
    _dataModel.doctorDetailInfo.departmentsName = entity.name;
  }

  void setJobGrade(ConfigDataEntity entity) {
    _dataModel.hospitalEntity =
        _dataModel.hospitalEntity ?? HospitalEntity.create();
    _dataModel.doctorDetailInfo.jobGradeCode = entity.code;
    _dataModel.doctorDetailInfo.jobGradeName = entity.name;
  }

  void setPracticeDepartment(ConfigDataEntity entity) {
    _dataModel.hospitalEntity =
        _dataModel.hospitalEntity ?? HospitalEntity.create();
    _dataModel.doctorDetailInfo.practiceDepartmentCode = entity.code;
    _dataModel.doctorDetailInfo.practiceDepartmentName = entity.name;
  }

  queryHospital(String hospitalName) async {
    var result = await API.shared.foundation.hospitalKeyQueryPage({'hospitalName': hospitalName, 'pn': 1, 'ps': 100});
    return result['records']
        .map<HospitalEntity>((each) => HospitalEntity.fromJson(each))
        .toList();
  }

  queryConfig(String type) async {
    Map<String, dynamic> param = {};
    param['type'] = type;
    var result = await API.shared.foundation.getSelectInfo(param);
    return result
        .map<ConfigDataEntity>((each) => ConfigDataEntity.fromJson(each))
        .toList();
  }

  /// ????????????????????????????????????token ????????? http ????????????????????????????????????
  /// http://yapi.e-medclouds.com:3000/project/7/interface/api/5025
  _obtainDoctorInfo() async {
    try {
      var doctorInfo =
      await API.shared.ucenter.queryDoctorDetailInfo();
      _dataModel.doctorDetailInfo = doctorInfo;
      _controller.sink.add(_dataModel);
    }catch(e){
      _controller.sink.add(_dataModel);
      _dataModel.doctorDetailInfo = DoctorDetailInfoEntity.create();
    }
  }

  _modifyDoctorInfo(Map<String, dynamic> param) async {
    return await API.shared.ucenter.editDoctorInfo(param);
  }

  refresh() {
    try {
      _obtainDoctorInfo();
    } on Exception {
      _controller.sink.addError('??????????????????');
    }
  }

  dispose() {
    if (_controller != null && !_controller.isClosed) {
      _controller.close();
    }
  }

  submitBasicInfo() async {
    if (!validateBasicInfo()) {
      return;
    }

    await _modifyDoctorInfo(_dataModel.doctorDetailInfo.toJson());
    EasyLoading.showToast('??????????????????');
  }

  bool validateBasicInfo({bool needShowMsg = true}) {
    if (_dataModel.doctorDetailInfo?.doctorName == null ||
        _dataModel.doctorDetailInfo.doctorName.isEmpty) {
      _showToastMessageIfNeeded("???????????????", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.sex == null) {
      _showToastMessageIfNeeded("???????????????", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.hospitalName == null ||
        _dataModel.doctorDetailInfo.hospitalName.isEmpty) {
      _showToastMessageIfNeeded("?????????????????????", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.departmentsName == null ||
        _dataModel.doctorDetailInfo.departmentsName.isEmpty) {
      _showToastMessageIfNeeded("?????????????????????", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.jobGradeName == null ||
        _dataModel.doctorDetailInfo.jobGradeName.isEmpty) {
      _showToastMessageIfNeeded("???????????????", needShowMsg);
      return false;
    }
    if (_dataModel.doctorDetailInfo.practiceDepartmentName == null ||
        _dataModel.doctorDetailInfo.practiceDepartmentName.isEmpty) {
      _showToastMessageIfNeeded("??????????????????????????????", needShowMsg);
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
