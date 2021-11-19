
import 'package:dio/dio.dart';
import 'package:doctor/http/host_provider.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:http_manager/http_manager.dart';

///
/// 用户登录回话过期时触发该异常
///
class SessionOutError extends Error {
  final String code;
  final String message;

  SessionOutError(this.code, this.message);
}

///
/// 服务器链接一场，http status code 非 200 时触发该异常
///
class HttpConnectionError extends Error {
  final String code;

  HttpConnectionError(this.code);
}

class SocketErrorInterceptor extends InterceptorsWrapper {
  SocketErrorInterceptor();

  SocketErrorInterceptor.wrap(Interceptors wrapper);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    RequestOptions options = err.requestOptions;

    if (err.error is SocketException) {
      print('-------------------------SocketException');
      var data = await retry(options);
      var resp = Response(requestOptions: options, data: data);
      handler.resolve(resp);
      return;
    }
    super.onError(err, handler);
  }

  Future retry(RequestOptions options) async {
    options.baseUrl = ApiHost.instance.apiHost;
    var data = await HttpManager.shared.request(
      options.method,
      ApiHost.instance.apiHost + options.uri.path,
      params: options.data,
    );
    return data;
  }
}

