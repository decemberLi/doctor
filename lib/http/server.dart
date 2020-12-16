import 'package:http_manager/manager.dart';
import 'host.dart';

extension serverAPI on API {
  Server get server => Server();
}

class Server extends SubAPI {

  String get middle =>
      "/medclouds-server/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  favoriteList(int page, {int ps = 10}) async =>
      await normalPost("/favorite/list", params: {'pn': page, 'ps': ps});

  getPlanCount(parmas) async => await normalPost(
        "/learn-plan/status-count",
        params: parmas,
      );

  /// 上传反馈信息
  feedbackService(params) {
    return normalPost(
      '/learn-resource/feedback',
      params: params,
    );
  }

  /// 上传讲课视频
  addLectureSubmit(params) {
    return normalPost(
      '/doctor-lecture/submit',
      params: params,
    );
  }

}
