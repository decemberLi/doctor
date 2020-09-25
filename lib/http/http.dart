import 'package:dio/dio.dart';
// import 'package:doctor/widget/loading.dart';

class HttpManagerOptions {
  bool showLoading;
  HttpManagerOptions({bool showLoading}) {
    this.showLoading = showLoading ?? false;
  }
}

class HttpManager {
  static final HttpManager _http = HttpManager._internal();
  factory HttpManager() => _http;

  static String baseUrl =
      'https://gateway-dev.e-medclouds.com/medclouds-ucenter/mobile';

  Dio dio;

  /// loading拦截器 */
  Interceptor loadingInterceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options) {
    print('onRequest');
    // Loading.showLoading();
    return options;
  }, onResponse: (Response response) async {
    print('onResponse');
    // Loading.hideLoading();
    return response;
  }, onError: (DioError e) async {
    print('onError');
    return e;
  });

  HttpManager._internal() {
    if (dio == null) {
      BaseOptions _baseOptions =
          BaseOptions(baseUrl: baseUrl, connectTimeout: 10000);
      dio = Dio(_baseOptions);
    }
  }

  Future request<T>(String method, String path,
      {Map<String, dynamic> params,
      Map<String, dynamic> query,
      HttpManagerOptions options}) async {
    try {
      // 清除所有拦截器
      dio.interceptors.clear();
      // 显示loading
      if (options != null && options.showLoading) {
        dio.interceptors.add(this.loadingInterceptor);
      }
      Response response = await dio.request(path,
          queryParameters: query,
          data: params,
          options: Options(method: method));
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }
}
