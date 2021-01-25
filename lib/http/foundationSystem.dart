import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'host.dart';

extension foundationAPI on API {
  FoundationSys get foundationSys => FoundationSys();
}

class FoundationSys extends SubAPI {

  String get middle =>
      "/medclouds-foundation/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  messageUnredTypeCount() async => normalPost('/message/unread-type-count');

  messageListByType(params) async => normalPost('/message/list-by-type',params: params);

  messageUpdateStatus(params) async => normalPost('/message/update-status',params: params);
  messageLikeList(params) async => normalPost('/message/like-list',params: params);
  messageCommentList(params) async => normalPost('/message/comment-list',params: params);
  /// 一周小结
  Future<dynamic> messageDoctorConclusion() async => normalPost('/message/news-doctor-work-conclusion');
  getBanner(params) async => normalPost("mobile/banner/list", params: params);
}