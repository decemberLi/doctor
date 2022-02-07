import 'package:dio/dio.dart';
import 'package:doctor/pages/user/setting/update/app_repository.dart';
import 'package:doctor/pages/user/setting/update/app_update.dart';
import 'package:doctor/pages/user/setting/update/app_update_info.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/net_error.dart';
import 'package:http_manager/session_manager.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import '../../root_widget.dart';

///
/// 0、LogInterceptor
/// 1、ErrorInterceptor
/// 2、LoadingInterceptor
/// 3、BaseLineInterceptor
///
class LoadingProgressInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    EasyLoading.show();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    EasyLoading.dismiss();
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    EasyLoading.dismiss();
    super.onResponse(response, handler);
  }
}

class XLogInterceptor extends InterceptorsWrapper {
  final String tag = 'Http';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('-->$tag::Req::url [${options.uri}]');
    debugPrint('---->$tag::Req::method [${options.method}]');
    debugPrint('---->$tag::Req::headers [${options.headers}]');
    debugPrint('---->$tag::Req::params [${options.data}]');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("<--$tag::Resp::url ${response.realUri}");
    debugPrint("<----$tag::Resp::Status ${response.statusCode}");
    debugPrint("<----$tag::Resp::data ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}

class CommonReqHeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["_ticketObject"] = SessionManager.shared.session;
    options.headers["_appVersion"] = await PlatformUtils.getAppVersion();
    options.headers["_appVersionCode"] = "1000";//await PlatformUtils.getBuildNum();
    options.headers["_greyVersion"] = await PlatformUtils.getAppVersion();
    options.headers["_requestId"] = DateTime.now().millisecondsSinceEpoch;
    if (Platform.isAndroid) {
      options.headers['_platform'] = "Android";
    } else if (Platform.isIOS) {
      options.headers['_platform'] = "iOS";
    }

    handler.next(options);
  }
}

class CommonRespInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Map<String, dynamic> data = response.data;
    String status = data["status"];
    if (status.toUpperCase() == "ERROR") {
      String errorCode = data["errorCode"];
      if (outLoginCodes.contains(errorCode) ||
          authFailCodes.contains(errorCode)) {
        SessionManager.shared.session = null;
      } else if (errorCode == "00010012") {
        var context = NavigationService().navigatorKey.currentContext;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("${data["errorMsg"]}"),
                actions: [
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("去更新"),
                    onPressed: () async {
                      Navigator.pop(context);
                      EasyLoading.instance.flash(() async {
                        AppUpdateInfo updateInfo =
                            await AppRepository.checkVersion();
                        AppUpdateHelper.update(context, updateInfo);
                      });
                    },
                  ),
                ],
              );
            });
      }
      if (userAuthCode.contains(errorCode)) {
        throw data;
      }
      throw NetError(data["errorMsg"] ?? "请求错误");
    }
    response.data = response.data["content"] ?? response.data;
    handler.next(response);
  }
}
