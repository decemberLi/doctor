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

  resourceDetail(params) async => normalPost('/resource/detail',params: params);

  favoriteDetail(params) async => normalPost('/favorite/detail',params: params);
  // 发表评论
  sendComment(params) async{
    print(params);
    return normalPost(
      '/comment/add',
      params: params,
    );
  }
  doctorLectureDetail(params) async => normalPost('/doctor-lecture/detail',params: params);

  /// 提交学习计划
  Future learnSubmit(params) async {
    return await normalPost('/learn-plan/submit', params: params);
  }

// 提交问卷
  submitQuestion(params) {
    print('调用接口$params');
    return normalPost(
      '/submit/question',
      params: params,
    );
  }

// 获取评论
  getCommentNum(params) {
    return normalPost(
      '/comment/num',
      params: params,
    );
  }

// 收藏
  getFavoriteStatus(params) {
    return normalPost(
      '/favorite/exists',
      params: params,
    );
  }

// 设置收藏
  setFavoriteStatus(params) {
    return normalPost(
      '/favorite/add-or-cancel',
      params: params,
    );
  }

// 上传学习时间
  updateLearnTime(params) {
    print('调用接口$params');
    return normalPost(
      '/learn-resource/learn-time-submit',
      params: params,
    );
  }

// 会议签到
  meetingSign(params) {
    return normalPost('/meeting/sign-in', params: params);
  }

  learnPlanList(params) async => normalPost('/learn-plan/list',params: params);

  learnPlanDetail(params) async => normalPost('/learn-plan/detail',params: params);
  learnPlanUnSubmitNum(params) async => normalPost('/learn-plan/un-submit-num',params: params);

  commentList(params) async => normalPost('/comment/list',params: params);

  doctorLectureSharePic(lectureId) => normalPost('/doctor-lecture/share-pic',params:{'lectureId':lectureId});
}
