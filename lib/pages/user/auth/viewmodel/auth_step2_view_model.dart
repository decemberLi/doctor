import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/model/face_photo.dart';
import 'package:doctor/model/uploaded_file_entity.dart';
import 'package:doctor/pages/user/auth/entity/auth_qualification.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/utils/upload_file_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_manager/api.dart';

class AuthenticationStep2ViewModel extends ViewStateModel {
  AutQualificationEntity _data = AutQualificationEntity();

  AutQualificationEntity get data => _data;

  var _isCommitting = false;

  bool get isCommitting => _isCommitting;

  void setIsCommitting(bool commit) {
    _isCommitting = commit;
  }

  get canNext => (_data.qualifications?.length ?? 0) != 0;

  void addImage(File path, FacePhoto value, int index) async {
    UploadFileEntity entity = await uploadImageToOss(path.path);

    if (_data.qualifications == null) {
      _data.qualifications = [];
    }
    FacePhoto img;
    if (value == null) {
      // Add image
      img = FacePhoto.create();
    } else {
      if (index < _data.qualifications.length) {
        img = _data.qualifications[index];
      }
    }
    img.url = entity.url;
    img.name = entity.ossFileName;
    img.ossId = entity.ossId;
    _data.qualifications.add(img);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index < _data.qualifications?.length) {
      _data.qualifications.removeAt(index);
      notifyListeners();
    }
  }

  Future commitAuthenticationData() async {
    return API.shared.ucenter.postAuthData(data.toJson());
  }

  void refreshData() async {
    var result = await API.shared.ucenter.queryDoctorVerifyInfo();
    if (result is DioError) {
      return;
    }
    _data = AutQualificationEntity.fromJson(result);
    debugPrint('已提交过认证信息，被驳回： -> ${data?.toJson()}');
    notifyListeners();
  }
}
