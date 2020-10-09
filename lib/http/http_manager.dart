import 'package:dio/dio.dart';
import 'package:doctor/http/result_data.dart';
import 'package:doctor/http/servers.dart';
import 'package:doctor/http/session_manager.dart';
import 'package:doctor/route/navigation_service.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Map<String, String> msgMap = {
  'networkError': '网络异常，请稍后再试',
  'httpError': '请求错误',
  'dataError': '请求错误'
};

/// 已登出错误码
List<String> outLoginCodes = ['100101', '100102', '100104', '100105'];

/// 鉴权失败错误码，需更新session
List<String> authFailCodes = ['100103'];

/// 鉴权错误
List<String> authErrorCodes = ['00010001'];

/// HTTP请求类
class HttpManager {
  /// 缓存工厂函数单例对象
  static final Map<String, HttpManager> _cache = <String, HttpManager>{};

  factory HttpManager(String server) {
    return _cache.putIfAbsent(server, () => HttpManager._internal(server));
  }

  /// 请求实例
  Dio dio;

  /// 初始化
  HttpManager._internal(String server) {
    String baseUrl = servers[server];
    if (dio == null) {
      BaseOptions _baseOptions =
          BaseOptions(baseUrl: baseUrl, connectTimeout: 10000);
      dio = Dio(_baseOptions);
    }
  }

  /// get请求
  Future get(String path,
      {Map<String, dynamic> params,
      showLoading = true,
      loadingText,
      ignoreSession = false,
      ignoreErrorTips = false,
      Options options}) {
    return this.request('get', path,
        query: params,
        showLoading: showLoading,
        ignoreSession: ignoreSession,
        ignoreErrorTips: ignoreErrorTips,
        options: options);
  }

  /// post请求
  Future post(String path,
      {Map<String, dynamic> params,
      showLoading = true,
      loadingText,
      ignoreSession = false,
      ignoreErrorTips = false,
      Options options}) {
    return this.request('post', path,
        params: params,
        showLoading: showLoading,
        ignoreSession: ignoreSession,
        ignoreErrorTips: ignoreErrorTips,
        options: options);
  }

  /// request请求
  Future request(String method, String path,
      {Map<String, dynamic> params,
      Map<String, dynamic> query,
      showLoading = true,
      loadingText = '加载中...',
      ignoreSession = false,
      ignoreErrorTips = false,
      Options options}) async {
    if (showLoading) {
      EasyLoading.show(status: loadingText);
    }
    Response response;
    try {
      Options _options = options ?? Options(method: method);
      if (_options.method == null) {
        _options.method = method;
      }
      if (!ignoreSession) {
        String session = SessionManager().getSession();
        if (session == null) {
          // 锁定所有请求
          // dio.lock();
          // TODO: 获取session
        }
        _options.headers['_ticketObject'] = session;
      }
      response = await dio.request(path,
          queryParameters: query, data: params, options: _options);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        EasyLoading.showToast(msgMap['httpError']);
        return new ResultData('ERROR', '-1', msgMap['httpError'], {});
      }

      ResultData data = ResultData.fromJson(response.data);
      if (data.status.toUpperCase() == 'ERROR') {
        if (!ignoreSession) {
          // 会话过期，重新登录
          if (outLoginCodes.indexOf(data.errorCode) != -1) {
            // TODO: 跳转到登录页
            EasyLoading.showToast(data.errorMsg ?? msgMap['dataError']);
            NavigationService().pushNamedAndRemoveUntil(
                RouteManager.LOGIN, (Route<dynamic> route) => false);
            return {};
          }
          // 需更新session
          if (authFailCodes.indexOf(data.errorCode) != -1) {
            // TODO: 更新session
            EasyLoading.showToast(data.errorMsg ?? msgMap['dataError']);
            NavigationService().pushNamedAndRemoveUntil(
                RouteManager.LOGIN, (Route<dynamic> route) => false);
            return {};
          }
          // 错误
          if (authErrorCodes.indexOf(data.errorCode) != -1) {
            // TODO: 错误处理
            EasyLoading.showToast(data.errorMsg ?? msgMap['dataError']);
            NavigationService().navigateTo(RouteManager.LOGIN);
            return {};
          }
        }
        if (!ignoreErrorTips) {
          EasyLoading.showToast(data.errorMsg ?? msgMap['dataError'],
              duration: Duration(milliseconds: 1500));
          return {};
        }
      }

      if (showLoading) {
        EasyLoading.dismiss();
      }

      dynamic content = data.content ?? data;

      return content;
    } on DioError catch (e) {
      if (showLoading) {
        EasyLoading.dismiss();
      }
      print('error: $e');
      EasyLoading.showToast(msgMap['networkError']);
      return {};
    }
  }
}
